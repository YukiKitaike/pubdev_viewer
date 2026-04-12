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

- [Flutter](https://flutter.dev/docs/get-started/install)（[FVM](https://fvm.app) でバージョン管理）
- [FVM](https://fvm.app/docs/getting_started/installation) がグローバルにインストール済みであること

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

# プロジェクトの skills.yaml をグローバル設定にシンボリックリンク
ln -sf "$(pwd)/skills.yaml" ~/.config/skills_sync/skills.yaml

# スキルを同期（~/.claude/skills/ に配置される）
skills_sync sync
```

> [!NOTE]
> シンボリックリンクにより、`skills.yaml` の変更がリポジトリで管理され、`skills_sync sync` だけで常に最新のスキル構成が反映されます。

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
│   └── widgets/       #   共通ウィジェット（ErrorView、SkeletonListView）
└── features/
    ├── package_list/  # ホーム画面 — 一覧・ページネーション・状態管理
    └── package_detail/# 詳細画面 — 情報・バージョン・パブリッシャー
```

各 feature は `models/`、`repository/`、`notifiers/`、`screens/` で独立しています。feature 間の直接依存は禁止で、共通処理は `core/` に置きます。feature 間を直接参照すると変更の影響範囲が広がり循環依存のリスクも生じるため、共有が必要になった時点で `core/` に昇格させます。

**feature 内の依存方向：**
```
screens → notifiers → repository → models
```

### 設計方針

| ルール | 理由 |
|---|---|
| **Repository はインターフェースなし**（具象クラスのみ） | 抽象インターフェースは多態性が必要な場合にのみ意味を持つ。テストは `Fake implements XxxRepository` で代替できるため不要な間接層を避ける |
| **UseCase なし**（Notifier が Repository を直接呼ぶ） | このスケールのアプリでは UseCase は呼び出しをそのまま委譲するだけの空洞になりやすく、追跡コストが増えるだけ |
| **Either / Result なし**（エラーは例外で表現） | Dart の例外機構はイディオマティックで、Result 型は全コールサイトに型変換のボイラープレートを強制する |
| **モデルは1クラスで完結**（Entity 分割なし） | API 形状と UI が実際に異なる場合のみ変換クラスを作る。形状が同じなのに DTO/Entity を分けるのは重複を生むだけ |
| **feature 固有モデルは 2 feature で共有されてから `core/` に昇格** | 早期の `core/` 昇格は「いつか使うかも」という推測に基づく抽象化になりやすい。実際に共有されるまで feature 内に留める |
| **色・余白の直書き禁止** | ライト / ダークテーマ対応と UI の一貫性維持のため、すべてデザイントークン経由にする |

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

**コード生成（dev）：**

| ツール | 用途 |
|---|---|
| [build_runner](https://pub.dev/packages/build_runner) | コード生成の実行基盤 |
| [riverpod_generator](https://pub.dev/packages/riverpod_generator) | `@riverpod` アノテーションから Provider を生成（`.g.dart`） |
| [go_router_builder](https://pub.dev/packages/go_router_builder) | 型安全なルート定義を生成（`.g.dart`） |
| [freezed](https://pub.dev/packages/freezed) | イミュータブルモデルを生成（`.freezed.dart`） |
| [json_serializable](https://pub.dev/packages/json_serializable) | `fromJson` / `toJson` を生成（`.g.dart`） |

## テスト

```bash
fvm flutter test
```

### テスト構成

`lib/` の構造を `test/` 配下に鏡像します：

```
test/
├── helpers/
│   ├── fakes.dart      # Fake リポジトリ（Mockito Mock の代わりに使用）
│   └── fixtures.dart   # const JSON フィクスチャ
└── features/
    ├── package_list/
    │   ├── notifiers/  # Notifier ユニットテスト（ProviderContainer）
    │   └── repository/ # Repository ユニットテスト
    └── package_detail/
        ├── notifiers/
        └── repository/
```

### テスト方針

- **Mock 禁止** — `Fake implements XxxRepository` パターンを使用。`@GenerateMocks` は使わない。Repository に抽象インターフェースがなく、Mockito の Mock より Fake の方がコールバックプロパティで挙動を明示できてシンプルなため
- **フィクスチャ共有** — テスト内にインライン JSON を書かず `test/helpers/fixtures.dart` を使う。モデルの変更時に修正箇所を1箇所に集約するため
- **ProviderContainer** — Notifier テストに使用。`tearDown` で必ず `container.dispose()` する。dispose 漏れはメモリリークを引き起こすため
- **Completer** — ローディング中の状態を検証するために future を保留して使用

## コード品質

```bash
# 静的解析
fvm dart analyze

# フォーマット（Edit / Write 後に PostToolUse hook で自動実行済み）
fvm dart format .
```

| ツール | 用途 |
|---|---|
| [pedantic_mono](https://pub.dev/packages/pedantic_mono) | 厳格な lint ルールセット |
| [riverpod_lint](https://pub.dev/packages/riverpod_lint) | Riverpod 固有の静的解析 |
| [custom_lint](https://pub.dev/packages/custom_lint) | カスタムリントの実行基盤 |

## AI 開発環境（Claude Code）

このプロジェクトは [Claude Code](https://claude.ai/code) での開発を前提としており、`.claude/` ディレクトリにプロジェクト固有の設定・カスタムスキルが含まれています。

### MCP Marionette

[Marionette](https://pub.dev/packages/marionette_flutter)（[MCP サーバー](https://pub.dev/packages/marionette_mcp)）により、Claude Code がデバッグモードの Flutter アプリを直接操作できます。セットアップと使い方は各パッケージの公式ドキュメントを参照してください。

### Skills Sync

[skills_sync](https://github.com/mono0926/skills-sync) を使い、GitHub 上の公開スキルリポジトリからプロジェクトに必要なスキルを一括管理しています。`skills.yaml` にソースと取捨選択を宣言し、`skills_sync sync` で `~/.claude/skills/` へグローバル同期します。セットアップ手順は[上記](#claude-code-を使う場合追加セットアップ)を参照してください。

**skills.yaml の構成：**

| ソース | 内容 |
|---|---|
| `kevmoo/dash_skills` | Dart 言語のベストプラクティス・テスト・CLI・パッケージメンテナンス |
| `flutter/skills` | Flutter 公式スキル（UI・ナビゲーション・国際化・ネットワーク等） |
| `VeryGoodOpenSource/very_good_ai_flutter_plugin` | Flutter セキュリティ静的解析 |
| `juparave/dotfiles` | Riverpod エキスパート |
| `jeffallan/claude-skills` | Flutter エキスパート |
| `affaan-m/everything-claude-code` | Flutter/Dart コードレビュー |
| `madteacher/mad-agents-skills` | Flutter 各種実装パターン（フォーム・アニメーション・状態管理等） |
| `rodydavis/skills` | Flutter 操作・スクリーンショット |
| `obra/superpowers` | ブレインストーミング・TDD・検証フロー |
| `wshobson/agents` | デザインシステム・モバイルデザイン・レスポンシブ |
| `anthropics/skills` | フロントエンドデザイン・スキル作成・PDF |
| その他 | UI/UX・プロンプトレビュー・README 作成等 |

プロジェクトのアーキテクチャと重複するスキル（`flutter-architecture`、`flutter-state-management` 等）は `!` プレフィックスで除外し、macOS 環境に不要な Linux/Windows セットアップスキルも除外しています。

### カスタムスキル

`.claude/skills/` にプロジェクト固有のスキルが定義されています：

| スキル | 用途 |
|---|---|
| `pubdev-new-feature` | 新規 feature の追加ステップバイステップガイド |
| `pubdev-state` | AsyncNotifier パターン・ページネーション・状態管理 |
| `pubdev-models` | Freezed + json_serializable モデルパターン |
| `pubdev-testing` | テストパターン（Fake・Notifier・Widget） |
| `pubdev-ui` | デザイントークン・テーマ・Widget パターン |

### 自動フォーマット（PostToolUse hook）

`.claude/settings.json` の `PostToolUse` hook により、ファイル編集後に `fvm dart format .` が自動実行されます。手動でのフォーマットは原則不要です。

## API

pub.dev の公開 REST API からデータを取得します。OpenAPI スキーマは [docs/openapi.yaml](docs/openapi.yaml) を参照してください。

| エンドポイント | 説明 |
|---|---|
| `GET /api/packages` | パッケージ一覧（ページネーション付き） |
| `GET /api/packages/{name}` | パッケージ詳細とバージョン |
| `GET /api/packages/{name}/publisher` | パブリッシャー情報 |
