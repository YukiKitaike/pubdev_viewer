/// アプリ内で発生する例外の基底クラス。
///
/// sealed class として定義し、網羅的な switch 文を可能にしている。
sealed class AppException implements Exception {
  const AppException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// ネットワーク接続に失敗した場合にスローされる例外。
final class NetworkException extends AppException {
  const NetworkException([
    super.message = 'Network error occurred',
  ]);
}

/// サーバーがエラーステータスコードを返した場合にスローされる例外。
final class ServerException extends AppException {
  const ServerException(
    this.statusCode, [
    super.message = 'Server error',
  ]);

  final int statusCode;
}
