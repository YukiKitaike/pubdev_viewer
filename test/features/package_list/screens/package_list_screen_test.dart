import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pubdev_viewer/core/error/app_exception.dart';
import 'package:pubdev_viewer/features/package_list/models/package_list_response.dart';
import 'package:pubdev_viewer/features/package_list/repository/package_list_repository.dart';
import 'package:pubdev_viewer/features/package_list/screens/package_list_screen.dart';

import '../../../helpers/fakes.dart';
import '../../../helpers/fixtures.dart';

void main() {
  late FakePackageListRepository fakeRepository;

  setUp(() {
    fakeRepository = FakePackageListRepository();
  });

  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        packageListRepositoryProvider.overrideWithValue(fakeRepository),
      ],
      child: const MaterialApp(
        home: PackageListScreen(),
      ),
    );
  }

  group('PackageListScreen', () {
    testWidgets('shows loading indicator initially', (tester) async {
      final completer = Completer<PackageListResponse>();
      fakeRepository.getPackagesCompleter = completer;

      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(
        find.byType(CircularProgressIndicator),
        findsOneWidget,
      );

      completer.complete(
        PackageListResponse.fromJson(
          Map<String, dynamic>.from(packageListResponseLastPageJson),
        ),
      );
      await tester.pump();
    });

    testWidgets('shows package list when data loads', (tester) async {
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

    testWidgets('shows error view on failure', (tester) async {
      fakeRepository.onGetPackages = ({String? pageUrl}) =>
          throw const NetworkException();

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('再試行'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('golden test for package list', (tester) async {
      fakeRepository.onGetPackages = ({String? pageUrl}) async =>
          PackageListResponse.fromJson(
            Map<String, dynamic>.from(packageListResponseJson),
          );

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(PackageListScreen),
        matchesGoldenFile('goldens/package_list_screen.png'),
      );
    });

    testWidgets('retry button refetches data', (tester) async {
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

      await tester.tap(find.text('再試行'));
      await tester.pump();
      await tester.pump();

      expect(find.text('http'), findsOneWidget);
    });
  });
}
