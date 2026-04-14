---
name: pubdev-state
description: >
  pubdev_viewer の Riverpod AsyncNotifier パターン。
  状態管理・ページネーション（loadMore）・リフレッシュ・並列 API コール・エラーハンドリングを
  実装する際に使用。「Notifier を書いて」「状態管理」「loadMore」「refresh」
  「ref.watch」と言われたときに参照。
---

# Riverpod 状態管理パターン（pubdev_viewer）

このアプリは `riverpod_generator` の `@riverpod` アノテーションを使用。
`StateNotifier`・`ChangeNotifier`・bare `Provider` は feature で使わない。

---

## 基本パターン: AsyncNotifier テンプレート

`build()` が非同期初期ロードを担う。Riverpod が自動で `AsyncValue<T>` にラップする。

```dart
// lib/features/<feature>/notifiers/<feature>_notifier.dart
import 'package:pubdev_viewer/features/<feature>/models/<feature>_state.dart';
import 'package:pubdev_viewer/features/<feature>/repository/<feature>_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '<feature>_notifier.g.dart';

@riverpod
class FeatureNotifier extends _$FeatureNotifier {
  @override
  Future<FeatureState> build() async {
    final repository = ref.watch(featureRepositoryProvider); // build() 内は watch
    final response = await repository.getData();
    return FeatureState(items: response.items);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}
```

実例: [package_list_notifier.dart](lib/features/package_list/notifiers/package_list_notifier.dart), [package_detail_notifier.dart](lib/features/package_detail/notifiers/package_detail_notifier.dart)

---

## 詳細パターン

以下の実装例は [advanced_patterns.md](references/advanced_patterns.md) を参照:

- パラメータ付き Notifier（Family provider）
- 並列 API コール（Records + `.wait`）
- ページネーション（loadMore + Guard + `ref.mounted`）
- リフレッシュ / エラーのクリア
- Screen 側のパターン（`asyncState.when` / `ref.listen`）

---

## ルール早見表

| 場面 | 使うもの |
|------|----------|
| `build()` 内で依存取得 | `ref.watch(...)` |
| `build()` 以外のメソッド | `ref.read(...)` |
| 副作用（Snackbar 等） | `ref.listen(...)` |
| 全リフレッシュ | `ref.invalidateSelf()` + `await future` |
| async gap 後のガード | `if (!ref.mounted) return` |

---

## やってはいけないこと

```dart
// ❌ メソッド内で ref.watch（build() 以外での watch は禁止）
Future<void> loadMore() async {
  final repo = ref.watch(repositoryProvider); // NG: ref.read を使う
}

// ❌ 順次 await（独立した呼び出しを直列化しない）
final detail = await repository.getDetail(name);
final publisher = await repository.getPublisher(name); // Records + .wait で並列にすべき

// ❌ AsyncError でエラーを表現（既存データが消える）
state = AsyncError(e, stackTrace); // NG: AsyncData 内にエラーを保持する

// ❌ Either<Failure, T> パターン / StateNotifier / ChangeNotifier
```
