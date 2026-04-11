# pubdev_viewer

pub.dev のパッケージ情報を閲覧する Flutter アプリ。

## Tech Stack

- Flutter 3.41.x / Dart SDK ^3.11.4

## Architecture: Feature-First + Riverpod

```
lib/
├── app/                        # アプリ全体の設定（MaterialApp, ルーティング, テーマ）
├── core/                       # 共通基盤（ネットワーク, エラーハンドリング, 定数）
│   ├── api/                    #   API クライアント
│   └── error/                  #   エラー型
└── features/                   # 機能単位のモジュール
    ├── package_list/           #   Home 画面（パッケージ一覧）
    │   ├── models/              #     データクラス（freezed 等）
    │   ├── repository/          #     Repository, API 通信
    │   ├── notifiers/          #     Riverpod Notifier / AsyncNotifier
    │   └── screens/            #     画面, Widget
    └── package_detail/         #   Details 画面（パッケージ詳細）
        ├── models/
        ├── repository/
        ├── notifiers/
        └── screens/
```

### ルール

- feature 間の直接依存は禁止。共通処理は `core/` に置く。
- 各 feature 内の依存方向: `screens/` → `notifiers/` → `repository/` → `models/`
  - `models/` は純粋なデータクラスのみ。他レイヤーに依存しない。
  - `repository/` は API 通信と Repository を担当する。
  - `notifiers/` は Riverpod の Notifier/AsyncNotifier で状態管理を行う。
  - `screens/` は `ref.watch` で notifiers を購読し UI を構築する。
- 状態管理は Riverpod に統一する。setState は原則使わない。
- API スキーマは `docs/openapi.yaml` に定義済み。モデル作成時はこれを参照する。
- 画面仕様は `docs/overview.md` を参照する。

### やらないこと（Clean Architecture 化の防止）

- **Entity と models を分離しない。** `fromJson` / `toJson` を持つ1クラスで完結させる。API レスポンスとドメインモデルの構造が実際に異なる場合のみ、変換用の別クラスを作る。
- **Repository のインターフェース（abstract class）を作らない。** 具象クラスを直接使う。テスト時は mocktail 等でクラスごとモックする。
- **UseCase クラスを作らない。** Repository を呼ぶだけのパススルーは不要。Notifier から直接 Repository を呼ぶ。複数サービスの調整が必要になったら Service クラスを作る。
- **DataSource 層を分離しない。** Remote / Local / Cache の抽象化は Repository 内で直接扱う。
- **`Either<Failure, T>` パターンを使わない。** エラーは例外で表現し、try/catch で処理する。
- **先回りして抽象化しない。** インターフェース、ヘルパー、ユーティリティは、2つ以上の箇所で実際に必要になってから作る。
- **feature 固有のモデルを最初から `core/` に置かない。** 2つ以上の feature で共有される時点で昇格させる。
