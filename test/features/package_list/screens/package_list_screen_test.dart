import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pubdev_viewer/core/error/app_exception.dart';
import 'package:pubdev_viewer/features/package_list/models/package_list_response.dart';
import 'package:pubdev_viewer/features/package_list/repository/package_list_repository.dart';
import 'package:pubdev_viewer/features/package_list/screens/package_list_screen.dart';

import '../../../helpers/fixtures.dart';
import '../../../helpers/mocks.dart';

void main() {
  late MockPackageListRepository mockRepository;

  setUp(() {
    mockRepository = MockPackageListRepository();
  });

  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        packageListRepositoryProvider
            .overrideWithValue(mockRepository),
      ],
      child: const MaterialApp(
        home: PackageListScreen(),
      ),
    );
  }

  group('PackageListScreen', () {
    testWidgets('shows loading indicator initially', (
      tester,
    ) async {
      final completer =
          Completer<PackageListResponse>();
      when(
        () => mockRepository.getPackages(
          pageUrl: any(named: 'pageUrl'),
        ),
      ).thenAnswer((_) => completer.future);

      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(
        find.byType(CircularProgressIndicator),
        findsOneWidget,
      );

      // Complete and pump to clean up
      completer.complete(
        PackageListResponse.fromJson(
          Map<String, dynamic>.from(
            packageListResponseLastPageJson,
          ),
        ),
      );
      await tester.pump();
    });

    testWidgets('shows package list when data loads', (
      tester,
    ) async {
      var callCount = 0;
      when(
        () => mockRepository.getPackages(
          pageUrl: any(named: 'pageUrl'),
        ),
      ).thenAnswer((_) async {
        callCount++;
        if (callCount == 1) {
          return PackageListResponse.fromJson(
            Map<String, dynamic>.from(
              packageListResponseJson,
            ),
          );
        }
        return PackageListResponse.fromJson(
          Map<String, dynamic>.from(
            packageListResponseLastPageJson,
          ),
        );
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pump();
      await tester.pump();

      expect(find.text('http'), findsOneWidget);
      expect(find.text('dio'), findsOneWidget);
      expect(find.text('v1.6.0'), findsOneWidget);
      expect(find.text('v5.8.0'), findsOneWidget);
    });

    testWidgets('shows error view on failure', (
      tester,
    ) async {
      when(
        () => mockRepository.getPackages(
          pageUrl: any(named: 'pageUrl'),
        ),
      ).thenThrow(const NetworkException());

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('再試行'), findsOneWidget);
      expect(
        find.byIcon(Icons.error_outline),
        findsOneWidget,
      );
    });

    testWidgets('retry button refetches data', (
      tester,
    ) async {
      var callCount = 0;
      when(
        () => mockRepository.getPackages(
          pageUrl: any(named: 'pageUrl'),
        ),
      ).thenAnswer((_) async {
        callCount++;
        if (callCount == 1) {
          throw const NetworkException();
        }
        return PackageListResponse.fromJson(
          Map<String, dynamic>.from(
            packageListResponseJson,
          ),
        );
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap retry
      await tester.tap(find.text('再試行'));
      await tester.pump();
      await tester.pump();

      expect(find.text('http'), findsOneWidget);
    });
  });
}
