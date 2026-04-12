# ウィジェットテスト実装例（pubdev_viewer）

## ローディング状態のテスト（Completer）

`Completer` で future を保留し、ローディング中の状態を検証する:

```dart
testWidgets('ローディング中は SkeletonListView が表示される', (tester) async {
  final completer = Completer<PackageListResponse>();
  fakeRepository.getPackagesCompleter = completer;

  await tester.pumpWidget(createTestWidget());
  await tester.pump();

  expect(find.byType(SkeletonListView), findsOneWidget);

  // テスト終了前に complete して dispose エラーを防ぐ
  completer.complete(lastPageResponse());
  await tester.pump();
});
```

---

## ウィジェットテスト（createTestApp）

`test/helpers/pump_app.dart` の `createTestApp()` で MaterialApp + テーマ + ProviderScope を共通化:

```dart
@Tags(['widget'])
library;

import 'package:checks/checks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fakes.dart';
import '../../../helpers/fixtures.dart';
import '../../../helpers/pump_app.dart';

void main() {
  late FakePackageListRepository fakeRepository;

  setUp(() {
    fakeRepository = FakePackageListRepository();
  });

  // createTestApp で ProviderScope + MaterialApp(appLightTheme) をラップ
  Widget createTestWidget() {
    return createTestApp(
      home: const PackageListScreen(),
      overrides: [
        packageListRepositoryProvider.overrideWithValue(fakeRepository),
      ],
    );
  }

  testWidgets('データ取得後にパッケージ名が表示される', (tester) async {
    fakeRepository.onGetPackages = ({String? pageUrl}) async =>
        firstPageResponse();

    await tester.pumpWidget(createTestWidget());
    // Riverpod AsyncNotifier のマイクロタスク解決に 2 回 pump が必要
    await tester.pump();
    await tester.pump();

    expect(find.text('http'), findsOneWidget);
  });
}
```
