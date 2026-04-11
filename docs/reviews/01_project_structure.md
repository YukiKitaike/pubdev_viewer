# プロジェクト構造・アーキテクチャ

> 対象セクション: インタラクションガイドライン / プロジェクト構造 / アプリケーションアーキテクチャ
> レビュー日: 2026-04-11

## サマリー

| 重要度 | 件数 |
|--------|------|
| Critical | 0 |
| Important | 0 |
| Minor | 1 |
| Good | 5 |

プロジェクト構造は flutter.md のガイドラインにほぼ完全に準拠している。Feature-First アーキテクチャが正しく実装され、レイヤー間の依存方向も適切に管理されている。

## 指摘事項

### [Minor] core/models/ の配置判断

- **対象ファイル:** `lib/core/models/pubspec.dart`
- **ガイドライン参照:** flutter.md > アプリケーションアーキテクチャ > 機能ごとの構成 / CLAUDE.md > やらないこと
- **現状:** `Pubspec` モデルが `core/models/` に配置されている。このモデルは `package_list` と `package_detail` の両 feature から参照されている。
- **リスク:** なし。CLAUDE.md の「2つ以上の feature で共有される時点で昇格」ルールに合致しており、正しい配置である。ただし今後モデルが増える場合、`core/models/` が肥大化しないよう注意が必要。
- **推奨対応:** 現状維持。新規モデル追加時は、まず feature 内に配置し、共有が必要になった段階で `core/` に昇格させるフローを継続する。

### [Good] Feature-First ディレクトリ構造

- **説明:** `lib/features/package_list/` と `lib/features/package_detail/` が flutter.md の「機能ごとの構成」に準拠。各 feature 内に `models/`, `repository/`, `notifiers/`, `screens/` のサブディレクトリが整備されている。

### [Good] レイヤー依存方向の遵守

- **説明:** 全 feature で `screens/ → notifiers/ → repository/ → models/` の依存方向が守られている。`import` 文を確認した結果、逆方向の依存は存在しない。

### [Good] core/ の適切な構成

- **説明:** `core/api/`（API クライアント）、`core/error/`（例外型）、`core/widgets/`（共有 Widget）、`core/models/`（共有モデル）が適切に分離されている。feature 固有のロジックが core に混入していない。

### [Good] エントリーポイントのシンプルさ

- **説明:** `main.dart` は `ProviderScope` でラップした `MaterialApp.router` のみの構成で、flutter.md の「lib/main.dart を主要なエントリーポイントとする標準的な構造」に合致している。

### [Good] Feature 間の直接依存禁止

- **説明:** `package_list` と `package_detail` の間に直接の import 依存が存在しない。画面遷移は `go_router` のルート定義を通じて行われており、feature 間の疎結合が実現されている。

## 次のアクション

- [ ] （なし — 現状で問題なし）
