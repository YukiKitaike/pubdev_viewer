@Tags(['widget'])
library;

import 'dart:async';

import 'package:checks/checks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pubdev_viewer/core/error/app_exception.dart';
import 'package:pubdev_viewer/core/strings/app_strings.dart';
import 'package:pubdev_viewer/core/widgets/skeleton_list_view.dart';
import 'package:pubdev_viewer/features/package_list/models/package_list_response.dart';
import 'package:pubdev_viewer/features/package_list/notifiers/package_list_notifier.dart';
import 'package:pubdev_viewer/features/package_list/repository/package_list_repository.dart';
import 'package:pubdev_viewer/features/package_list/screens/package_list_screen.dart';
import 'package:pubdev_viewer/features/package_list/screens/widgets/package_list_tile.dart';

import '../../../helpers/fakes.dart';
import '../../../helpers/fixtures.dart';
import '../../../helpers/pump_app.dart';

void main() {
  late FakePackageListRepository fakeRepository;

  setUp(() {
    fakeRepository = FakePackageListRepository();
  });

  Widget createTestWidget() {
    return createTestApp(
      home: const PackageListScreen(),
      overrides: [
        packageListRepositoryProvider.overrideWithValue(fakeRepository),
      ],
    );
  }

  group('PackageListScreen', () {
    testWidgets('初期表示でローディングインジケータが表示される', (tester) async {
      final completer = Completer<PackageListResponse>();
      fakeRepository.getPackagesCompleter = completer;

      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(
        find.byType(SkeletonListView),
        findsOneWidget,
      );

      completer.complete(
        PackageListResponse.fromJson(
          Map<String, dynamic>.from(packageListResponseLastPageJson),
        ),
      );
      await tester.pump();
    });

    testWidgets('データ取得後にパッケージ一覧が表示される', (tester) async {
      var callCount = 0;
      fakeRepository.onGetPackages = ({String? pageUrl}) async {
        callCount++;
        if (callCount == 1) {
          return PackageListResponse.fromJson(
            Map<String, dynamic>.from(packageListResponseJson),
          );
        }
        return PackageListResponse.fromJson(
          Map<String, dynamic>.from(packageListResponseLastPageJson),
        );
      };

      await tester.pumpWidget(createTestWidget());
      await tester.pump();
      await tester.pump();

      expect(find.text('http'), findsOneWidget);
      expect(find.text('dio'), findsOneWidget);
      expect(find.text('v1.6.0'), findsOneWidget);
      expect(find.text('v5.8.0'), findsOneWidget);
    });

    testWidgets('エラー時にエラー画面が表示される', (tester) async {
      fakeRepository.onGetPackages = ({String? pageUrl}) =>
          throw const NetworkException();

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.retry), findsOneWidget);
      expect(find.byIcon(Icons.cloud_off_rounded), findsOneWidget);
    });

    testWidgets('リトライボタンでデータを再取得する', (tester) async {
      var callCount = 0;
      fakeRepository.onGetPackages = ({String? pageUrl}) async {
        callCount++;
        if (callCount == 1) {
          throw const NetworkException();
        }
        return PackageListResponse.fromJson(
          Map<String, dynamic>.from(packageListResponseJson),
        );
      };

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text(AppStrings.retry));
      await tester.pump();
      await tester.pump();

      expect(find.text('http'), findsOneWidget);
    });

    testWidgets('PackageListTile が件数分表示される', (tester) async {
      var callCount = 0;
      fakeRepository.onGetPackages = ({String? pageUrl}) async {
        callCount++;
        if (callCount == 1) {
          return PackageListResponse.fromJson(
            Map<String, dynamic>.from(packageListResponseJson),
          );
        }
        return PackageListResponse.fromJson(
          Map<String, dynamic>.from(packageListResponseLastPageJson),
        );
      };

      await tester.pumpWidget(createTestWidget());
      await tester.pump();
      await tester.pump();

      expect(find.byType(PackageListTile), findsNWidgets(2));
    });

    testWidgets('テーマ切替ボタンが表示される', (tester) async {
      fakeRepository.onGetPackages = ({String? pageUrl}) async =>
          PackageListResponse.fromJson(
            Map<String, dynamic>.from(packageListResponseJson),
          );

      await tester.pumpWidget(createTestWidget());
      await tester.pump();
      await tester.pump();

      expect(find.byIcon(Icons.dark_mode_outlined), findsOneWidget);
    });

    testWidgets('テーマ切替ボタンのタップでアイコンが切り替わる', (tester) async {
      fakeRepository.onGetPackages = ({String? pageUrl}) async =>
          PackageListResponse.fromJson(
            Map<String, dynamic>.from(packageListResponseJson),
          );

      await tester.pumpWidget(createTestWidget());
      await tester.pump();
      await tester.pump();

      expect(find.byIcon(Icons.dark_mode_outlined), findsOneWidget);

      await tester.tap(find.byIcon(Icons.dark_mode_outlined));
      await tester.pump();

      expect(find.byIcon(Icons.light_mode_outlined), findsOneWidget);
      expect(find.byIcon(Icons.dark_mode_outlined), findsNothing);
    });
  });

  group('PackageListScreen 無限スクロール', () {
    testWidgets('追加読み込み中に CircularProgressIndicator が表示される', (tester) async {
      final loadMoreCompleter = Completer<PackageListResponse>();
      var callCount = 0;
      fakeRepository.onGetPackages = ({String? pageUrl}) async {
        callCount++;
        if (callCount == 1) {
          return PackageListResponse.fromJson(
            Map<String, dynamic>.from(packageListResponseJson),
          );
        }
        return loadMoreCompleter.future;
      };

      await tester.pumpWidget(createTestWidget());
      await tester.pump();
      await tester.pump();

      // notifier を直接呼び出して loadMore の UI 反映を検証する
      final element = tester.element(find.byType(PackageListScreen));
      final container = ProviderScope.containerOf(element);
      unawaited(
        container.read(packageListNotifierProvider.notifier).loadMore(),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      loadMoreCompleter.complete(
        PackageListResponse.fromJson(
          Map<String, dynamic>.from(packageListResponseLastPageJson),
        ),
      );
      await tester.pump();
    });

    testWidgets('最終ページ到達後は追加読み込みしない', (tester) async {
      fakeRepository.onGetPackages = ({String? pageUrl}) async =>
          PackageListResponse.fromJson(
            Map<String, dynamic>.from(packageListResponseLastPageJson),
          );

      await tester.pumpWidget(createTestWidget());
      await tester.pump();
      await tester.pump();

      // nextUrl が null なので loadMore は何もしない
      final element = tester.element(find.byType(PackageListScreen));
      final container = ProviderScope.containerOf(element);
      await container.read(packageListNotifierProvider.notifier).loadMore();
      await tester.pump();

      check(fakeRepository.getPackagesCallCount).equals(1);
    });
  });

  group('PackageListScreen SnackBar', () {
    testWidgets('追加読み込みエラー時に SnackBar が表示される', (tester) async {
      var callCount = 0;
      fakeRepository.onGetPackages = ({String? pageUrl}) async {
        callCount++;
        if (callCount == 1) {
          return PackageListResponse.fromJson(
            Map<String, dynamic>.from(packageListResponseJson),
          );
        }
        throw const NetworkException();
      };

      await tester.pumpWidget(createTestWidget());
      await tester.pump();
      await tester.pump();

      // notifier を直接呼び出して loadMore エラー → SnackBar 表示を検証する
      final element = tester.element(find.byType(PackageListScreen));
      final container = ProviderScope.containerOf(element);
      await container.read(packageListNotifierProvider.notifier).loadMore();
      await tester.pump();

      expect(find.text(AppStrings.loadMoreFailed), findsOneWidget);
    });
  });

  group('PackageListScreen リフレッシュ', () {
    testWidgets('プルリフレッシュでデータが再取得される', (tester) async {
      fakeRepository.onGetPackages = ({String? pageUrl}) async =>
          PackageListResponse.fromJson(
            Map<String, dynamic>.from(packageListResponseJson),
          );

      await tester.pumpWidget(createTestWidget());
      await tester.pump();
      await tester.pump();

      expect(find.byType(RefreshIndicator), findsOneWidget);
      check(fakeRepository.getPackagesCallCount).equals(1);

      // notifier 経由で refresh を呼び出し、RefreshIndicator の接続先と同じ処理を検証する
      final element = tester.element(find.byType(PackageListScreen));
      final container = ProviderScope.containerOf(element);
      await container.read(packageListNotifierProvider.notifier).refresh();
      await tester.pump();

      check(fakeRepository.getPackagesCallCount).equals(2);
    });
  });
}
