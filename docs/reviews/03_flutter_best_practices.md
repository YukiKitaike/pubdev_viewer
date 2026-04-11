# Flutter Widget ベストプラクティス

> 対象セクション: Flutter のベストプラクティス
> レビュー日: 2026-04-11

## サマリー

| 重要度 | 件数 |
|--------|------|
| Critical | 0 |
| Important | 2 |
| Minor | 1 |
| Good | 4 |

Widget 構成の基本は良好。`const` コンストラクタの活用やコンポジションパターンが適切に実装されている。ただし、プライベートヘルパーメソッドの Widget クラス化と、build 内での副作用に改善の余地がある。

## 指摘事項

### [Important] プライベートヘルパーメソッドを Widget クラスに変換すべき

- **対象ファイル:** `lib/features/package_detail/screens/package_detail_screen.dart:76-104`
- **ガイドライン参照:** flutter.md > Flutter のベストプラクティス > プライベート Widget（Widget を返すプライベートヘルパーメソッドではなく、小さなプライベート Widget クラスを使用）
- **現状:**
  ```dart
  Widget _buildShareButton(PackageDetailState state) {
    return IconButton(
      icon: const Icon(Icons.share),
      onPressed: () => SharePlus.instance.share(...),
    );
  }

  Widget _buildExternalLinkButton(PackageDetailState state) {
    final url = state.detail.latest.pubspec.homepage ??
        state.detail.latest.pubspec.repository;
    if (url == null || url.isEmpty) {
      return const SizedBox.shrink();
    }
    return IconButton(
      icon: const Icon(Icons.open_in_new),
      onPressed: () => launchUrl(Uri.parse(url)),
    );
  }
  ```
- **リスク:** ヘルパーメソッドは親 Widget の `build` メソッド内で呼ばれるため、親の再ビルド時に必ず再実行される。独立した Widget クラスにすることで、Flutter フレームワークが再ビルドの必要性を独立に判断できるようになり、パフォーマンスが向上する。また、`onPressed` 内の `SharePlus.instance.share` と `launchUrl` にエラーハンドリングがない。
- **推奨対応:**
  ```dart
  class _ShareButton extends StatelessWidget {
    const _ShareButton({required this.packageName});
    final String packageName;

    @override
    Widget build(BuildContext context) {
      return IconButton(
        icon: const Icon(Icons.share),
        onPressed: () => SharePlus.instance.share(
          ShareParams(
            uri: Uri.parse('https://pub.dev/packages/$packageName'),
          ),
        ),
      );
    }
  }

  class _ExternalLinkButton extends StatelessWidget {
    const _ExternalLinkButton({required this.url});
    final String? url;

    @override
    Widget build(BuildContext context) {
      if (url == null || url!.isEmpty) {
        return const SizedBox.shrink();
      }
      return IconButton(
        icon: const Icon(Icons.open_in_new),
        onPressed: () => launchUrl(Uri.parse(url!)),
      );
    }
  }
  ```

### [Important] build 内での副作用（ページネーション発火）

- **対象ファイル:** `lib/features/package_list/screens/package_list_screen.dart:35-42`（`itemBuilder` 内）
- **ガイドライン参照:** flutter.md > Flutter のベストプラクティス > Build メソッドのパフォーマンス（高負荷な処理を build 内で行わない）
- **現状:**
  ```dart
  if (index == state.packages.length) {
    SchedulerBinding.instance
        .addPostFrameCallback((_) {
      ref.read(packageListNotifierProvider.notifier)
          .loadMore();
    });
    return const Padding(...);
  }
  ```
  `itemBuilder` は build フェーズ中に呼ばれるため、その中で `addPostFrameCallback` を使って `loadMore()` を発火させるのは副作用パターンに該当する。リスト末尾の Widget が再ビルドされるたびに `loadMore()` が呼ばれる可能性がある（`isLoadingMore` ガードがあるため実質的な多重呼び出しは防がれているが、設計上好ましくない）。
- **リスク:** 不必要な `loadMore()` 呼び出しの可能性。build メソッドの純粋性が損なわれる。
- **推奨対応:** `ScrollController` または `NotificationListener<ScrollNotification>` でスクロール位置を監視し、閾値到達時に `loadMore()` を呼ぶ方式に変更する。
  ```dart
  // HookConsumerWidget 内で useScrollController を使用
  final scrollController = useScrollController();

  useEffect(() {
    void onScroll() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        ref.read(packageListNotifierProvider.notifier).loadMore();
      }
    }
    scrollController.addListener(onScroll);
    return () => scrollController.removeListener(onScroll);
  }, [scrollController]);
  ```

### [Minor] _sortedVersions getter が build ごとにリスト再生成

- **対象ファイル:** `lib/features/package_detail/screens/widgets/versions_section.dart:14-19`
- **ガイドライン参照:** flutter.md > Flutter のベストプラクティス > リストのパフォーマンス
- **現状:**
  ```dart
  List<PackageDetailVersion> get _sortedVersions {
    return [...versions]
      ..sort(
        (a, b) => b.published.compareTo(a.published),
      );
  }
  ```
  `build` メソッド内で `_sortedVersions` が呼ばれるたび、新しいリストのコピーとソートが実行される。
- **リスク:** 現状のバージョン数では軽微だが、バージョン数が多いパッケージ（100+）でパフォーマンスに影響する可能性がある。
- **推奨対応:** Notifier またはモデル側でソート済みデータを提供するか、`build` 内でローカル変数にキャッシュする（現在 `final sorted = _sortedVersions;` で1回だけ呼んでいるため、実質的な問題は軽微）。

### [Good] const コンストラクタの適切な使用

- **説明:** `LoadingView`, `ErrorView`, `PackageListTile` 等で `const` コンストラクタが正しく定義されている。`build` メソッド内でも `const EdgeInsets.all(...)`, `const Icon(...)` 等の const 式が適切に使用されている。

### [Good] コンポジションによる UI 構築

- **説明:** 画面の構成要素が `OverviewSection`, `VersionsSection`, `PackageListTile` 等の独立した Widget に分割されており、継承ではなくコンポジションで複雑な UI が構築されている。

### [Good] StatelessWidget / HookConsumerWidget の使い分け

- **説明:** 状態管理が不要な Widget（`ErrorView`, `LoadingView`, `PackageListTile`, `OverviewSection`, `VersionsSection`）は `StatelessWidget`、Riverpod の状態を購読する画面（`PackageListScreen`, `PackageDetailScreen`）は `HookConsumerWidget` と適切に使い分けられている。`setState` は一切使用されていない。

### [Good] 遅延読み込みの活用

- **説明:** `PackageListScreen` で `ListView.builder` が使用されており、flutter.md の「長いリストには遅延読み込み方式の Widget を活用」に準拠。画面外のアイテムは描画されない。

## 次のアクション

- [ ] `_buildShareButton` / `_buildExternalLinkButton` をプライベート Widget クラスに変換
- [ ] ページネーション発火を `ScrollController` ベースに変更
