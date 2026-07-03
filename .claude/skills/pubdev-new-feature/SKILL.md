---
name: pubdev-new-feature
description: >
  pubdev_viewer に新しい feature を縦切りで追加するステップバイステップガイド。
  models → repository → notifier → screen → route → test の全レイヤーを網羅する。
  /pubdev-new-feature <feature名> で明示的に呼び出して使用する。
  単一レイヤーのみの作業（既存画面の UI 修正・モデル追加等）は
  各ドメインスキル（/pubdev-ui, /pubdev-models 等）を直接使用する。
disable-model-invocation: true
---

# 新 Feature の追加手順

`$ARGUMENTS` feature を以下の手順で追加する。

Feature-First + Riverpod アーキテクチャ。
新 feature は `lib/features/$ARGUMENTS/` 配下に構成する。

```
lib/features/$ARGUMENTS/
├── models/        # Response（fromJson あり）+ State（fromJson なし）
├── repository/    # 具象クラスのみ（No interfaces）
├── notifiers/     # @riverpod class AsyncNotifier
└── screens/       # HookConsumerWidget + widgets/
```

---

> Step 1〜3, 5 の後はコード生成を実行する（コマンドは CLAUDE.md の Commands）。

## Step 1: モデル → `/pubdev-models`

Response + State モデルを作成。

## Step 2: Repository → `/pubdev-api-client`

具象クラス + `@riverpod` Provider。テンプレートは `/pubdev-api-client` の「Repository テンプレート」参照。

## Step 3: Notifier → `/pubdev-state`

build/loadMore/refresh/エラーハンドリング。

## Step 4: Screen → `/pubdev-ui`

`HookConsumerWidget` + `asyncState.when`。
文字列・トークンの規約（AppStrings 集約・補間文字列の static メソッド化）と
`lib/core/utils/` の既存ユーティリティ確認は `/pubdev-ui` の「やってはいけないこと」参照。

## Step 5: ルート登録 → `/pubdev-navigation`

`lib/app/router.dart` に TypedGoRoute を追加。

## Step 6: テスト → `/pubdev-testing`

`test/features/$ARGUMENTS/` に `lib/` と同じ階層でテストを配置。
1. `test/helpers/fakes.dart` に Fake クラスを追加
2. `test/helpers/fixtures.dart` に const JSON + ビルダー関数を追加
3. Notifier → Repository → Screen の順で作成

---

## やってはいけないこと

- CLAUDE.md の Critical Rules 違反（No interfaces / No UseCase / No premature core promotion 等）
- Screen が Repository を直接参照する（`screens/` → `notifiers/` → `repository/` の依存方向違反）

---

## チェックリスト

- [ ] models/（`/pubdev-models`）
- [ ] repository/（`/pubdev-api-client`）
- [ ] notifiers/（`/pubdev-state`）
- [ ] screens/（`/pubdev-ui`）
- [ ] router.dart（`/pubdev-navigation`）
- [ ] テスト（`/pubdev-testing`）
- [ ] コード生成・analyze エラー 0 件・全テスト PASS（コマンドは CLAUDE.md の Commands）
