# API クライアント テスト例（pubdev_viewer）

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

---

## FakeDio の使い方（テスト例）

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
