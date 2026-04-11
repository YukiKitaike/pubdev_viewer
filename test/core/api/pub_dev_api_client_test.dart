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
    test('returns parsed JSON on success', () async {
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

    test('uses pageUrl when provided', () async {
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

  group('error handling', () {
    test('throws NetworkException on connection error', () {
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

    test('throws NetworkException on connection timeout', () {
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

    test('throws NetworkException on SocketException', () {
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

    test('throws ServerException with status code on server error', () {
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

    test('throws ServerException when response data is null', () {
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
    test('calls correct URL', () async {
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
    test('calls correct URL', () async {
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
