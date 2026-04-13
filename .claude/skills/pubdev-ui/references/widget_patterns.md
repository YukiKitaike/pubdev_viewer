# Widget パターン（pubdev_viewer）

## HookConsumerWidget — 標準スクリーン基底クラス

全スクリーンは `HookConsumerWidget` を継承する。
Flutter Hooks を使い、一時的なローカル状態を管理する:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PackageListScreen extends HookConsumerWidget {
  const PackageListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();

    useEffect(() {
      void onScroll() {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
          ref.read(packageListProvider.notifier).loadMore();
        }
      }
      scrollController.addListener(onScroll);
      return () => scrollController.removeListener(onScroll); // cleanup
    }, [scrollController]);

    // ...
  }
}
```

一時的なローカル状態（スクロール・アニメーション）は Hooks で管理。
Riverpod に上げない。

ref.listen の副作用パターン（Snackbar 表示・エラークリア等）は `/pubdev-state` を参照。

---

## プライベート Widget クラス（ヘルパーメソッドではなくクラス）

```dart
// クラスで分割
class _PackageCard extends StatelessWidget {
  const _PackageCard({required this.package});
  final PackageListItem package;

  @override
  Widget build(BuildContext context) { ... }
}

// NG: ヘルパーメソッドで分割（避ける）
Widget _buildPackageCard(PackageListItem package) { ... }
```

---

## Bottom Safe Area

スクロール可能なコンテンツの padding:

```dart
ListView.builder(
  padding: EdgeInsets.only(
    top: AppSpacing.sm,
    bottom: AppSpacing.lg + MediaQuery.paddingOf(context).bottom,
  ),
  // ...
)
```

---

## バージョン文字列のフォント

バージョン番号は JetBrains Mono で表示:

```dart
import 'package:google_fonts/google_fonts.dart';

Text(
  'v1.6.0',
  style: GoogleFonts.jetBrainsMono(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: theme.colorScheme.primary,
  ),
)
```

---

## ListView.builder のアイテムに ValueKey を付ける

`ListView.builder` が生成する各アイテムには、コンテンツを一意に識別する `ValueKey` を必ず付ける。

**理由:**
- Flutter の element recycling で別データが同じ position に割り当てられたとき、`State` が正しく再構築される（`didUpdateWidget` の分岐がキーで確実に発火）
- Marionette MCP からの自動操作で、特定のアイテムをキー名で指名可能になる
- リストのアニメーション・リオーダーで要素同一性が保たれる

```dart
// NG: key なし。リサイクルで別データが降ってきても同一要素扱い
ListView.builder(
  itemBuilder: (context, index) => PackageListTile(
    package: packages[index],
  ),
)

// OK: コンテンツ由来のユニークな値を ValueKey に含める
ListView.builder(
  itemBuilder: (context, index) {
    final package = packages[index];
    return PackageListTile(
      key: ValueKey('package_tile_${package.name}'),
      package: package,
    );
  },
)

// OK: loadMore 等の状態インジケータにも識別可能な key
if (index == packages.length) {
  return const Padding(
    key: ValueKey('package_list_load_more_indicator'),
    padding: EdgeInsets.all(AppSpacing.lg),
    child: Center(child: CircularProgressIndicator.adaptive()),
  );
}
```

**キー命名規則:**
- 用途プレフィックス + コンテンツ識別子: `'package_tile_${name}'` / `'version_tile_${version}'`
- 状態系インジケータは `_indicator` / `_placeholder` サフィックス
- `index` だけで作るのは NG（リサイクル時に同じ key が別データに振られる）

**適用例:** [lib/features/package_list/screens/package_list_screen.dart](lib/features/package_list/screens/package_list_screen.dart)

---

## Core Utils（UI 関連）

`lib/core/utils/` の UI 関連ユーティリティ:

```dart
import 'package:pubdev_viewer/core/utils/date_formatter.dart';
import 'package:pubdev_viewer/core/utils/gradient_selector.dart';
import 'package:pubdev_viewer/core/utils/url_utils.dart';

// 日付表示
Text(formatDate(version.published))  // → '2026-04-12'

// アバターグラデーション（文字列ハッシュで決定的に選択）
final gradient = selectGradientByName(packageName);

// pub.dev URL 構築・HTTPS バリデーション
final uri = pubDevPackageUrl(packageName);
if (isHttpsUrl(url)) { ... }
```

feature 内に private ヘルパー (`_computeGradient`, `_formatDate` 等) を作らず、core の util を使う。
