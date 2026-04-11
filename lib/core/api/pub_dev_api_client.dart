import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../error/app_exception.dart';

part 'pub_dev_api_client.g.dart';

final _logger = Logger('PubDevApiClient');

/// pub.dev API との HTTP 通信を担当するクライアント。
///
/// [Dio] を内部で使用し、エラー時は [AppException] サブクラスをスローする。
class PubDevApiClient {
  /// [Dio] インスタンスを受け取って API クライアントを生成する。
  PubDevApiClient(this._dio);

  final Dio _dio;

  static const _baseUrl = 'https://pub.dev';

  /// パッケージ一覧を取得する。
  ///
  /// [pageUrl] を指定するとそのページのデータを取得する（ページネーション）。
  Future<Map<String, dynamic>> getPackages({
    String? pageUrl,
  }) {
    final url = pageUrl ?? '$_baseUrl/api/packages';
    return _get(url);
  }

  /// 指定パッケージの詳細情報を取得する。
  Future<Map<String, dynamic>> getPackageDetail(
    String name,
  ) {
    return _get('$_baseUrl/api/packages/$name');
  }

  /// 指定パッケージのパブリッシャー情報を取得する。
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
          if (e.error is SocketException) {
            throw const NetworkException();
          }
          throw const NetworkException();
      }
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
