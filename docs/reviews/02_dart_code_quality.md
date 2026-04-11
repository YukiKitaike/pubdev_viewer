# Dart コード品質

> 対象セクション: コード品質 / Dart のベストプラクティス / ドキュメントの哲学
> レビュー日: 2026-04-11

## サマリー

| 重要度 | 件数 |
|--------|------|
| Critical | 1 |
| Important | 2 |
| Minor | 1 |
| Good | 5 |

基本的な Dart コーディング品質は高く、命名規則・Null Safety・async/await の使用が適切。ただし、API クライアントの非null表明、ロギングパッケージの不一致、公開 API ドキュメントの欠落が改善ポイント。

## 指摘事項

### [Critical] API クライアントの非null表明 (`response.data!`)

- **対象ファイル:** `lib/core/api/pub_dev_api_client.dart:48`
- **ガイドライン参照:** flutter.md > Dart のベストプラクティス > Null Safety（`!` 演算子は避ける）
- **現状:**
  ```dart
  return response.data!;
  ```
  Dio の `get<Map<String, dynamic>>` は `Response<Map<String, dynamic>>` を返すが、`data` プロパティは nullable（`T?`）である。サーバーが空レスポンスを返した場合にクラッシュする。
- **リスク:** 本番環境で 204 No Content や不正なレスポンスを受信した際に `Null check operator used on a null value` で即クラッシュ。
- **推奨対応:**
  ```dart
  final data = response.data;
  if (data == null) {
    throw const ServerException(
      500,
      'Empty response body',
    );
  }
  return data;
  ```

### [Important] ロギングパッケージの不一致

- **対象ファイル:** `lib/core/api/pub_dev_api_client.dart:6,12`
- **ガイドライン参照:** flutter.md > コード品質 > ログ（`logging` パッケージを使用）
- **現状:** `simple_logger` パッケージを使用している。
  ```dart
  import 'package:simple_logger/simple_logger.dart';
  final _logger = SimpleLogger()..mode = LoggerMode.log;
  ```
- **リスク:** flutter.md では `logging` パッケージの使用と「logger をグローバルに定義」を指定している。`simple_logger` は `logging` パッケージとは別のライブラリであり、ガイドラインとの不一致がある。
- **推奨対応:** `logging` パッケージに移行するか、チームとしてどちらを標準とするか決定し、flutter.md を更新する。
  ```dart
  import 'package:logging/logging.dart';
  final _logger = Logger('PubDevApiClient');
  ```

### [Important] 公開 API ドキュメントコメントの欠落

- **対象ファイル:** プロジェクト全体の公開クラス・メソッド
- **ガイドライン参照:** flutter.md > Dart のベストプラクティス > API ドキュメント / ドキュメントの哲学
- **現状:** 以下の公開クラス・メソッドにドキュメントコメント (`///`) が付与されていない:
  - `PubDevApiClient` クラスおよび全メソッド (`pub_dev_api_client.dart`)
  - `AppException`, `NetworkException`, `ServerException` (`app_exception.dart`)
  - `ErrorView`, `LoadingView` (`core/widgets/`)
  - `PackageListRepository`, `PackageDetailRepository` (各 repository)
  - `PackageListNotifier`, `PackageDetailNotifier` (各 notifier)
  - 全 Screen Widget クラス
  - 全 Model クラス（`Pubspec`, `PackageListResponse` 等）
- **リスク:** flutter.md は「すべての公開 API にドキュメントコメントを追加」と明記。dart doc 生成時に警告が発生し、API の意図が不明確になる。
- **推奨対応:** 各クラス・コンストラクタ・公開メソッドに `///` ドキュメントコメントを追加する。最初の文は簡潔な要約とし、「Why」を意識する。
  ```dart
  /// pub.dev API との HTTP 通信を担当するクライアント。
  ///
  /// [Dio] を内部で使用し、エラー時は [AppException] サブクラスをスローする。
  class PubDevApiClient {
  ```

### [Minor] UI 文字列のハードコード

- **対象ファイル:** `lib/core/widgets/error_view.dart:13-19`, `lib/features/package_detail/screens/widgets/overview_section.dart:25`, `lib/features/package_detail/screens/widgets/versions_section.dart:30`
- **ガイドライン参照:** flutter.md > コード品質 > 簡潔さ
- **現状:** 日本語 UI 文字列（`'通信エラーが発生しました。'`, `'Overview'`, `'Versions'` 等）がハードコードされている。
- **リスク:** 現状の規模では問題ないが、i18n 対応が必要になった場合に修正箇所が散在する。
- **推奨対応:** 現時点では許容。将来的に `flutter_localizations` + `intl` による多言語対応を検討する際にまとめて対応。

### [Good] sealed class による例外階層

- **説明:** `app_exception.dart` で `sealed class AppException` を使用し、`NetworkException` と `ServerException` をサブクラス化。モダンな Dart 3 のパターンを活用しており、網羅的な switch 文が可能。

### [Good] 命名規則の一貫性

- **説明:** クラス名は `PascalCase`、変数・関数は `camelCase`、ファイル名は `snake_case` で統一されている。省略形は使用されておらず、`PackageListResponse`, `packageDetailRepository` 等、記述的で明確な命名。

### [Good] async/await の適切な使用

- **説明:** 全ての非同期操作で `async/await` が正しく使用されている。`PackageDetailNotifier.build()` では Dart Records + `.wait` による並列 await が活用されており、モダンな非同期パターンが実装されている。

### [Good] Null Safety の適切な運用

- **説明:** `!` 演算子の使用は `pub_dev_api_client.dart:48` の1箇所のみ（上記 Critical で指摘済み）。他の全箇所で null チェックや `?.` 演算子が適切に使用されている。

### [Good] 例外処理パターンの適切さ

- **説明:** `pub_dev_api_client.dart` の `_get` メソッドで `DioException` を catch し、接続エラーとサーバーエラーを区別して `AppException` サブクラスに変換している。flutter.md の「catchして別の Exception に揃える意味のある処理」に合致。エラーの握りつぶしは存在しない。

## 次のアクション

- [ ] `pub_dev_api_client.dart:48` の `response.data!` を null チェック付きに修正
- [ ] ロギングパッケージを `logging` に統一するか、flutter.md のガイドラインを更新
- [ ] 全公開クラス・メソッドに `///` ドキュメントコメントを追加
