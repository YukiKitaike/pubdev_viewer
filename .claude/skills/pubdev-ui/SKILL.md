---
name: pubdev-ui
description: >
  pubdev_viewer のデザイントークン・テーマ・Widget パターン。
  スクリーン・カード・リストタイル・スケルトンローダー等の UI コンポーネントを
  作成・編集する際に使用。AppSpacing/AppRadius/AppThemeTokens/HookConsumerWidget の
  使い方をこのアプリの実際のコードから提供する。
---

# UI パターン（pubdev_viewer）

## デザインシステムのインポート

全トークンは1つのバレルファイルからインポートする:

```dart
import '../../../core/design_system/design_system.dart';
// AppSpacing, AppRadius, AppColors, AppThemeTokens,
// AppCardTheme, defaultCardTheme, cardElevatedShadow が使用可能
```

---

## スペーシングトークン（4dp グリッド）

```dart
AppSpacing.xs   // 4
AppSpacing.sm   // 8
AppSpacing.md   // 12
AppSpacing.lg   // 16  ← デフォルトの画面余白
AppSpacing.xl   // 20  ← カード内パディング
AppSpacing.xxl  // 24
AppSpacing.xxxl // 32
```

縦横の余白は `Gap` パッケージを使う（Column/Row 内で SizedBox の代わりに）:

```dart
import 'package:gap/gap.dart';

Column(children: [
  const Text('title'),
  const Gap(AppSpacing.sm), // 8dp
  const Text('body'),
])
```

---

## ボーダーラジアストークン

```dart
AppRadius.sectionAccent  // 2  — セクションヘッダーの左ボーダーアクセント
AppRadius.skeleton       // 4  — スケルトンローディングのバー
AppRadius.avatar         // 11 — パッケージアバターの文字バッジ
AppRadius.button         // 12 — FilledButton 等
AppRadius.card           // 16 — カード・セクションコンテナ
AppRadius.full           // 100 — ピル型バッジ・チップ・バージョンタグ
```

---

## セマンティックカラー（AppThemeTokens）

Widget 内で `isLight ? Color(0xFF...) : Color(0xFF...)` を書かない。
`context.tokens` 拡張で light/dark 対応カラーを取得する:

```dart
// lib/core/design_system/extensions/app_theme_tokens.dart
final tokens = context.tokens;  // BuildContext 拡張

tokens.background       // Scaffold の背景色
tokens.surface          // カード・コンテナの面色
tokens.border           // セクション区切り・AppBar 下線
tokens.cardBorder       // カードの外枠ボーダー（ダークは少し明るい）
tokens.skeletonBase     // shimmer のベース色
tokens.skeletonHighlight // shimmer のハイライト色
```

---

## Material 3 テーマカラー

セマンティックな Material カラーは `Theme.of(context).colorScheme` を使う:

```dart
final theme = Theme.of(context);

theme.colorScheme.primary             // pub.dev ブルー (#0175C2)
theme.colorScheme.onSurface           // 主要テキスト
theme.colorScheme.onSurfaceVariant    // サブ・ミュートテキスト
theme.colorScheme.secondaryContainer  // パブリッシャーバッジ背景
theme.colorScheme.onSecondaryContainer // パブリッシャーバッジテキスト
```

---

## カードシャドウヘルパー

```dart
// ライトモードのみ微細なブルーシャドウ。ダークモードは空リストを返す。
boxShadow: cardElevatedShadow(
  theme.colorScheme.primary,
  isDark: theme.brightness == Brightness.dark,
)
```

---

## AppCardTheme — セクションカード

詳細画面の OverviewSection / VersionsSection で使うスタイル:

```dart
final cardTheme = Theme.of(context).extension<AppCardTheme>() ?? defaultCardTheme;
// cardTheme.borderRadius → AppRadius.card (16)
// cardTheme.padding      → EdgeInsets.all(AppSpacing.xl)  (20)
// cardTheme.margin       → EdgeInsets.symmetric(horizontal: AppSpacing.lg) (16)
```

実際のファイル: [lib/features/package_detail/screens/widgets/overview_section.dart](lib/features/package_detail/screens/widgets/overview_section.dart)

---

## 標準ローディング・エラー Widget

| Widget | 使う場面 |
|--------|----------|
| `SkeletonListView()` | 一覧画面の初回ロード（shimmer アニメーション） |
| `LoadingView()` | 詳細画面の初回ロード（中央に CircularProgressIndicator.adaptive()） |
| `ErrorView(error: e, onRetry: callback)` | エラー表示 + 再試行ボタン |

---

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
          ref.read(packageListNotifierProvider.notifier).loadMore();
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

---

## プライベート Widget クラス（ヘルパーメソッドではなくクラス）

```dart
// ✅ クラスで分割
class _PackageCard extends StatelessWidget {
  const _PackageCard({required this.package});
  final PackageListItem package;

  @override
  Widget build(BuildContext context) { ... }
}

// ❌ ヘルパーメソッドで分割（避ける）
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

## やってはいけないこと

```dart
// ❌ ハードコードカラー
color: Colors.red
color: const Color(0xFF0175C2)

// ❌ ハードコードサイズ
fontSize: 24
padding: const EdgeInsets.all(16)  // AppSpacing.lg を使う

// ❌ Widget 内でテーマ条件分岐
color: Theme.of(context).brightness == Brightness.light
    ? const Color(0xFFFFFFFF)
    : const Color(0xFF1A1A2E)  // context.tokens.surface を使う

// ❌ ハードコード文字列
Text('LATEST')              // AppStrings.latestBadge を使う
SectionHeader(label: 'Overview')  // AppStrings.sectionOverview を使う
// → UI 表示ラベル・メッセージは lib/core/strings/app_strings.dart に定義
```

---

## コメントルール

`/// パッケージ一覧画面。` のような WHAT docstring は不要。

WHY コメントが必要な典型パターン:
- マジックナンバー（スクロール閾値・itemCount 等）の根拠
- プラットフォーム固有の処理を分岐する理由
- HapticFeedback を入れる理由
- IntrinsicHeight 等のレイアウトトリックが必要な理由
