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

// pub.dev URL 構築・バリデーション
final uri = pubDevPackageUrl(packageName);
if (isHttpUrl(url)) { ... }
```

feature 内に private ヘルパー (`_computeGradient`, `_formatDate` 等) を作らず、core の util を使う。
