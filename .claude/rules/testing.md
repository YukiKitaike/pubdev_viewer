---
paths:
  - "test/**"
---
# テスト制約

- Mock 禁止（`@GenerateMocks` / `when()` / `verify()` 不可）。Test Double は `Fake implements XxxRepository` のみ
- 全テストファイルの先頭に `@Tags(['unit'])` または `@Tags(['widget'])` を必須付与
- Notifier テストは `ProviderContainer.test()` を使用（`ProviderContainer()` 直接生成 + 手動 dispose は不可）
- 値検証は `package:checks` の `check()` を優先。`expect()` は finder 系（`find.*`）と `throwsA`（async 例外のプロパティ検証）のみに限定
- テストデータは `test/helpers/fixtures.dart` の共有フィクスチャを使用（インライン JSON 定義は不可）
- テスト名は日本語（`group()` はクラス名のまま英語）
- 新機能は TDD で進める: Red（失敗テスト）→ Green（最小実装）→ Refactor
- 例外: `test/` ヘルパー間のみ相対 import を許容（No relative imports ルールの唯一の例外）
- 選択実行: `fvm flutter test -t unit` / `fvm flutter test -t widget`

実装パターン・テンプレートは `/pubdev-testing` スキルを参照。
