# Phase 1: Core 層 レビュー結果

## 使用スキル
- `/pubdev-ui` — デザイントークン・テーマ・Widget パターン
- `/pubdev-models` — Freezed パターン検証
- `/flutter-riverpod-expert` — Riverpod プロバイダー設計

## 対象ファイル

- `lib/core/api/pub_dev_api_client.dart`
- `lib/core/error/app_exception.dart`
- `lib/core/models/pubspec.dart`
- `lib/core/strings/app_strings.dart`
- `lib/core/design_system/` 配下全ファイル
- `lib/core/widgets/` 配下全ファイル

---

## LGTM（問題なし）

### デザインシステム（pubdev-ui で確認）
- **AppSpacing**: 4dp グリッド完全準拠（xs=4, sm=8, md=12, lg=16, xl=20, xxl=24, xxxl=32）✅
- **AppRadius**: セマンティック命名で各コンポーネントの用途に対応。`sectionAccent`→`skeleton`→`avatar`→`button`→`card`→`full` の昇順で一貫性あり ✅
- **AppColors**: プリミティブカラーのみ定義。セマンティックカラーの混入なし ✅
- **AppThemeTokens.lerp()**: 全 6 フィールド（background, surface, border, cardBorder, skeletonBase, skeletonHighlight）を網羅 ✅
- **context.tokens**: null 安全フォールバック（`?? AppThemeTokens.light`）あり ✅
- **AppCardTheme.lerp()**: 全 3 フィールド（borderRadius, padding, margin）を網羅 ✅
- **cardElevatedShadow()**: `isDark` フラグで空リストを返す設計 ✅
- **design_system.dart**: バレルエクスポートで 7 トークン・拡張を 1 行インポート可能 ✅

### エラー処理（dart-best-practices で確認）
- **AppException**: `sealed class` + `final class` で型安全なエラー処理。`error_view.dart` の `switch` 文と完全に整合 ✅
- **AppException.toString()**: `message` を返すのみでスタックトレースを露出しない ✅

### 共通 Widget（flutter-dart-code-review で確認）
- **error_view.dart**: デザイントークン（AppSpacing, AppStrings）を全て使用。`Colors.xxx` の直書きなし ✅
- **skeleton_list_view.dart**: `AppColors.shimmerPlaceholder` を正しく使用。`Colors.white` の直書きなし ✅
- **AppStrings**: 文字列を集中管理。Widget 内にハードコード文字列なし ✅

### その他
- **Pubspec モデル**: `@freezed` + `fromJson/toJson` が 1 クラスで完結（No Entity split ルール遵守）✅
- **pubDevApiClient provider**: `@Riverpod(keepAlive: true)` でアプリ生存期間中 Dio を保持する設計は正しい（HTTP クライアントは state を持たないため安全）✅

---

## 要修正

| # | 優先度 | 観点 | ファイル | 行番号 | 問題 | 修正方針 |
|---|--------|------|----------|--------|------|----------|
| 1 | Medium | コード品質 | `lib/core/api/pub_dev_api_client.dart` | L74-80 | `if (e.error is SocketException) { throw const NetworkException(); } throw const NetworkException();` が冗長。`cancel` / `badCertificate` / `unknown` の全ケースが常に `NetworkException` を throw するため、`if` ブランチが dead code | `if (e.error is SocketException)` ブランチを削除。3 ケースを `throw const NetworkException()` 1行に統合 |

---

## 要検討（Low）

| # | 優先度 | 観点 | ファイル | 行番号 | 問題 | 修正方針 |
|---|--------|------|----------|--------|------|----------|
| 1 | Low | No hardcoded spacing | `lib/core/widgets/error_view.dart` | L44-45, L52 | `width: 80, height: 80`（エラーアイコンコンテナ）と `size: 36`（アイコンサイズ）がハードコード。サイズトークンが未定義 | プロジェクトにサイズトークン体系が不在のため現状維持。将来的に `AppIconSize` 等のサイズトークン追加を検討 |
| 2 | Low | 未使用フィールド | `lib/core/models/pubspec.dart` | L18-19 | `dependencies`, `devDependencies` が API レスポンスに含まれるが UI では未使用 | API 形状準拠のため許容。将来のパッケージ依存表示機能追加時に活用可能 |

---

## 修正結果

| # | 修正内容 | コミット |
|---|----------|---------|
| 1 | `pub_dev_api_client.dart`: dead code の `if (e.error is SocketException)` ブランチを削除、`cancel`/`badCertificate`/`unknown` を 1 つの `throw const NetworkException()` に統合 | Phase 8 でコミット |

---

## メモ（将来の参考）

- `AppRadius.sectionAccent = 2` はコメントで「セクションヘッダーの左ボーダーアクセント」と説明されているが、`section_header.dart` の `width: 3` とは値が異なる。`sectionAccent` は角丸半径のトークンであり、バーの幅ではない（Phase 5 で修正対象）
- `Pubspec.environment` フィールドも UI 未使用だが、API レスポンスのダイレクトマッピングとして許容範囲
- `loading_view.dart` が `CircularProgressIndicator.adaptive()` ではなく Material 専用 `CircularProgressIndicator` を使用している点は、デザイン方針（Material 統一）として許容
