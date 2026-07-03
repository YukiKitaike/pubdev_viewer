---
paths:
  - "lib/features/**"
  - "lib/app/**"
  - "lib/core/widgets/**"
---
# UI トークン制約

- 色・余白・角丸・等幅フォントサイズはデザイントークン必須（`AppSpacing` / `AppRadius` / `AppTextSize` / `context.tokens`）。数値・カラーコードのハードコード不可
- トークンは `package:pubdev_viewer/core/design_system/design_system.dart` のバレルから import
- Widget 内でのテーマ条件分岐（`brightness == Brightness.light ? ... : ...`）不可。light/dark 対応色は `context.tokens` を使用
- UI 表示文字列は `AppStrings` に集約。`'v$version'` のような補間文字列も static メソッドとして定義
- ローディング・エラー表示は共通 Widget（`SkeletonListView` / `LoadingView` / `ErrorView`）を再利用

トークン値・テーマ・Widget パターンの詳細は `/pubdev-ui` スキルを参照。
