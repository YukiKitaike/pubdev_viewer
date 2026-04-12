---
name: pubdev-testing
description: >
  pubdev_viewer のテストパターン。ユニットテスト（notifier・repository）・
  ウィジェットテストを書く際に使用。Fake パターン・ProviderContainer・
  フィクスチャ・Completer を使ったテクニックを実際のコードから提供する。
---

# テストパターン（pubdev_viewer）

## テストケース名は日本語で記述する

`test()` / `testWidgets()` の説明文字列は **すべて日本語** で書く。
`group()` はクラス名をそのまま使うため英語のまま。

```dart
// ✅ 正しい例
group('PackageListNotifier', () {
  test('build が初期パッケージを取得する', () async { ... });
  test('loadMore がパッケージを追加する', () async { ... });
});

// ❌ 英語で書かない
group('PackageListNotifier', () {
  test('build fetches initial packages', () async { ... });
});
```

---

## ファイル配置ルール

`lib/` の構造を `test/` 配下にそのまま鏡像する:

```
lib/features/package_list/notifiers/package_list_notifier.dart
→ test/features/package_list/notifiers/package_list_notifier_test.dart

lib/features/package_list/repository/package_list_repository.dart
→ test/features/package_list/repository/package_list_repository_test.dart
```

---

## 共有テストヘルパー

`test/helpers/` に 2 ファイルが存在する:

- [test/helpers/fakes.dart]— Fake クラスの定義
- [test/helpers/fixtures.dart] — const JSON マップ（フィクスチャ）

テストファイル内にインラインで JSON を書かない。必ず共有フィクスチャを使う。

---

## Fake パターン（Mock より優先）

`@GenerateMocks` + mockito の Mock は使わない。
`Fake` + `implements` でテストダブルを作り、コールバックプロパティで挙動を設定する。
Fake は挙動が明示的で、Completer による非同期制御が可能。mockito の `when`/`verify`
よりテストコードの可読性が高く、実行時型エラーも起きにくい。

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
// test/features/package_list/notifiers/package_list_notifier_test.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pubdev_viewer/features/package_list/models/package_list_response.dart';
import 'package:pubdev_viewer/features/package_list/notifiers/package_list_notifier.dart';
import 'package:pubdev_viewer/features/package_list/repository/package_list_repository.dart';

import '../../../helpers/fakes.dart';
import '../../../helpers/fixtures.dart';

// フィクスチャからモデルを生成するヘルパー
// Map<String, dynamic>.from(...) でコピー — const マップを破壊しないため必須
PackageListResponse _firstPage() => PackageListResponse.fromJson(
  Map<String, dynamic>.from(packageListResponseJson),
);

void main() {
  late FakePackageListRepository fakeRepository;
  late ProviderContainer container;

  setUp(() {
    fakeRepository = FakePackageListRepository();
    container = ProviderContainer(
      overrides: [
        packageListRepositoryProvider.overrideWithValue(fakeRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose(); // 必ず dispose する
  });

  group('PackageListNotifier', () {
    test('build は初期パッケージを取得する', () async {
      fakeRepository.onGetPackages = ({String? pageUrl}) async => _firstPage();

      final state = await container.read(packageListNotifierProvider.future);

      expect(state.packages, hasLength(2));
      expect(state.packages[0].name, 'http');
      expect(state.nextUrl, isNotNull);
    });
  });
}
```

実際のファイル: [test/features/package_list/notifiers/package_list_notifier_test.dart]

---

## AsyncError のテスト

```dart
test('build は repository が例外を投げると AsyncError になる', () async {
  fakeRepository.onGetPackages = ({String? pageUrl}) =>
      throw const NetworkException();

  // future を await してエラーを握り潰す（テストクラッシュ回避）
  await container
      .read(packageListNotifierProvider.future)
      .then((_) => null)
      .catchError((_) => null);

  final asyncValue = container.read(packageListNotifierProvider);
  expect(asyncValue.hasError, isTrue);
  expect(asyncValue.error, isA<NetworkException>());
});
```

---

## loadMore のテスト（エラー時データ保持）

```dart
test('loadMore はエラー時に既存データを保持する', () async {
  var callCount = 0;
  fakeRepository.onGetPackages = ({String? pageUrl}) async {
    callCount++;
    if (callCount == 1) return _firstPage();
    throw const NetworkException(); // 2回目はエラー
  };

  await container.read(packageListNotifierProvider.future);
  await container.read(packageListNotifierProvider.notifier).loadMore();

  final state = container.read(packageListNotifierProvider).valueOrNull;
  expect(state, isNotNull);
  expect(state!.packages, hasLength(2));   // 既存データは保持
  expect(state.isLoadingMore, isFalse);
  expect(state.loadMoreError, isA<NetworkException>());
});
```

---

## ローディング状態のテスト（Completer）

`Completer` で future を保留し、ローディング中の状態を検証する:

```dart
test('ローディング中は SkeletonListView が表示される', (tester) async {
  final completer = Completer<PackageListResponse>();
  fakeRepository.getPackagesCompleter = completer; // future を保留

  await tester.pumpWidget(createTestWidget());
  await tester.pump();

  expect(find.byType(SkeletonListView), findsOneWidget);

  // テスト終了前に complete して dispose エラーを防ぐ
  completer.complete(PackageListResponse.fromJson(
    Map<String, dynamic>.from(packageListResponseJson),
  ));
  await tester.pump();
});
```

---

## ウィジェットテスト（Screen レベル）

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Widget createTestWidget() {
  return ProviderScope(
    overrides: [
      packageListRepositoryProvider.overrideWithValue(fakeRepository),
    ],
    child: const MaterialApp(home: PackageListScreen()),
  );
  // GoRouter は不要（ウィジェット単体テストには MaterialApp で十分）
}

testWidgets('データ取得後にパッケージ名が表示される', (tester) async {
  fakeRepository.onGetPackages = ({String? pageUrl}) async =>
      PackageListResponse.fromJson(
        Map<String, dynamic>.from(packageListResponseJson),
      );

  await tester.pumpWidget(createTestWidget());
  await tester.pump(); // async 発火
  await tester.pump(); // settle

  expect(find.text('http'), findsOneWidget);
});
```

---

## Repository ユニットテスト

Repository は `FakePubDevApiClient` を使って直接テストする:

```dart
void main() {
  late FakePubDevApiClient fakeApiClient;
  late PackageListRepository repository;

  setUp(() {
    fakeApiClient = FakePubDevApiClient();
    repository = PackageListRepository(fakeApiClient); // 直接インスタンス化
  });

  test('getPackages はパース済みレスポンスを返す', () async {
    fakeApiClient.onGetPackages = ({String? pageUrl}) async =>
        Map<String, dynamic>.from(packageListResponseJson);

    final response = await repository.getPackages();

    expect(response.packages, hasLength(2));
    expect(fakeApiClient.getPackagesCalls, hasLength(1));
  });

  test('getPackages は NetworkException を再スローする', () {
    fakeApiClient.onGetPackages = ({String? pageUrl}) =>
        throw const NetworkException();

    expect(() => repository.getPackages(), throwsA(isA<NetworkException>()));
  });

  test('ServerException の statusCode を検証する', () {
    fakeApiClient.onGetPackages = ({String? pageUrl}) =>
        throw const ServerException(500);

    expect(
      () => repository.getPackages(),
      throwsA(
        isA<ServerException>().having((e) => e.statusCode, 'statusCode', 500),
      ),
    );
  });
}
```

---

## フィクスチャのコピーが必要な理由

```dart
// ✅ 常に Map<String, dynamic>.from() でコピーしてから fromJson に渡す
PackageListResponse.fromJson(Map<String, dynamic>.from(packageListResponseJson))

// ❌ const マップを直接渡すと fromJson 内部の変換で UnmodifiableMapError が出る場合がある
PackageListResponse.fromJson(packageListResponseJson)
```

---

## よくある間違い

```dart
// ❌ @GenerateMocks を使う（Fake パターンで対応できる）
@GenerateMocks([PackageListRepository])
void main() { ... }

// ❌ tearDown で dispose を忘れる（メモリリーク）
tearDown(() {
  // container.dispose() を書かない
});

// ❌ テストごとにインラインで JSON を定義する
fakeRepository.onGetPackages = ({_}) async =>
    PackageListResponse.fromJson({'next_url': null, 'packages': []}); // fixtures を使う
```

---

### WHY コメントの典型例

- `Map<String, dynamic>.from()` でコピーする理由（const マップを直接渡すと内部変換で UnmodifiableMapError）
- `tearDown` で `container.dispose()` する理由（provider のリソースリーク防止）
- Completer でテスト終了前に `complete()` する理由（未完了 future が残ると dispose エラー）
- Fake にコールバックプロパティを使う理由（テストごとに挙動を差し替え可能にする）
