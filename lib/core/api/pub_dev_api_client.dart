import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:simple_logger/simple_logger.dart';

import '../error/app_exception.dart';

part 'pub_dev_api_client.g.dart';

final _logger = SimpleLogger()..mode = LoggerMode.log;

class PubDevApiClient {
  PubDevApiClient(this._dio);

  final Dio _dio;

  static const _baseUrl = 'https://pub.dev';

  Future<Map<String, dynamic>> getPackages({
    String? pageUrl,
  }) {
    final url = pageUrl ?? '$_baseUrl/api/packages';
    return _get(url);
  }

  Future<Map<String, dynamic>> getPackageDetail(
    String name,
  ) {
    return _get('$_baseUrl/api/packages/$name');
  }

  Future<Map<String, dynamic>> getPackagePublisher(
    String name,
  ) {
    return _get('$_baseUrl/api/packages/$name/publisher');
  }

  Future<Map<String, dynamic>> _get(String url) async {
    _logger.info('GET $url');
    try {
      final response = await _dio.get<Map<String, dynamic>>(url);
      _logger.info(
        'GET $url -> ${response.statusCode}',
      );
      return response.data!;
    } on DioException catch (e) {
      _logger.warning('GET $url failed: $e');
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.error is SocketException) {
        throw const NetworkException();
      }
      if (e.response != null) {
        throw ServerException(
          e.response!.statusCode ?? 500,
          'Server returned ${e.response!.statusCode}',
        );
      }
      throw const NetworkException();
    }
  }
}

@riverpod
PubDevApiClient pubDevApiClient(Ref ref) {
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );
  return PubDevApiClient(dio);
}
