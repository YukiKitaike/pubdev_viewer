---
name: pubdev-new-feature
description: >
  pubdev_viewer に新しい feature を追加する際のステップバイステップガイド。
  新しいスクリーン・機能・API データを追加する場合に使用。
  models → repository → notifier → screen の全レイヤーを網羅する。
---

# 新 Feature の追加手順

Feature-First + Riverpod アーキテクチャ。
新 feature は `lib/features/<feature_name>/` 配下に構成する。

```
lib/features/<feature_name>/
├── models/        # Response（fromJson あり）+ State（fromJson なし）
├── repository/    # 具象クラスのみ（No interfaces）
├── notifiers/     # @riverpod class AsyncNotifier
└── screens/       # HookConsumerWidget + widgets/
```

---

## Step 1: モデル → `/pubdev-models`

Response + State モデルを作成。コード生成: `fvm dart run build_runner build -d`

## Step 2: Repository → `/pubdev-api-client`

具象クラス + `@riverpod` Provider。テンプレートは `/pubdev-api-client` の「Repository 層パターン」参照。
コード生成: `fvm dart run build_runner build -d`

## Step 3: Notifier → `/pubdev-state`

build/loadMore/refresh/エラーハンドリング。コード生成: `fvm dart run build_runner build -d`

## Step 4: Screen → `/pubdev-ui`

`HookConsumerWidget` + `asyncState.when`。文字列は `AppStrings` に定義（既存の重複確認を先に行う）。
`lib/core/utils/` の既存ユーティリティを確認し、同等処理を再実装しない。

## Step 5: ルート登録 → `/pubdev-navigation`

`lib/app/router.dart` に TypedGoRoute を追加。コード生成: `fvm dart run build_runner build -d`

## Step 6: テスト → `/pubdev-testing`

`test/features/<feature_name>/` に `lib/` と同じ階層でテストを配置。
1. `test/helpers/fakes.dart` に Fake クラスを追加
2. `test/helpers/fixtures.dart` に const JSON + ビルダー関数を追加
3. Notifier → Repository → Screen の順で作成

---

## やってはいけないこと

- feature 固有モデルを最初から `core/models/` に置く（2 feature 共有後に昇格）
- Repository にインターフェースを定義する（具象クラスのみ）
- UseCase 中間クラスを挟む（Notifier → Repository 直接）
- Screen が Repository を直接参照する（依存方向違反）

---

## チェックリスト

- [ ] models/（`/pubdev-models`）
- [ ] repository/（`/pubdev-api-client`）
- [ ] notifiers/（`/pubdev-state`）
- [ ] screens/（`/pubdev-ui`）
- [ ] router.dart（`/pubdev-navigation`）
- [ ] テスト（`/pubdev-testing`）
- [ ] `fvm dart run build_runner build -d`
- [ ] `fvm dart analyze` エラー 0 件
- [ ] `fvm flutter test` PASS
