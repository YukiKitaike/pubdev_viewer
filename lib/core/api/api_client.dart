import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import '../error/app_exception.dart';

/// HTTP GET 通信とエラーハンドリングを担当する汎用 API クライアント。
///
/// [Dio] を内部で使用し、エラー時は [AppException] サブクラスをスローする。
class ApiClient {
  /// [Dio] インスタンスを受け取って API クライアントを生成する。
  ApiClient(Dio dio) : _dio = dio;

  final Dio _dio;
  final _logger = Logger('ApiClient');

  /// 指定 URL に GET リクエストを送信し、JSON Map を返す。
  ///
  /// 通信エラー時は [NetworkException]、サーバーエラー時は [ServerException] をスローする。
  Future<Map<String, dynamic>> get(String url) async {
    _logger.info('GET $url');
    try {
      final response = await _dio.get<Map<String, dynamic>>(url);
      _logger.info(
        'GET $url -> ${response.statusCode}',
      );
      final data = response.data;
      if (data == null) {
        throw const ServerException(500, 'Empty response body');
      }
      return data;
    } on DioException catch (e) {
      _logger.severe('GET $url failed: $e');
      switch (e.type) {
        case DioExceptionType.connectionError:
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          throw const NetworkException();
        case DioExceptionType.badResponse:
          throw ServerException(
            e.response?.statusCode ?? 500,
            'Server returned ${e.response?.statusCode}',
          );
        case DioExceptionType.cancel:
        case DioExceptionType.badCertificate:
        case DioExceptionType.unknown:
          throw const NetworkException();
      }
    }
  }
}
