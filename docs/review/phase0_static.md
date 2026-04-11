# Phase 0: 静的解析・CLAUDE.md 準拠確認 レビュー結果

## 使用スキル
- `/flutter-dart-code-review` — Widget ベストプラクティス・静的解析観点
- `/vgv-static-security` — セキュリティ観点
- `/dart-best-practices` — Dart コードスタイル

## 実行コマンド結果

```
$ fvm dart analyze
Analyzing pubdev_viewer...
No issues found!
```

## LGTM（問題なし）

### CLAUDE.md 6 大ルール
- **No interfaces**: `abstract class XxxRepository` は存在しない ✅
- **No UseCase**: `use_case` / `UseCase` を含むクラス・ファイルは存在しない ✅
- **No Either**: `Either`, `Result<T>`, `fpdart`, `dartz` のインポートは存在しない ✅
- **No Entity split**: `entity/` ディレクトリは存在せず、モデルが feature 内で完結している ✅
- **No premature core promotion**: `core/` に feature 固有クラスの昇格なし ✅
- **print() 禁止**: Widget / Notifier / Repository のいずれにも `print()` 呼び出しなし ✅

### セキュリティ（vgv-static-security）
- **URL 外部リンク**: `_ExternalLinkButton` が `Uri.tryParse` + スキーム検証 (`https` / `http`) で検証済み。`http` 許可の理由がコメントで明記されている ✅
- **share_plus**: `_ShareButton` が `'https://pub.dev/packages/$packageName'` の固定テンプレートから URI を構築し、`Uri.tryParse` が null を返す場合は early return ✅
- **HTTPS 強制**: API ベースURL が `'https://pub.dev'`（`pub_dev_api_client.dart`）で HTTPS のみ ✅
- **シークレットのハードコード**: API キー・トークンの直書きなし ✅
- **ログ出力**: `Logger.severe()` でスタックトレース以外の機密情報の出力なし ✅

### コード品質（flutter-dart-code-review）
- **analysis_options.yaml**: `pedantic_mono` を使用（厳格なリントセット含む） ✅
- **generated files**: `.g.dart` / `.freezed.dart` が `.gitignore` に含まれていない（生成ファイルをコミットする方針で統一）→ プロジェクト方針として許容 ✅
- **context.mounted チェック**: `launchUrl` の async コールバックで `context.mounted` を確認済み（`package_detail_screen.dart` L230） ✅

---

## 要修正

| # | 優先度 | 観点 | ファイル | 行番号 | 問題 | 修正方針 |
|---|--------|------|----------|--------|------|----------|
| 1 | High | No hardcoded colors | `lib/features/package_list/screens/widgets/package_list_tile.dart` | L100 | `color: Colors.white` の直書き。`AppColors.shimmerPlaceholder` は Shimmer 用途限定（コメントで明示）で流用不可。アバターテキスト専用の白が未定義 | `AppColors.avatarText = Color(0xFFFFFFFF)` を追加し `Colors.white` を置換 |
| 2 | High | No hardcoded spacing | `lib/features/package_list/screens/widgets/package_list_tile.dart` | L127 | `vertical: 3` — AppSpacing に 3dp のトークンがない | `AppSpacing.xxs = 2` を新設し `AppSpacing.xxs` へ置換（視覚差は 1dp） |
| 3 | High | No hardcoded spacing | `lib/features/package_detail/screens/widgets/versions_section.dart` | L96 | `vertical: 2` — AppSpacing に 2dp のトークンがない（タイムライン縦線の margin） | `AppSpacing.xxs = 2` へ置換 |
| 4 | High | No hardcoded spacing | `lib/features/package_detail/screens/widgets/versions_section.dart` | L123-124 | `horizontal: 7, vertical: 2` — AppSpacing に 7dp / 2dp のトークンがない（LATEST バッジの padding） | `horizontal: AppSpacing.sm` (8dp), `vertical: AppSpacing.xxs` (2dp) へ置換 |
| 5 | High | No hardcoded spacing | `lib/features/package_detail/screens/widgets/section_header.dart` | L19-20 | `width: 3, height: 18` — セクションアクセントバーのサイズがハードコード | デザイントークン追加（詳細は修正結果を参照） |

---

## 要検討（Medium）

| # | 優先度 | 観点 | ファイル | 行番号 | 問題 | 修正方針 |
|---|--------|------|----------|--------|------|----------|
| 1 | Medium | セキュリティ | `lib/main.dart` | L20-23 | `Logger.root.level = Level.INFO` が `kDebugMode` 外にある。本番ビルドでも `INFO` レベルのログが出力される | `kDebugMode` 内に移動するか、本番では `Level.WARNING` 以上に変更することを検討 |

---

## 修正結果

| # | 修正内容 | コミット |
|---|----------|---------|
| 1-5 | `AppColors.avatarText`, `AppSpacing.xxs` 追加、ハードコード値をトークンに置換 | Phase 5 完了後にコミット |

---

## メモ（将来の参考）

- `AppRadius.sectionAccent = 2` は `section_header.dart` の radius 用トークンだが、同要素の `width: 3` とは別の概念。token 命名体系を整理する際は `width` と `radius` を分離することを推奨
- `section_header.dart` L31: `letterSpacing: 0.2` はハードコードだが、Typography トークンを持たないプロジェクトでは許容範囲
- `analysis_options.yaml` で `strict-casts`, `strict-inference`, `strict-raw-types` が未明示だが、`pedantic_mono` が内包しているため `flutter analyze` でエラーなし
