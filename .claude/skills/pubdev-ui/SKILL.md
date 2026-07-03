---
name: pubdev-ui
description: >
  pubdev_viewer のデザイントークン・テーマ・Widget パターン。
  スクリーン・カード・リストタイル・スケルトンローダー等の UI コンポーネントを
  作成・編集する際に使用。「画面を作って」「UI」「デザイントークン」「テーマ」
  「Widget」と言われたときに参照。AppSpacing/AppRadius/AppThemeTokens の使い方を提供する。
---

# UI パターン（pubdev_viewer）

## デザインシステムのインポート

全トークンは1つのバレルファイルからインポートする:

```dart
import 'package:pubdev_viewer/core/design_system/design_system.dart';
// AppSpacing, AppRadius, AppTextSize, AppColors, AppThemeTokens,
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

## 等幅フォントサイズトークン（AppTextSize）

通常の本文・見出しは `TextTheme` を使う。`AppTextSize` は JetBrains Mono
等幅フォント（バージョン番号・日付・バッジ等）専用:

```dart
AppTextSize.mono10  // 小バッジ
AppTextSize.mono12  // 本文相当
AppTextSize.mono14  // 強調
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

## Widget パターン

**新しい画面を作るとき**のみ [widget_patterns.md](references/widget_patterns.md) を参照（HookConsumerWidget、ScrollController、ValueKey、Safe Area、Core Utils）。カードやコンポーネントの作成ではデザイントークン情報（上記セクション）で十分なので読まなくてよい。

基本ルール:
- スクリーンは `HookConsumerWidget` を継承（実例: [package_list_screen.dart](lib/features/package_list/screens/package_list_screen.dart)）
- Widget は**ヘルパーメソッドではなくプライベートクラス**に分割（`class _MyCard extends StatelessWidget`）
- `lib/core/utils/` の既存ユーティリティを確認し、同等処理を再実装しない

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

// ❌ 補間・プレフィックス付き文字列をウィジェット側で組み立てる
Text('v$version')           // AppStrings.versionLabel(version) を使う
// → 定数で表現できない動的文字列は AppStrings の static メソッドとして定義する
//   例: static String versionLabel(String version) => 'v$version';
```

