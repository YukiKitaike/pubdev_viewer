# Phase 6: App 層 レビュー結果

## 使用スキル
- `/pubdev-ui` — テーマ設計
- `/flutter-riverpod-expert` — keepAlive Notifier
- `/vgv-static-security` — アプリ初期化

## 対象ファイル

- `lib/app/router.dart`
- `lib/app/theme.dart`
- `lib/app/theme_mode_notifier.dart`
- `lib/main.dart`

---

## LGTM（問題なし）

### router.dart
- **TypedGoRoute**: 型安全ルーティング。`path: '/'` と `path: 'packages/:name'` のネスト構造が正しい ✅
- **パスパラメーター**: go_router が `:name` を自動 URL エンコードするため、スペースや特殊文字を含むパッケージ名にも対応 ✅
- **型安全ナビゲーション**: `PackageDetailRoute(name: ...).go(context)` で文字列ハードコードなし ✅
- **生成コード**: `part 'router.g.dart'` で `$appRoutes` が正しく生成されている ✅

### theme.dart
- **ThemeData.extensions**: `[defaultCardTheme, tokens]` — `AppCardTheme` と `AppThemeTokens` の両方が登録されており `context.tokens` / `context.extension<AppCardTheme>()` が機能する ✅
- **appLightTheme / appDarkTheme**: `Brightness` を引数に取る `_buildTheme()` 関数で両テーマを統一管理 ✅
- **Colors.transparent**: テーマ構成での使用（AppBar surfaceTintColor / Card shadowColor）はデザインカラーではなく透明度の意味論的値。Widget 内ハードコードではないため許容 ✅
- **CardThemeData.margin: EdgeInsets.zero**: `AppCardTheme.margin` と異なるコンポーネントへの設定で二重設定なし ✅

### theme_mode_notifier.dart
- **@Riverpod(keepAlive: true)**: テーマモードをアプリ生存期間中保持する設計が正しい ✅
- **toggle()**: `ThemeMode.dark → ThemeMode.light`, それ以外 → `ThemeMode.dark` の switch が正しい ✅

### main.dart（vgv-static-security で確認）
- **MarionetteBinding**: `kDebugMode` ブロック内でのみ初期化。本番ビルドでは `WidgetsFlutterBinding.ensureInitialized()` を使用 ✅
- **ProviderScope**: アプリ最上位に配置 ✅

---

## 要修正

なし

---

## 要検討（Low）

| # | 優先度 | 観点 | ファイル | 行番号 | 問題 | 修正方針 |
|---|--------|------|----------|--------|------|----------|
| 1 | Low | ハードコード数値（テーマ設定） | `lib/app/theme.dart` | L51 | `fontSize: 20` — AppBarTheme の titleTextStyle に直接指定。`AppTextSize` はモノスペースフォント用なので適用不可。テーマ設定（Widget 内でない）なので CLAUDE.md の「Widget 内禁止」ルールの厳密な適用外 | 現状維持。テーマ構成ファイルの数値は Widget 内ハードコードとは性質が異なる |
| 2 | Low | 計算式 | `lib/app/theme.dart` | L69 | `AppSpacing.sm - 2` — ChipTheme の padding に計算式を使用。6dp は AppSpacing にない値だが演算で求めている | 現状維持。テーマ構成での計算式は許容範囲 |
| 3 | Medium | セキュリティ・ログ | `lib/main.dart` | L20-23 | `Logger.root.level = Level.INFO` が `kDebugMode` 外。本番ビルドでも INFO ログが出力される。ログに含まれるデータは API エンドポイント URL のみで機密情報なし | 本番では `Level.WARNING` 以上に変更することを検討（現状 URL のみでリスク低い） |

---

## 修正結果

| # | 修正内容 | コミット |
|---|----------|---------|
| — | 修正なし（要検討事項のみ）| — |

---

## メモ（将来の参考）

- `GoogleFonts.notoSansJpTextTheme()` により英語パッケージ名テキストも NotoSansJP でレンダリングされる。これは意図的なデザイン統一（英字も日本語フォントでカバー可能）
- テーマ永続化（SharedPreferences 等）は現時点で不要とする方針。`ThemeMode.system` デフォルトで再起動ごとにリセットされる設計は許容範囲
