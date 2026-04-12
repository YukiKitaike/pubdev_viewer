# ユニットテスト実装例（pubdev_viewer）

## Fake パターン（Mock より優先）

`@GenerateMocks` + mockito の Mock は使わない。
`Fake` + `implements` でテストダブルを作り、コールバックプロパティで挙動を設定する。

```dart
// test/helpers/fakes.dart の実際のパターン
class FakePackageListRepository extends Fake implements PackageListRepository {
  Future<PackageListResponse> Function({String? pageUrl})? onGetPackages;
  Completer<PackageListResponse>? getPackagesCompleter; // 非同期制御用
  int getPackagesCallCount = 0;

  @override
  Future<PackageListResponse> getPackages({String? pageUrl}) {
    getPackagesCallCount++;
    if (getPackagesCompleter != null) return getPackagesCompleter!.future;
    return onGetPackages!(pageUrl: pageUrl);
  }
}
```

---

## Notifier ユニットテスト（ProviderContainer）

```dart
@Tags(['unit'])
library;

import 'package:checks/checks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fakes.dart';
import '../../../helpers/fixtures.dart';

void main() {
  late FakePackageListRepository fakeRepository;
  late ProviderContainer container;

  setUp(() {
    fakeRepository = FakePackageListRepository();
    container = ProviderContainer.test(
      // Riverpod v3 の自動リトライを無効化。エラー系テストが安定しなくなるため。
      retry: (_, _) => null,
      overrides: [
        packageListRepositoryProvider.overrideWithValue(fakeRepository),
      ],
    );
  });

  group('PackageListNotifier', () {
    test('build が初期パッケージを取得する', () async {
      fakeRepository.onGetPackages = ({String? pageUrl}) async =>
          firstPageResponse();

      final state = await container.read(packageListProvider.future);

      check(state.packages).length.equals(2);
      check(state.packages[0].name).equals('http');
      check(state.nextUrl).isNotNull();
    });
  });
}
```

---

## AsyncError のテスト

```dart
test('build は repository が例外を投げると AsyncError になる', () async {
  fakeRepository.onGetPackages = ({String? pageUrl}) =>
      throw const NetworkException();

  // future を await してエラーを握り潰す（テストクラッシュ回避）
  await container
      .read(packageListProvider.future)
      .then((_) => null)
      .catchError((_) => null);

  final asyncValue = container.read(packageListProvider);
  check(asyncValue.hasError).isTrue();
  check(asyncValue.error).isA<NetworkException>();
});
```

---

## loadMore のテスト（エラー時データ保持）

```dart
test('loadMore はエラー時に既存データを保持する', () async {
  var callCount = 0;
  fakeRepository.onGetPackages = ({String? pageUrl}) async {
    callCount++;
    if (callCount == 1) return firstPageResponse();
    throw const NetworkException();
  };

  await container.read(packageListProvider.future);
  await container.read(packageListProvider.notifier).loadMore();

  final state = container.read(packageListProvider).value;
  check(state).isNotNull();
  check(state!.packages).length.equals(2);
  check(state.isLoadingMore).isFalse();
  check(state.loadMoreError).isA<NetworkException>();
});
```

---

## Repository ユニットテスト

Repository は `FakePubDevApiClient` を使って直接テストする:

```dart
test('getPackages がパース済みレスポンスを返す', () async {
  fakeApiClient.onGetPackages = ({String? pageUrl}) async =>
      Map<String, dynamic>.from(packageListResponseJson);

  final response = await repository.getPackages();

  check(response.packages).length.equals(2);
  check(response.packages[0].name).equals('http');
  check(fakeApiClient.getPackagesCalls).length.equals(1);
});

test('getPackages が NetworkException を再スローする', () async {
  fakeApiClient.onGetPackages = ({String? pageUrl}) =>
      throw const NetworkException();

  await check(repository.getPackages()).throws<NetworkException>();
});
```

---

## フィクスチャのコピーが必要な理由

```dart
// 常に Map<String, dynamic>.from() でコピーしてから fromJson に渡す
PackageListResponse.fromJson(Map<String, dynamic>.from(packageListResponseJson))

// またはビルダー関数を使う（内部で Map.from 済み）
firstPageResponse()

// NG: const マップを直接渡すと内部変換で UnmodifiableMapError が出る場合がある
PackageListResponse.fromJson(packageListResponseJson)
```
