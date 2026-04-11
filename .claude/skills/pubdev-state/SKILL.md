---
name: pubdev-state
description: >
  pubdev_viewer の Riverpod AsyncNotifier パターン。
  状態管理・ページネーション（loadMore）・リフレッシュ・並列 API コール・エラーハンドリングを
  実装する際に使用。このアプリで実際に使われているパターンを実例付きで提供する。
---

# Riverpod 状態管理パターン（pubdev_viewer）

このアプリは `riverpod_generator` の `@riverpod` アノテーションを使用。
`StateNotifier`・`ChangeNotifier`・bare `Provider` は feature で使わない。

---

## 基本パターン: AsyncNotifier

`build()` が非同期初期ロードを担う。Riverpod が自動で `AsyncValue<T>` にラップする。

```dart
// lib/features/package_list/notifiers/package_list_notifier.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/package_list_state.dart';
import '../repository/package_list_repository.dart';

part 'package_list_notifier.g.dart';

@riverpod
class PackageListNotifier extends _$PackageListNotifier {
  @override
  Future<PackageListState> build() async {
    final repository = ref.watch(packageListRepositoryProvider); // build() 内は watch
    final response = await repository.getPackages();
    return PackageListState(
      packages: response.packages,
      nextUrl: response.nextUrl,
    );
  }
}
```

実際のファイル: [lib/features/package_list/notifiers/package_list_notifier.dart](lib/features/package_list/notifiers/package_list_notifier.dart)

---

## パラメータ付き Notifier

ルートパラメータ（パッケージ名など）が必要な場合、クラスの `build()` に引数を追加。

```dart
@riverpod
class PackageDetailNotifier extends _$PackageDetailNotifier {
  @override
  Future<PackageDetailState> build(String packageName) async { // ← 引数を追加
    final repository = ref.watch(packageDetailRepositoryProvider);
    // ...
  }
}

// 使用側: ref.watch(packageDetailNotifierProvider('riverpod'))
```

---

## 並列 API コール（`.wait` パターン）

独立した API 呼び出しは**順次 await せず**、Records + `.wait` で並列実行する。

```dart
// lib/features/package_detail/notifiers/package_detail_notifier.dart
@override
Future<PackageDetailState> build(String packageName) async {
  final repository = ref.watch(packageDetailRepositoryProvider);
  final (detail, publisher) = await (          // ← 同時に発火
    repository.getPackageDetail(packageName),
    repository.getPackagePublisher(packageName),
  ).wait;
  return PackageDetailState(detail: detail, publisher: publisher);
}
```

実際のファイル: [lib/features/package_detail/notifiers/package_detail_notifier.dart](lib/features/package_detail/notifiers/package_detail_notifier.dart)

---

## ページネーション（loadMore パターン）

```dart
Future<void> loadMore() async {
  final current = state.valueOrNull;
  // Guard: null状態・ロード中・次ページなし の3つを必ずチェック
  if (current == null || current.isLoadingMore || current.nextUrl == null) {
    return;
  }

  // ローディング中フラグを立てつつ既存データを保持
  state = AsyncData(current.copyWith(isLoadingMore: true));

  try {
    final repository = ref.read(packageListRepositoryProvider); // メソッド内は read
    final response = await repository.getPackages(pageUrl: current.nextUrl);
    state = AsyncData(
      PackageListState(
        packages: [...current.packages, ...response.packages], // 結合
        nextUrl: response.nextUrl,
      ),
    );
  } on Exception catch (e) {
    // エラー時: 既存データを保持したままエラーを state に格納
    state = AsyncData(current.copyWith(isLoadingMore: false, loadMoreError: e));
  }
}
```

---

## リフレッシュパターン

`ref.invalidateSelf()` で provider をリセットし `build()` を再実行。
`await future` で呼び出し元が完了を await できるようにする。

```dart
Future<void> refresh() async {
  ref.invalidateSelf();
  await future;
}
```

---

## エラーのクリア

`loadMoreError` などを state に保持する場合、クリア用メソッドも提供する。

```dart
void clearLoadMoreError() {
  final current = state.valueOrNull;
  if (current == null) return;
  state = AsyncData(current.copyWith(loadMoreError: null));
}
```

---

## Screen 側のパターン

```dart
class PackageListScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 状態の購読
    final asyncState = ref.watch(packageListNotifierProvider);

    // 副作用（Snackbar・ナビゲーション）は ref.listen で
    ref.listen(packageListNotifierProvider, (previous, next) {
      final error = next.valueOrNull?.loadMoreError;
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('追加読み込みに失敗しました')),
        );
        ref.read(packageListNotifierProvider.notifier).clearLoadMoreError();
      }
    });

    return Scaffold(
      body: asyncState.when(
        loading: () => const SkeletonListView(),  // 初回ロード
        error: (error, _) => ErrorView(
          error: error,
          onRetry: () => ref.invalidate(packageListNotifierProvider),
        ),
        data: (state) => RefreshIndicator(
          onRefresh: () =>
              ref.read(packageListNotifierProvider.notifier).refresh(),
          child: ListView.builder(/* ... */),
        ),
      ),
    );
  }
}
```

---

## ルール早見表

| 場面 | 使うもの |
|------|----------|
| `build()` 内で依存取得 | `ref.watch(...)` |
| `build()` 以外のメソッド | `ref.read(...)` |
| 副作用（Snackbar 等） | `ref.listen(...)` |
| 全リフレッシュ | `ref.invalidateSelf()` / `ref.invalidate(provider)` |
| 別 provider の強制再ロード | `ref.invalidate(otherProvider)` |

---

## やってはいけないこと

```dart
// ❌ メソッド内で ref.watch（build() 以外での watch は禁止）
Future<void> loadMore() async {
  final repo = ref.watch(repositoryProvider); // NG
}

// ❌ 順次 await（独立した呼び出しを直列化しない）
final detail = await repository.getDetail(name);
final publisher = await repository.getPublisher(name); // 並列にすべき

// ❌ Either<Failure, T> パターン（例外を使う）
// ❌ StateNotifier や ChangeNotifier の使用
```
