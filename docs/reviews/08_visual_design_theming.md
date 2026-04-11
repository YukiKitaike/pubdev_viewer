# ビジュアルデザイン・テーマ

> 対象セクション: ビジュアルデザインとテーマ / テーマ設定 (Strict Theming) / Material Theming のベストプラクティス / 配色 (Color Scheme) ベストプラクティス / フォントのベストプラクティス
> レビュー日: 2026-04-11

## サマリー

| 重要度 | 件数 |
|--------|------|
| Critical | 0 |
| Important | 3 |
| Minor | 3 |
| Good | 5 |

Material 3 の基盤は整っているが、テーマの充実度に改善の余地がある。特にダークテーマの未実装、ThemeExtension の未使用、コンポーネントテーマのカスタマイズ不足が目立つ。一方で、Widget 内での色やフォントのハードコーディングは概ね回避されており、Strict Theming の基本は守られている。

## 指摘事項

### [Important] ダークテーマが未実装

- **対象ファイル:** `lib/app/theme.dart`, `lib/main.dart:9`
- **ガイドライン参照:** flutter.md > テーマ設定 > ライト/ダークテーマ（`theme` と `darkTheme` を使用して両方のモードをサポート）
- **現状:**
  ```dart
  // theme.dart
  final appTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    textTheme: GoogleFonts.notoSansJpTextTheme(),
    useMaterial3: true,
  );

  // main.dart
  MaterialApp.router(
    title: 'pub.dev Viewer',
    theme: appTheme,
    routerConfig: router,
  );
  ```
  `darkTheme` プロパティが `MaterialApp.router` に設定されていない。ライトテーマのみ。
- **リスク:** ダークモードを使用しているユーザーに対して、システム設定に関わらず常にライトテーマが表示される。目の疲れ、バッテリー消費増加、アクセシビリティの低下。
- **推奨対応:**
  ```dart
  // theme.dart
  final appLightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    textTheme: GoogleFonts.notoSansJpTextTheme(),
    useMaterial3: true,
  );

  final appDarkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
    ),
    textTheme: GoogleFonts.notoSansJpTextTheme(
      ThemeData.dark().textTheme,
    ),
    useMaterial3: true,
  );

  // main.dart
  MaterialApp.router(
    theme: appLightTheme,
    darkTheme: appDarkTheme,
    routerConfig: router,
  );
  ```

### [Important] ThemeExtension が未使用

- **対象ファイル:** `lib/app/theme.dart`
- **ガイドライン参照:** flutter.md > Material Theming のベストプラクティス > デザイン拡張（`ThemeExtension` を使用してカスタムスタイルの再利用可能な定義を作成）
- **現状:** `ThemeData` に含まれない独自のデザイントークン（カード装飾、セクション間の間隔等）が各 Widget でインラインで定義されている。
  ```dart
  // overview_section.dart — インラインの装飾定義
  decoration: BoxDecoration(
    border: Border.all(
      color: Theme.of(context).colorScheme.outline,
    ),
    borderRadius: BorderRadius.circular(8),
  ),
  ```
  同じ装飾パターンが `OverviewSection` と `VersionsSection` で重複している。
- **リスク:** デザインの一貫性が Widget ごとのインラインコードに依存しており、変更時に複数箇所の修正が必要。
- **推奨対応:**
  ```dart
  class AppCardTheme extends ThemeExtension<AppCardTheme> {
    const AppCardTheme({
      required this.borderRadius,
      required this.padding,
      required this.margin,
    });

    final double borderRadius;
    final EdgeInsets padding;
    final EdgeInsets margin;

    @override
    AppCardTheme copyWith({...}) => ...;
    @override
    AppCardTheme lerp(AppCardTheme? other, double t) => ...;
  }
  ```

### [Important] コンポーネントテーマのカスタマイズ不足

- **対象ファイル:** `lib/app/theme.dart`
- **ガイドライン参照:** flutter.md > テーマ設定 > コンポーネントテーマ（`appBarTheme` などの特定のプロパティを使用して個々の Material コンポーネントをカスタマイズ）
- **現状:** `ThemeData` は最小構成（`colorScheme`, `textTheme`, `useMaterial3` のみ）で、以下のコンポーネントテーマが未設定:
  - `appBarTheme` — AppBar のスタイル
  - `listTileTheme` — ListTile のスタイル
  - `filledButtonTheme` — FilledButton のスタイル
  - `iconButtonTheme` — IconButton のスタイル
  - `scaffoldBackgroundColor` — 背景色
- **リスク:** Material 3 のデフォルトスタイルがそのまま適用されるため、アプリ固有のデザインアイデンティティが弱い。
- **推奨対応:** 少なくとも `AppBar` と主要コンポーネントのテーマをカスタマイズ:
  ```dart
  final appTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    textTheme: GoogleFonts.notoSansJpTextTheme(),
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      elevation: 0,
    ),
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 16),
    ),
  );
  ```

### [Minor] fontWeight のハードコード

- **対象ファイル:** `lib/features/package_detail/screens/widgets/versions_section.dart:49-51`
- **ガイドライン参照:** flutter.md > テーマ設定 > ハードコーディング禁止（フォントサイズを直接指定しない。常に textTheme を使用）
- **現状:**
  ```dart
  style: Theme.of(context)
      .textTheme
      .bodyMedium
      ?.copyWith(
        fontWeight: FontWeight.w500,
      ),
  ```
  `textTheme` を起点にしているのは良いが、`fontWeight: FontWeight.w500` がハードコードされている。
- **リスク:** テーマ変更時にこの箇所のウェイトが連動しない。軽微だが Strict Theming の原則に反する。
- **推奨対応:** `textTheme` に `titleSmall` 等の適切な既存スタイルを使用するか、`ThemeExtension` でバージョン番号用のスタイルを定義する。

### [Minor] 背景テクスチャ・Glow 効果・アニメーションの未実装

- **対象ファイル:** プロジェクト全体
- **ガイドライン参照:** flutter.md > ビジュアルデザインとテーマ > 背景 / インタラクティブ要素 / アニメーション
- **現状:** flutter.md で記載されている以下のデザイン要素が未実装:
  - メイン背景のノイズテクスチャ
  - インタラクティブ要素の「発光（Glow）」効果
  - 画面遷移やリスト表示のアニメーション
- **リスク:** アプリの視覚的な洗練度が低下するが、機能面への影響はない。
- **推奨対応:** 優先度に応じて段階的に実装。`TweenAnimationBuilder` を活用してコードの複雑性を抑える。

### [Minor] レスポンシブ対応なし

- **対象ファイル:** 全画面 Widget
- **ガイドライン参照:** flutter.md > ビジュアルデザインとテーマ > レスポンシブ（モバイルと Web で完璧に動作し、異なる画面サイズに適応）
- **現状:** `LayoutBuilder` や `MediaQuery` を使用したレスポンシブレイアウトが一切実装されていない。タブレットや Web での表示が最適化されていない。
- **リスク:** タブレットサイズの画面で `ListView` が全幅を使い切り、可読性が低下する。Web 対応時に大幅な修正が必要になる。
- **推奨対応:** 画面幅に応じた最大幅制限を追加。
  ```dart
  LayoutBuilder(
    builder: (context, constraints) {
      final maxWidth = constraints.maxWidth > 600 ? 600.0 : constraints.maxWidth;
      return Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: /* existing content */,
        ),
      );
    },
  )
  ```

### [Good] ColorScheme.fromSeed の使用

- **説明:** flutter.md の「`ColorScheme.fromSeed` を使用して調和のとれたパレットを生成」に準拠。`Colors.blue` をシードカラーとして、Material 3 の色彩アルゴリズムによる自動パレット生成が有効。

### [Good] Google Fonts の一元定義

- **説明:** `GoogleFonts.notoSansJpTextTheme()` が `theme.dart` で一元的に定義されている。flutter.md の「Widget 内で `GoogleFonts.xxx()` を直接使用せず、`app_theme.dart` で定義した TextTheme を参照」に準拠。

### [Good] Widget 内での色ハードコード回避

- **説明:** 全ての Widget で `Theme.of(context).colorScheme.error`, `.primary`, `.outline` 等を使用して色を参照している。`Colors.red` 等の直接指定は存在しない。

### [Good] useMaterial3: true の設定

- **説明:** flutter.md の「Material 3 に準拠」に合致。`ThemeData` で `useMaterial3: true` が明示的に設定されている。

### [Good] テーマ経由の TextStyle 参照

- **説明:** 全画面で `Theme.of(context).textTheme.titleMedium`, `.bodyLarge`, `.bodySmall` 等が使用されている。`fontSize` の直接指定は存在しない（`fontWeight` のハードコードを除く）。

## 次のアクション

- [ ] ダークテーマ（`appDarkTheme`）を `theme.dart` に追加し、`main.dart` に `darkTheme` プロパティを設定
- [ ] `OverviewSection` / `VersionsSection` 共通のカード装飾を `ThemeExtension` で定義
- [ ] `AppBar`, `ListTile` 等の主要コンポーネントテーマをカスタマイズ
- [ ] `fontWeight: FontWeight.w500` のハードコードを解消
