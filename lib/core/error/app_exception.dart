/// アプリ全体で扱う例外の基底クラス。
/// sealed class として定義し、エラーメッセージ出し分けを網羅的な switch 文で可能にしている。
sealed class AppException implements Exception {
  const AppException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// ネットワーク接続に起因する例外（タイムアウト・接続不可など）。
final class NetworkException extends AppException {
  const NetworkException([
    super.message = 'Network error occurred',
  ]);
}

/// サーバーのエラーレスポンスに起因する例外。
final class ServerException extends AppException {
  const ServerException(
    this.statusCode, [
    super.message = 'Server error',
  ]);

  final int statusCode;
}
