# Phase 2: Feature Models 層 レビュー結果

## 使用スキル
- `/pubdev-models` — Freezed + json_serializable パターン（最重要）
- `/dart-best-practices` — 命名・構造

## 対象ファイル

### package_list/models/
- `package_list_response.dart`
- `package_list_item.dart`
- `package_list_version.dart`
- `package_list_state.dart`

### package_detail/models/
- `package_detail_response.dart`
- `package_detail_version.dart`
- `package_publisher_response.dart`
- `package_detail_state.dart`

---

## LGTM（問題なし）

### Freezed 設計（pubdev-models で確認）
- **全 API Response モデル**: `@freezed abstract class` + `_$` mixin + `fromJson` ファクトリ + `part *.g.dart` のパターンを完全準拠 ✅
- **全 State モデル**: `part *.g.dart` なし、`fromJson` なし（pubdev-models スキルの 2 種類モデル分類に従っている）✅
- **No Entity split ルール**: API 形状と UI モデルを 1 クラスで完結。Entity / Domain クラスへの分離なし ✅

### 個別ファイル確認
- **PackageListState.loadMoreError**: `AppException?` 型を使用。`pubdev-models` スキルのコメントは `Object?` を推奨しているが、Notifier が `on Object catch` で全例外を `AppException` に変換してから保存するため `AppException?` の方が型安全で適切 ✅
- **PackageListState.packages**: `@Default([])` で null vs 空リストの意味論を明確化 ✅
- **PackageDetailVersion._publishedFromJson / _publishedToJson**: Freezed の制約に従ってファイルトップレベルに配置（正しいアプローチ）✅
- **@JsonKey 使用**: スネークケース変換が必要な箇所のみ使用（`next_url`, `archive_url`, `archive_sha256`, `issue_tracker`）✅

### core への昇格（No premature core promotion ルール確認）
- **Pubspec**: `package_list_version.dart` と `package_detail_version.dart` の両方で使用 → `core/models/pubspec.dart` への昇格が正しい ✅
- **PackageListVersion / PackageDetailVersion**: 両者にフィールドの差異あり（`published`, `archiveSha256` は detail のみ）。`core` への統合は API 形状に反するため feature 内保持が正しい ✅
- **PackagePublisherResponse**: package_detail feature のみで使用 → feature 内保持が正しい ✅

### 命名・構造
- **PackageDetailResponse.advisoriesUpdated**: `String?` (nullable) として定義。OpenAPI 仕様（`docs/openapi.yaml`）で optional フィールドとして定義されているため正しい ✅
- **PackageDetailState**: シンプルな 2 フィールド構成（detail + publisher）で過剰な設計なし ✅

---

## 要修正

なし（全チェック項目パス）

---

## 要検討（Low）

| # | 優先度 | 観点 | ファイル | 行番号 | 問題 | 修正方針 |
|---|--------|------|----------|--------|------|----------|
| 1 | Low | モデルの一貫性 | `lib/features/package_list/models/package_list_state.dart` | L15 | `AppException?` vs pubdev-models スキルの `Object?` 推奨。スキルコメントに「Object? で何でもキャッチ」とあるが、現実装は Notifier が全例外を `AppException` に変換するため `AppException?` の方が意図が明確 | 現状維持。Notifier の変換ロジックと一貫しているため変更不要 |

---

## 修正結果

| # | 修正内容 | コミット |
|---|----------|---------|
| — | 修正なし | — |

---

## メモ（将来の参考）

- `PackageListVersion` と `PackageDetailVersion` の共通フィールド（`version`, `pubspec`, `archiveUrl`）は表面上似ているが、API レスポンスの schema が異なるため統合は不適切。現状の 2 feature 分離が正しい
- `PackageDetailState.publisher` が `required` だが `PackagePublisherResponse.publisherId` が nullable なので、publisher 未設定パッケージも `publisherId: null` で表現可能（Notifier 側でのハンドリングは Phase 4 で確認）
