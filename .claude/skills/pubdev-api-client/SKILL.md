---
name: pubdev-api-client
description: >
  pubdev_viewer の API クライアント層とエラーハンドリングパターン。
  Dio ベースの ApiClient 設計、DioException → AppException 変換、
  PubDevApiClient の継承パターン、keepAlive Provider、テスト用 FakeDio を
  実装・編集する際に使用。新しい API エンドポイントの追加時にも参照。
---

# API クライアント層パターン（pubdev_viewer）

## アーキテクチャ概要

```
PubDevApiClient extends ApiClient
       ↓ DI
    Dio（HTTP クライアント）

例外の流れ:
DioException → ApiClient が AppException に変換 → Repository → Notifier → ErrorView
```

---

## sealed class AppException

エラーをネットワーク系とサーバー系に分類する。sealed class なので switch 式で網羅チェックが効く。

```dart
// lib/core/error/app_exception.dart
// sealed class として定義し、網羅的な switch 文を可能にしている。
sealed class AppException implements Exception {
  const AppException(this.message);
  final String message;

  @override
  String toString() => message;
}

final class NetworkException extends AppException {
  const NetworkException([super.message = 'Network error occurred']);
}

final class ServerException extends AppException {
  const ServerException(this.statusCode, [super.message = 'Server error']);
  final int statusCode;
}
```

実際のファイル: [lib/core/error/app_exception.dart](lib/core/error/app_exception.dart)

---

## ApiClient 基底クラス

Dio を DI で受け取り、DioException → AppException 変換を一元化する。

```dart
// lib/core/api/api_client.dart
class ApiClient {
  ApiClient(Dio dio) : _dio = dio;

  final Dio _dio;
  final _logger = Logger('ApiClient');

  Future<Map<String, dynamic>> get(String url) async {
    _logger.info('GET $url');
    try {
      final response = await _dio.get<Map<String, dynamic>>(url);
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
```

実際のファイル: [lib/core/api/api_client.dart](lib/core/api/api_client.dart)

---

## PubDevApiClient（pub.dev 特化）

ApiClient を継承し、pub.dev API 固有のエンドポイントを定義する。
メソッドは全て `Map<String, dynamic>` を返す（Repository が `fromJson` でパースする）。

```dart
// lib/core/api/pub_dev_api_client.dart
class PubDevApiClient extends ApiClient {
  PubDevApiClient(super.dio);

  static const _baseUrl = 'https://pub.dev';

  Future<Map<String, dynamic>> getPackages({String? pageUrl}) {
    final url = pageUrl ?? '$_baseUrl/api/packages';
    return get(url);
  }

  Future<Map<String, dynamic>> getPackageDetail(String name) {
    return get('$_baseUrl/api/packages/$name');
  }

  Future<Map<String, dynamic>> getPackagePublisher(String name) {
    return get('$_baseUrl/api/packages/$name/publisher');
  }
}
```

実際のファイル: [lib/core/api/pub_dev_api_client.dart](lib/core/api/pub_dev_api_client.dart)

---

## Provider 定義（keepAlive）

```dart
// Dio を keepAlive でアプリ存続中保持する。
// リクエストごとに生成すると HTTP コネクションプールが再利用されず遅延が増す。
@Riverpod(keepAlive: true)
PubDevApiClient pubDevApiClient(Ref ref) {
  final dio = Dio(
    BaseOptions(
      // pub.dev API は通常 1〜2 秒で応答する。
      // 10 秒は余裕を持ちつつ無応答時にユーザーを長く待たせない妥協値。
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );
  return PubDevApiClient(dio);
}
```

---

## ErrorView でのエラー出し分け

sealed class の網羅性を活かした switch 式でユーザー向けメッセージを分岐する:

```dart
// lib/core/widgets/error_view.dart
String get _title => switch (error) {
  NetworkException() => AppStrings.networkErrorTitle,
  ServerException() => AppStrings.serverErrorTitle,
  _ => AppStrings.unexpectedErrorTitle,
};
```

Notifier 層でのエラーハンドリングは `/pubdev-state` を参照。

---

## テスト用 FakeDio

ジェネリクス型パラメータ付きの `onGet` コールバックで GET リクエストの挙動を設定する。
`getCalls` で呼び出し URL を検証可能。

```dart
// test/helpers/fakes.dart
class FakeDio extends Fake implements Dio {
  Future<Response<T>> Function<T>(String url)? onGet;
  final List<String> getCalls = [];

  @override
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Object? data,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) {
    getCalls.add(path);
    return onGet!<T>(path);
  }
}
```

### FakeDio の使い方（テスト例）

```dart
// test/core/api/pub_dev_api_client_test.dart
late FakeDio fakeDio;
late PubDevApiClient apiClient;

setUp(() {
  fakeDio = FakeDio();
  apiClient = PubDevApiClient(fakeDio);
});

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

test('throws NetworkException on connection error', () {
  fakeDio.onGet = <T>(url) {
    throw DioException(
      type: DioExceptionType.connectionError,
      requestOptions: RequestOptions(),
    );
  };

  expect(() => apiClient.getPackages(), throwsA(isA<NetworkException>()));
});
```

実際のファイル: [test/core/api/pub_dev_api_client_test.dart](test/core/api/pub_dev_api_client_test.dart)

---

## Repository 層パターン

Repository は `PubDevApiClient` を DI で受け取り、`fromJson` でパースする薄いレイヤー。
具象クラスのみ（No interfaces ルール）。Provider はファイル末尾に `@riverpod` 関数で定義。

```dart
// lib/features/<feature_name>/repository/<feature_name>_repository.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:pubdev_viewer/core/api/pub_dev_api_client.dart';
import '../models/<feature_name>_response.dart';

part '<feature_name>_repository.g.dart';

class FeatureNameRepository {
  FeatureNameRepository(this._apiClient);
  final PubDevApiClient _apiClient;

  Future<FeatureNameResponse> getFeature({String? pageUrl}) async {
    final json = await _apiClient.getFeature(pageUrl: pageUrl);
    return FeatureNameResponse.fromJson(json);
  }
}

@riverpod
FeatureNameRepository featureNameRepository(Ref ref) {
  return FeatureNameRepository(ref.watch(pubDevApiClientProvider));
}
```

コード生成: `fvm dart run build_runner build -d`

---

## エンドポイント追加手順

新しい pub.dev API エンドポイントを追加する場合:

1. `PubDevApiClient` にメソッドを追加（返り値は `Map<String, dynamic>`）
2. `test/helpers/fakes.dart` の `FakePubDevApiClient` にコールバック + 呼び出し履歴を追加
3. `test/core/api/pub_dev_api_client_test.dart` に URL 検証テストを追加
4. Repository で `fromJson` パースする（`/pubdev-models` 参照）
5. Notifier から Repository を呼ぶ（`/pubdev-state` 参照）

---

## やってはいけないこと

```dart
// ❌ Repository 層で DioException を直接キャッチ（ApiClient が変換済み）
try {
  final json = await _apiClient.getPackages();
} on DioException catch (e) { ... }  // AppException をキャッチすべき

// ❌ ApiClient に fromJson パース処理を書く（Repository の責務）
Future<PackageListResponse> getPackages() async {
  final json = await get(url);
  return PackageListResponse.fromJson(json);  // NG: Repository でやる
}

// ❌ リクエストごとに Dio を new する（コネクションプール無駄）
@riverpod
PubDevApiClient pubDevApiClient(Ref ref) {
  return PubDevApiClient(Dio());  // keepAlive なしは NG
}
```

---

### WHY コメントの典型例

- `keepAlive: true` の理由（コネクションプール再利用）
- タイムアウト値（10 秒）の根拠
- DioException を AppException に変換する理由（ErrorView が分類するため）
- null response body を ServerException(500) にする理由
