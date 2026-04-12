# pubdev_viewer — pub.dev パッケージ閲覧アプリ

## Commands

- `fvm flutter` / `fvm dart` — FVM 必須。`flutter`/`dart` 直接呼び出し禁止
- `fvm dart run build_runner build -d` — コード生成。freezed/riverpod モデル変更後は必須
- `fvm dart analyze` — エラー・警告ゼロを維持
- `fvm flutter test [path]` — テスト（パス省略で全体実行）

## Architecture

Feature-First + Riverpod。依存方向: `screens/` → `notifiers/` → `repository/` → `models/`

```
lib/
├── app/               # MaterialApp、GoRouter、テーマ
├── core/
│   ├── api/           # Dio ベース API クライアント
│   ├── design_system/ # デザイントークン
│   ├── error/         # sealed AppException
│   ├── models/        # 共有モデル（Pubspec）
│   ├── strings/       # AppStrings 定数
│   ├── utils/         # ユーティリティ
│   └── widgets/       # ErrorView、LoadingView、SkeletonListView
└── features/
    ├── package_list/  # 一覧・ページネーション
    └── package_detail/# 詳細・バージョン・パブリッシャー
```

feature 間の直接依存禁止。共通処理は `core/`。新規は `/pubdev-new-feature` 参照

## Critical Rules

- **No interfaces** — Repository は具象クラスのみ。テストは `Fake implements XxxRepository`
- **No UseCase** — Notifier → Repository 直接。中間クラスなし
- **No Either** — エラーは例外 + try/catch
- **No Entity split** — `fromJson`/`toJson` 持ちの 1 クラスで完結
- **No premature core promotion** — 2 feature で共有されてから `core/` 昇格
- **No hardcoded values** — 色・余白はデザイントークン、文字列は `AppStrings`
- **No relative imports** — `package:pubdev_viewer/...` 形式のみ
- **WHY comments only** — WHAT 禁止。設計判断に 1〜2 行の日本語コメント
- **Zero Linter errors** — `fvm dart analyze` でゼロ維持

## Design System

```dart
import 'package:pubdev_viewer/core/design_system/design_system.dart';
// AppSpacing.xs/sm/md/lg/xl/xxl/xxxl (4dp grid)
// AppRadius.skeleton/avatar/button/card/full
// context.tokens → AppThemeTokens (light/dark semantic colors)
```

## Testing

- Mock 禁止。`Fake implements XxxRepository`。フィクスチャ: `test/helpers/fixtures.dart`
- Notifier テスト: `ProviderContainer` + `tearDown` で `dispose()`

## Git

Conventional Commits（日本語）。`feat`/`fix`/`refactor`/`docs`/`chore`
