# シリアライズ・コード生成

> 対象セクション: データ処理とシリアライズ / コード生成
> レビュー日: 2026-04-11

## サマリー

| 重要度 | 件数 |
|--------|------|
| Critical | 0 |
| Important | 0 |
| Minor | 0 |
| Good | 5 |

シリアライズとコード生成の構成は flutter.md のガイドラインに完全準拠。改善が必要な点は見当たらない。

## 指摘事項

### [Good] freezed + json_serializable による統合的なシリアライズ

- **説明:** flutter.md は「`json_serializable` を直接使わずに `freezed` パッケージを活用」と記載。全モデルクラスが `@freezed` アノテーションで定義され、`fromJson` / `toJson` が freezed 経由で自動生成されている。`json_annotation` の `@JsonKey` も適切に使用されている。

### [Good] build.yaml のスコープ設定

- **説明:** `build.yaml` でコード生成対象が以下のように適切にスコープされている:
  - freezed / json_serializable: `lib/core/models/**`, `lib/features/**/models/**`
  - riverpod_generator: `lib/core/api/**`, `lib/features/**/notifiers/**`, `lib/features/**/repository/**`
  - go_router_builder: `lib/app/router.dart`

  不要なディレクトリでのコード生成が防止されており、ビルド時間の最適化に貢献。

### [Good] @JsonKey による API フィールドマッピング

- **説明:** API レスポンスの snake_case フィールド（`next_url`, `archive_url`, `archive_sha256`, `issue_tracker`, `dev_dependencies`）が `@JsonKey(name: '...')` で適切にマッピングされている。Dart の camelCase 命名規則を維持しつつ、API スキーマ（`docs/openapi.yaml`）との整合性が保たれている。

### [Good] build_runner が dev_dependencies に含まれている

- **説明:** flutter.md の「build_runner が dev_dependencies に含まれていることを確認」に準拠。`build_runner: ^2.4.15` が `pubspec.yaml` の `dev_dependencies` に含まれている。

### [Good] 生成ファイルの analysis_options 除外

- **説明:** `analysis_options.yaml` で `.g.dart` と `.freezed.dart` ファイルが分析対象から除外されている。生成コードに対する不要な lint 警告が防止されている。

## 次のアクション

- [ ] （なし — 現状で問題なし）
