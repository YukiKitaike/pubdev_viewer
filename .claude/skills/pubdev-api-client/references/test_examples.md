# API クライアント テスト例（pubdev_viewer）

## テスト用 Fake（FakeDio / FakePubDevApiClient）

定義は `test/helpers/fakes.dart` を Read で参照する
（ドキュメントに複製すると実装とドリフトするため、実ファイルが唯一の定義）。

- `FakeDio` — ジェネリクス型パラメータ付き `onGet` コールバックで GET の挙動を設定。呼び出し URL は `getCalls` で検証
- `FakePubDevApiClient` — Repository テスト用。`onGetPackages` 等のコールバック + `getPackagesCalls` 等の呼び出し履歴

Fake の 3 要素構造は `/pubdev-testing` の「新しい Fake の統一パターン」参照。

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

実際のファイル: `test/core/api/pub_dev_api_client_test.dart`
