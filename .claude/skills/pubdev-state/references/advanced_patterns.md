# Riverpod 詳細パターン（pubdev_viewer）

## パラメータ付き Notifier — 2 つの手法

ルートパラメータ（パッケージ名など）を Notifier に渡す方法は 2 つある。

### 手法 1: Family provider（build 引数）

`build()` に引数を追加すると Family provider になる。引数ごとにキャッシュされる。

```dart
@riverpod
class PackageDetailNotifier extends _$PackageDetailNotifier {
  @override
  Future<PackageDetailState> build(String packageName) async {
    final repository = ref.watch(packageDetailRepositoryProvider);
    // ...
  }
}

// 使用側: ref.watch(packageDetailProvider('riverpod'))
```

### 手法 2: ProviderScope override（このアプリの採用パターン）

スコープ付きプロバイダを作り、ルート側で `ProviderScope.overrides` に値を注入する。
Notifier は `dependencies` でスコープ追従を宣言し、`ref.watch` で値を取得する。

```dart
// lib/features/package_detail/providers/current_package_name_provider.dart
@riverpod
String currentPackageName(Ref ref) =>
    throw UnimplementedError('must be overridden');

// lib/features/package_detail/notifiers/package_detail_notifier.dart
// dependencies で currentPackageName のスコープに追従する。
@Riverpod(dependencies: [currentPackageName])
class PackageDetailNotifier extends _$PackageDetailNotifier {
  @override
  Future<PackageDetailState> build() async {
    final packageName = ref.watch(currentPackageNameProvider);
    final repository = ref.watch(packageDetailRepositoryProvider);
    // ...
  }
}

// 使用側: ref.watch(packageDetailProvider) — 引数不要
```

ルート側で `ProviderScope` をネストして override する（詳細は `/pubdev-navigation` 参照）。

### 使い分け基準

| 基準 | Family | ProviderScope override |
|------|--------|------------------------|
| 同じパラメータを使う provider が **1 つ** | シンプル | 過剰 |
| 同じパラメータを **複数の provider** が共有 | 全 provider に引数を渡す必要あり | 1 つの override で全体に伝播 |
| 安全性 | コンパイル時に引数が強制される | override 忘れは実行時エラー |
| キャッシュ | 引数ごとに自動キャッシュ | スコープ単位（画面遷移で破棄） |
| テスト | `provider('name').future` で直接テスト | `currentPackageNameProvider.overrideWithValue(...)` を overrides に追加 |

---

## 並列 API コール（`.wait` パターン）

独立した API 呼び出しは**順次 await せず**、Records + `.wait` で並列実行する。

```dart
// lib/features/package_detail/notifiers/package_detail_notifier.dart
@override
Future<PackageDetailState> build() async {
  final packageName = ref.watch(currentPackageNameProvider);
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
  final current = state.value;
  // Guard: null状態・ロード中・次ページなし の3つを必ずチェック
  if (current == null || current.isLoadingMore || current.nextUrl == null) {
    return;
  }

  // ローディング中フラグを立てつつ既存データを保持
  state = AsyncData(current.copyWith(isLoadingMore: true));

  try {
    final repository = ref.read(packageListRepositoryProvider); // メソッド内は read
    final response = await repository.getPackages(pageUrl: current.nextUrl);
    // async gap 後にプロバイダが破棄されていれば state 更新をスキップする。
    if (!ref.mounted) {
      return;
    }
    state = AsyncData(
      PackageListState(
        packages: [...current.packages, ...response.packages], // 結合
        nextUrl: response.nextUrl,
      ),
    );
  } on AppException catch (e) {
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
  final current = state.value;
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
    final asyncState = ref.watch(packageListProvider);

    // 副作用（Snackbar・ナビゲーション）は ref.listen で
    ref.listen(packageListProvider, (_, next) {
      final error = next.value?.loadMoreError;
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('追加読み込みに失敗しました')),
        );
        // エラーを即座にクリアする。クリアしないと state が変わるたびに
        // ref.listen が再発火し、同じ Snackbar が繰り返し表示される。
        ref.read(packageListProvider.notifier).clearLoadMoreError();
      }
    });

    return Scaffold(
      body: asyncState.when(
        loading: () => const SkeletonListView(),  // 初回ロード
        error: (error, _) => ErrorView(
          error: error,
          onRetry: () => ref.read(packageListProvider.notifier).refresh(),
        ),
        data: (state) => RefreshIndicator(
          onRefresh: () =>
              ref.read(packageListProvider.notifier).refresh(),
          child: ListView.builder(/* ... */),
        ),
      ),
    );
  }
}
```
