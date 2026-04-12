import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pubdev_viewer/core/api/pub_dev_api_client.dart';
import 'package:pubdev_viewer/core/error/app_exception.dart';

import '../../helpers/fakes.dart';

void main() {
  late FakeDio fakeDio;
  late PubDevApiClient apiClient;

  setUp(() {
    fakeDio = FakeDio();
    apiClient = PubDevApiClient(fakeDio);
  });

  group('getPackages', () {
    test('成功時にパース済み JSON を返す', () async {
      final responseData = <String, dynamic>{
        'next_url': 'https://pub.dev/api/packages?page=2',
        'packages': <dynamic>[],
      };
      fakeDio.onGet = <T>(url) async => Response<T>(
        data: responseData as T,
        statusCode: 200,
        requestOptions: RequestOptions(),
      );

      final result = await apiClient.getPackages();

      expect(result, responseData);
      expect(fakeDio.getCalls, ['https://pub.dev/api/packages']);
    });

    test('pageUrl が指定された場合にそれを使用する', () async {
      fakeDio.onGet = <T>(url) async => Response<T>(
        data: <String, dynamic>{'packages': <dynamic>[]} as T,
        statusCode: 200,
        requestOptions: RequestOptions(),
      );

      await apiClient.getPackages(
        pageUrl: 'https://pub.dev/api/packages?page=3',
      );

      expect(
        fakeDio.getCalls,
        ['https://pub.dev/api/packages?page=3'],
      );
    });
  });

  group('エラーハンドリング', () {
    test('接続エラー時に NetworkException をスローする', () {
      fakeDio.onGet = <T>(url) {
        throw DioException(
          type: DioExceptionType.connectionError,
          requestOptions: RequestOptions(),
        );
      };

      expect(
        () => apiClient.getPackages(),
        throwsA(isA<NetworkException>()),
      );
    });

    test('接続タイムアウト時に NetworkException をスローする', () {
      fakeDio.onGet = <T>(url) {
        throw DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: RequestOptions(),
        );
      };

      expect(
        () => apiClient.getPackages(),
        throwsA(isA<NetworkException>()),
      );
    });

    test('受信タイムアウト時に NetworkException をスローする', () {
      fakeDio.onGet = <T>(url) {
        throw DioException(
          type: DioExceptionType.receiveTimeout,
          requestOptions: RequestOptions(),
        );
      };

      expect(
        () => apiClient.getPackages(),
        throwsA(isA<NetworkException>()),
      );
    });

    test('送信タイムアウト時に NetworkException をスローする', () {
      fakeDio.onGet = <T>(url) {
        throw DioException(
          type: DioExceptionType.sendTimeout,
          requestOptions: RequestOptions(),
        );
      };

      expect(
        () => apiClient.getPackages(),
        throwsA(isA<NetworkException>()),
      );
    });

    test('SocketException 時に NetworkException をスローする', () {
      fakeDio.onGet = <T>(url) {
        throw DioException(
          requestOptions: RequestOptions(),
          error: const SocketException('Connection refused'),
        );
      };

      expect(
        () => apiClient.getPackages(),
        throwsA(isA<NetworkException>()),
      );
    });

    test('サーバーエラー時にステータスコード付き ServerException をスローする', () {
      fakeDio.onGet = <T>(url) {
        throw DioException(
          type: DioExceptionType.badResponse,
          response: Response(
            statusCode: 404,
            requestOptions: RequestOptions(),
          ),
          requestOptions: RequestOptions(),
        );
      };

      expect(
        () => apiClient.getPackages(),
        throwsA(
          isA<ServerException>().having(
            (e) => e.statusCode,
            'statusCode',
            404,
          ),
        ),
      );
    });

    test('レスポンスデータが null のとき ServerException をスローする', () {
      fakeDio.onGet = <T>(url) async => Response<T>(
        requestOptions: RequestOptions(),
      );

      expect(
        () => apiClient.getPackages(),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('getPackageDetail', () {
    test('正しい URL を呼び出す', () async {
      fakeDio.onGet = <T>(url) async => Response<T>(
        data: <String, dynamic>{'name': 'http'} as T,
        statusCode: 200,
        requestOptions: RequestOptions(),
      );

      await apiClient.getPackageDetail('http');

      expect(
        fakeDio.getCalls,
        ['https://pub.dev/api/packages/http'],
      );
    });
  });

  group('getPackagePublisher', () {
    test('正しい URL を呼び出す', () async {
      fakeDio.onGet = <T>(url) async => Response<T>(
        data: <String, dynamic>{'publisherId': 'dart.dev'} as T,
        statusCode: 200,
        requestOptions: RequestOptions(),
      );

      await apiClient.getPackagePublisher('http');

      expect(
        fakeDio.getCalls,
        ['https://pub.dev/api/packages/http/publisher'],
      );
    });
  });
}
