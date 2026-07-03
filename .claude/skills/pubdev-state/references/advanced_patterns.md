# Riverpod 詳細パターン（pubdev_viewer）

## パラメータ付き Notifier — Family provider

ルートパラメータ（パッケージ名など）を Notifier に渡すには `build()` に引数を追加して Family provider にする。引数ごとに自動キャッシュされ、コンパイル時に引数の受け渡しが強制される。

```dart
@riverpod
class PackageDetailNotifier extends _$PackageDetailNotifier {
  @override
  Future<PackageDetailState> build(String packageName) async {
    final repository = ref.watch(packageDetailRepositoryProvider);
    // detail と publisher は独立した API。Records + .wait で並列取得し応答時間を短縮する。
    final (detail, publisher) = await (
      repository.getPackageDetail(packageName),
      repository.getPackagePublisher(packageName),
    ).wait;
    // バージョンを build() 内で一度だけソート。リビルドごとの再計算を避けるため state に保持する。
    final sortedVersions = [...detail.versions]
      ..sort((a, b) => b.published.compareTo(a.published));
    return PackageDetailState(
      detail: detail,
      publisher: publisher,
      sortedVersions: sortedVersions,
    );
  }
}

// 使用側: ref.watch(packageDetailProvider('riverpod'))
// テスト: container.read(packageDetailProvider('http').future)
```

ルート側からパラメータを渡す方法は `/pubdev-navigation` 参照（Screen コンストラクタ経由で受け取り、`ref.watch(packageDetailProvider(name))` に渡す）。

---

## 並列 API コール（`.wait` パターン）

独立した API 呼び出しは**順次 await せず**、Records + `.wait` で並列実行する。
コード例は上記「パラメータ付き Notifier」の `build()` 内 `(detail, publisher)` 取得部を参照。

実際のファイル: `lib/features/package_detail/notifiers/package_detail_notifier.dart`

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

コードは [SKILL.md](../SKILL.md) の基本テンプレート `refresh()` を参照。
`ref.invalidateSelf()` で provider をリセットし `build()` を再実行、
`await future` で呼び出し元（RefreshIndicator 等）が完了を await できるようにする。

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
          const SnackBar(content: Text(AppStrings.loadMoreFailed)),
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
