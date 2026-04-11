# Phase 3: Repository 層 レビュー結果

## 使用スキル
- `/flutter-riverpod-expert` — Riverpod プロバイダー設計
- `/pubdev-state` — Repository パターン確認

## 対象ファイル

- `lib/features/package_list/repository/package_list_repository.dart`
- `lib/features/package_detail/repository/package_detail_repository.dart`

---

## LGTM（問題なし）

### No interfaces ルール
- **PackageListRepository**: `abstract` / `interface` キーワードなし。具象クラスのみ ✅
- **PackageDetailRepository**: `abstract` / `interface` キーワードなし。具象クラスのみ ✅

### Riverpod プロバイダー設計（pubdev-state・flutter-riverpod-expert で確認）
- **ref.watch の使用**: Provider 関数内（= build() 相当）で `ref.watch(pubDevApiClientProvider)` を使用。`pubDevApiClient` が再生成された際に Repository も追従する設計 ✅
- **keepAlive**: `@riverpod`（keepAlive なし）でセッション中に破棄・再生成可能。Repository は state を持たないため問題なし ✅
- **No UseCase**: Notifier → Repository の直接依存。中間層なし ✅

### エラー処理の責任分担
- Repository が `try-catch` を挟まず、ApiClient の例外をそのまま Notifier に伝播 ✅
- `fromJson` の `FormatException` / `TypeError` も同様に Notifier まで伝播→Riverpod の `AsyncError` として扱われる設計 ✅

### 実装品質
- **PackageListRepository.getPackages**: 単一メソッド、`pageUrl` オプションでページネーション対応 ✅
- **PackageDetailRepository**: `getPackageDetail` / `getPackagePublisher` の 2 メソッドで単一責任 ✅

---

## 要修正

なし（全チェック項目パス）

---

## 修正結果

| # | 修正内容 | コミット |
|---|----------|---------|
| — | 修正なし | — |

---

## メモ（将来の参考）

- `PackageListRepository` と `PackageDetailRepository` はどちらも `PubDevApiClient` に依存している。将来 feature 数が増えた場合も、Repository 単位で `apiClient` を注入する設計を維持する
- テスト側は `FakePackageListRepository` / `FakePackageDetailRepository` で Fake パターンを使用。No interfaces ルールに準拠しつつテスト可能な設計（Phase 7 で確認済み）
