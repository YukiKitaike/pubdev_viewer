# pubdev_viewer — pub.dev パッケージ閲覧アプリ

## Commands

- `fvm flutter` / `fvm dart` — FVM 必須。`flutter`/`dart` 直接呼び出し禁止
- `fvm dart run build_runner build -d` — コード生成。freezed/riverpod モデル変更後は必須
- `fvm dart analyze` — エラー・警告ゼロを維持（マージ条件）
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

feature 間の直接依存禁止。共通処理は `core/`。新規 feature 追加は `/pubdev-new-feature` 参照

## Critical Rules

- **No interfaces** — Repository は具象クラスのみ
- **No UseCase** — Notifier → Repository 直接。中間クラスなし
- **No Either** — エラーは例外 + try/catch
- **No Entity split** — `fromJson`/`toJson` 持ちの 1 クラスで完結
- **No premature core promotion** — 2 feature で共有されてから `core/` 昇格
- **No hardcoded values** — トークン・`AppStrings` 必須（詳細: `.claude/rules/ui-tokens.md`）
- **No relative imports** — `package:pubdev_viewer/...` 形式のみ（例外: `.claude/rules/testing.md`）
- **WHY comments only** — WHAT 禁止。設計判断に 1〜2 行の日本語コメント

## Domain References

- 実装パターン: `/pubdev-ui`（UI・トークン）、`/pubdev-state`（Notifier）、`/pubdev-api-client`（API・Repository）、`/pubdev-models`（Freezed）、`/pubdev-navigation`（GoRouter）、`/pubdev-testing`（テスト）、`/flutter-tips`（Dart 規約）
- パススコープ制約: `.claude/rules/`（テスト・UI トークン）

## Git

Conventional Commits（日本語）。`feat`/`fix`/`refactor`/`docs`/`chore`
