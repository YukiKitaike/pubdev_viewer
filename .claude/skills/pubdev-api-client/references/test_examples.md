# API クライアント テスト例（pubdev_viewer）

## テスト用 FakeDio

ジェネリクス型パラメータ付きの `onGet` コールバックで GET リクエストの挙動を設定する。
`getCalls` で呼び出し URL を検証可能。

```dart
// test/helpers/fakes.dart

/// [Dio] の Fake 実装。
///
/// [onGet] に GET リクエストの挙動を設定する。
/// 呼び出し URL は [getCalls] で検証可能。
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

---

## テスト用 FakePubDevApiClient

Repository テストで使用する。各メソッドの挙動をコールバックで設定し、
呼び出し履歴で正しい引数が渡されたか検証する。

```dart
// test/helpers/fakes.dart

/// [PubDevApiClient] の Fake 実装。
///
/// 各メソッドの挙動を [onGetPackages] 等のコールバックで設定する。
/// 呼び出し履歴は [getPackagesCalls] 等で確認可能。
class FakePubDevApiClient extends Fake implements PubDevApiClient {
  Future<Map<String, dynamic>> Function({String? pageUrl})? onGetPackages;
  Future<Map<String, dynamic>> Function(String name)? onGetPackageDetail;
  Future<Map<String, dynamic>> Function(String name)? onGetPackagePublisher;

  final List<String?> getPackagesCalls = [];
  final List<String> getPackageDetailCalls = [];
  final List<String> getPackagePublisherCalls = [];

  @override
  Future<Map<String, dynamic>> getPackages({String? pageUrl}) {
    getPackagesCalls.add(pageUrl);
    return onGetPackages!(pageUrl: pageUrl);
  }

  @override
  Future<Map<String, dynamic>> getPackageDetail(String name) {
    getPackageDetailCalls.add(name);
    return onGetPackageDetail!(name);
  }

  @override
  Future<Map<String, dynamic>> getPackagePublisher(String name) {
    getPackagePublisherCalls.add(name);
    return onGetPackagePublisher!(name);
  }
}
```

---

## FakeDio の使い方（テスト例）

アサーションは `package:checks` の `check().deepEquals()` を使用する。
`throwsA` + `isA` は async Future 対応のため `expect` を維持。

```dart
// test/core/api/pub_dev_api_client_test.dart
late FakeDio fakeDio;
late PubDevApiClient apiClient;

setUp(() {
  fakeDio = FakeDio();
  apiClient = PubDevApiClient(fakeDio);
});

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

  check(result).deepEquals(responseData);
  check(fakeDio.getCalls).deepEquals(['https://pub.dev/api/packages']);
});

test('接続エラー時に NetworkException をスローする', () {
  fakeDio.onGet = <T>(url) {
    throw DioException(
      type: DioExceptionType.connectionError,
      requestOptions: RequestOptions(),
    );
  };

  // throwsA は async Future 対応のため expect を維持
  expect(
    () => apiClient.getPackages(),
    throwsA(isA<NetworkException>()),
  );
});
```

実際のファイル: [test/core/api/pub_dev_api_client_test.dart](test/core/api/pub_dev_api_client_test.dart)
