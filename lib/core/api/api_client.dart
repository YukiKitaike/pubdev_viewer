import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import '../error/app_exception.dart';

class ApiClient {
  ApiClient(Dio dio) : _dio = dio;

  final Dio _dio;
  final _logger = Logger('ApiClient');

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
      // DioException を AppException に変換。ErrorView がユーザー向けメッセージを
      // 出し分けるためにネットワーク系とサーバー系を分類する。
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
