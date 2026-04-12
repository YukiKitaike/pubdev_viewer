# pub.dev Viewer

[pub.dev](https://pub.dev) の Dart パッケージを閲覧する Flutter アプリ。Material Design 3 に準拠したクリーンな UI で、パッケージの検索・詳細確認・共有が行えます。

[![Flutter](https://img.shields.io/badge/Flutter-3.41.6-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-^3.11.4-0175C2?logo=dart)](https://dart.dev)
[![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20Android-lightgrey)](https://flutter.dev)

## 機能

- **パッケージ一覧** — スケルトンローディングと引っ張り更新付きの無限スクロール一覧
- **パッケージ詳細** — 説明文、バージョン履歴（タイムライン表示）、パブリッシャー情報
- **共有・外部リンク** — パッケージをシェアしたり、ホームページ / リポジトリをブラウザで開く
- **ライト / ダークテーマ** — アプリバーからトグル切り替え
- **プラットフォーム対応 UX** — 触覚フィードバック、iOS バウンス、Android 予測的バック、セーフエリア対応

## スクリーンショット

| パッケージ一覧 | パッケージ詳細 |
|:---:|:---:|
| ![パッケージ一覧](docs/screenshots/package_list.png) | ![パッケージ詳細](docs/screenshots/package_detail.png) |

## セットアップ

### 前提条件

- [FVM](https://fvm.app)（Flutter バージョン管理）がインストール済みであること

### インストール

```bash
# ピン留めされた Flutter バージョンをインストール
fvm install

# 依存パッケージを取得
fvm flutter pub get

# コード生成（freezed / Riverpod / GoRouter / JSON）
fvm dart run build_runner build --delete-conflicting-outputs
```

> [!NOTE]
> グローバルの `flutter` / `dart` コマンドではなく、必ず `fvm flutter` / `fvm dart` を使用してください。

### Claude Code を使う場合（追加セットアップ）

[skills_sync](https://github.com/mono0926/skills-sync) をインストールし、プロジェクトの `skills.yaml` をグローバル設定にシンボリックリンクして同期します。

```bash
# skills_sync をグローバルインストール
dart pub global activate skills_sync

# プロジェクトルートで実行（skills.yaml を読み ~/.agents/skills/ に同期）
skills_sync sync

# Claude Code がスキルを認識できるようシンボリックリンクを作成
ln -sf ~/.agents/skills ~/.claude/skills
```

### 実行

```bash
fvm flutter run
```

## アーキテクチャ

**Feature-First + Riverpod** によるレイヤー構造を採用しています。

```
lib/
├── app/               # MaterialApp、ルーティング（GoRouter）、テーマ
├── core/              # 共通基盤
│   ├── api/           #   Dio ベースの pub.dev API クライアント
│   ├── design_system/ #   デザイントークン（色、余白、角丸、影）
│   ├── error/         #   sealed AppException 階層
│   ├── models/        #   共有モデル（Pubspec）
│   ├── strings/       #   UI 文字列定数（AppStrings）
│   ├── utils/         #   ユーティリティ（日付フォーマット、グラデーション選択、URL）
│   └── widgets/       #   共通ウィジェット（ErrorView、LoadingView、SkeletonListView）
└── features/
    ├── package_list/  # ホーム画面 — 一覧・ページネーション・状態管理
    └── package_detail/# 詳細画面 — 情報・バージョン・パブリッシャー
```

各 feature は `models/`、`repository/`、`notifiers/`、`screens/` で独立しています。feature 間の直接依存は禁止で、共通処理は `core/` に置きます。feature 間を直接参照すると変更の影響範囲が広がり循環依存のリスクも生じるため、共有が必要になった時点で `core/` に昇格させます。

**feature 内の依存方向：**
```
screens → notifiers → repository → models
```

## 技術スタック

| レイヤー | ライブラリ |
|---|---|
| 状態管理 | [flutter_riverpod](https://pub.dev/packages/flutter_riverpod) + [hooks_riverpod](https://pub.dev/packages/hooks_riverpod) + [flutter_hooks](https://pub.dev/packages/flutter_hooks) |
| ルーティング | [go_router](https://pub.dev/packages/go_router) |
| HTTP | [dio](https://pub.dev/packages/dio) |
| イミュータブルモデル | [freezed](https://pub.dev/packages/freezed) + [json_serializable](https://pub.dev/packages/json_serializable) |
| 国際化 / 日付フォーマット | [intl](https://pub.dev/packages/intl) |
| フォント | [google_fonts](https://pub.dev/packages/google_fonts)（Noto Sans JP、JetBrains Mono） |
| ローディングアニメーション | [shimmer](https://pub.dev/packages/shimmer) |
| レイアウト補助 | [gap](https://pub.dev/packages/gap) |
| 共有 / URL | [share_plus](https://pub.dev/packages/share_plus) + [url_launcher](https://pub.dev/packages/url_launcher) |
| ログ | [logging](https://pub.dev/packages/logging) |
| AI 操作 | [marionette_flutter](https://pub.dev/packages/marionette_flutter) + [marionette_logging](https://pub.dev/packages/marionette_logging) |

**コード生成（dev）：** [build_runner](https://pub.dev/packages/build_runner) + [riverpod_generator](https://pub.dev/packages/riverpod_generator) + [go_router_builder](https://pub.dev/packages/go_router_builder)（freezed / json_serializable は上記参照）

## テスト

```bash
fvm flutter test
```

## コード品質

```bash
# 静的解析
fvm dart analyze

# フォーマット
fvm dart format .
```

## AI 開発環境（Claude Code）

このプロジェクトは [Claude Code](https://claude.ai/code) での開発を前提としており、`.claude/` ディレクトリにプロジェクト固有の設定・カスタムスキルが含まれています。

### MCP Marionette

[Marionette](https://pub.dev/packages/marionette_flutter)（[MCP サーバー](https://pub.dev/packages/marionette_mcp)）により、Claude Code がデバッグモードの Flutter アプリを直接操作できます。セットアップと使い方は各パッケージの公式ドキュメントを参照してください。

### Skills Sync

[skills_sync](https://github.com/mono0926/skills-sync) を使い、GitHub 上の公開スキルリポジトリからプロジェクトに必要なスキルを一括管理しています。`skills.yaml` にソースと取捨選択を宣言し、`skills_sync sync` で `~/.agents/skills/` へグローバル同期します。セットアップ手順は[上記](#claude-code-を使う場合追加セットアップ)を参照してください。

詳細は [skills.yaml](skills.yaml) を参照してください。

### カスタムスキル

上記のグローバルスキルとは別に、`.claude/skills/` にプロジェクト固有のスキルが定義されています：

| スキル | 用途 |
|---|---|
| `pubdev-new-feature` | 新規 feature の追加ステップバイステップガイド（各 Step は下記スキルに委譲） |
| `pubdev-models` | Freezed + json_serializable モデルパターン |
| `pubdev-api-client` | Dio ベース API クライアント・Repository 層パターン・エラーハンドリング |
| `pubdev-state` | AsyncNotifier パターン・ページネーション・状態管理 |
| `pubdev-ui` | デザイントークン・テーマ・Widget パターン |
| `pubdev-navigation` | GoRouter + go_router_builder 型安全ルーティング |
| `pubdev-testing` | テストパターン（Fake・package:checks・タグ分類・createTestApp） |
| `dart-new-syntax` | Dart 3.7+ の新機能リファレンス（Dot shorthands 等） |

### プラグイン

[公式マーケットプレイス](https://claude.com/plugins)からインストール済みのプラグイン：

| プラグイン | 用途 |
|---|---|
| `claude-md-management` | CLAUDE.md の監査・改善・セッション学習の反映 |
| `claude-code-setup` | コードベース解析による自動化推奨 |
| `skill-creator` | スキルの新規作成・改善・パフォーマンス計測 |
| `plugin-dev` | プラグイン開発ツールキット |
| `hookify` | 会話パターンからカスタム hook を生成 |

### サブエージェント

`.claude/agents/` にプロジェクト固有のサブエージェントが定義されています：

| エージェント | 用途 |
|---|---|
| `code-reviewer` | CLAUDE.md の Critical Rules に基づくコードレビュー |
| `pattern-reviewer` | Riverpod・Freezed・テストのパターン準拠をスキル参照でレビュー |
| `test-reviewer` | `/pubdev-testing` スキルに基づくテストコード専用レビュー |

### Hooks

`.claude/settings.json` に以下の hook が設定されています：

| イベント | 内容 |
|---|---|
| PreToolUse | `.g.dart` / `.freezed.dart` の直接編集をブロック（`build_runner` で生成するため） |
| PostToolUse | ファイル編集後に `fvm dart format .` を自動実行 |
| PostToolUse | ファイル編集後に `fvm dart analyze` を自動実行（エラー・警告ゼロを維持） |

## API

pub.dev の公開 REST API（`https://pub.dev`）からデータを取得します。

| メソッド | エンドポイント | 用途 |
|---|---|---|
| GET | `/api/packages` | パッケージ一覧（ページネーション対応） |
| GET | `/api/packages/{name}` | パッケージ詳細 |
| GET | `/api/packages/{name}/publisher` | パブリッシャー情報 |
