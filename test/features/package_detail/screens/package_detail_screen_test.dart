import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pubdev_viewer/core/error/app_exception.dart';
import 'package:pubdev_viewer/features/package_detail/models/package_detail_response.dart';
import 'package:pubdev_viewer/features/package_detail/models/package_publisher_response.dart';
import 'package:pubdev_viewer/features/package_detail/repository/package_detail_repository.dart';
import 'package:pubdev_viewer/features/package_detail/screens/package_detail_screen.dart';

import '../../../helpers/fixtures.dart';
import '../../../helpers/mocks.dart';

void main() {
  late MockPackageDetailRepository mockRepository;

  setUp(() {
    mockRepository = MockPackageDetailRepository();
  });

  Widget createTestWidget({String packageName = 'http'}) {
    return ProviderScope(
      overrides: [
        packageDetailRepositoryProvider
            .overrideWithValue(mockRepository),
      ],
      child: MaterialApp(
        home: PackageDetailScreen(
          packageName: packageName,
        ),
      ),
    );
  }

  void stubSuccessResponse() {
    when(
      () => mockRepository.getPackageDetail('http'),
    ).thenAnswer(
      (_) async => PackageDetailResponse.fromJson(
        Map<String, dynamic>.from(
          packageDetailResponseJson,
        ),
      ),
    );
    when(
      () => mockRepository.getPackagePublisher('http'),
    ).thenAnswer(
      (_) async => PackagePublisherResponse.fromJson(
        Map<String, dynamic>.from(
          packagePublisherResponseJson,
        ),
      ),
    );
  }

  group('PackageDetailScreen', () {
    testWidgets('shows loading indicator initially', (
      tester,
    ) async {
      final detailCompleter =
          Completer<PackageDetailResponse>();
      when(
        () => mockRepository.getPackageDetail('http'),
      ).thenAnswer((_) => detailCompleter.future);
      when(
        () => mockRepository.getPackagePublisher('http'),
      ).thenAnswer(
        (_) async => PackagePublisherResponse.fromJson(
          Map<String, dynamic>.from(
            packagePublisherResponseJson,
          ),
        ),
      );

      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(
        find.byType(CircularProgressIndicator),
        findsOneWidget,
      );

      // Complete to clean up
      detailCompleter.complete(
        PackageDetailResponse.fromJson(
          Map<String, dynamic>.from(
            packageDetailResponseJson,
          ),
        ),
      );
      await tester.pumpAndSettle();
    });

    testWidgets('shows overview and versions on success', (
      tester,
    ) async {
      stubSuccessResponse();

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // AppBar title
      expect(find.text('http'), findsOneWidget);

      // Overview section
      expect(find.text('Overview'), findsOneWidget);
      expect(
        find.text(
          'A composable API for HTTP requests.',
        ),
        findsOneWidget,
      );
      expect(find.text('dart.dev'), findsOneWidget);

      // Versions section
      expect(find.text('Versions'), findsOneWidget);
      expect(find.text('1.6.0'), findsOneWidget);
      expect(find.text('1.5.0'), findsOneWidget);
    });

    testWidgets(
      'shows external link icon when homepage exists',
      (tester) async {
        stubSuccessResponse();

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(
          find.byIcon(Icons.open_in_new),
          findsOneWidget,
        );
      },
    );

    testWidgets('shows error view on failure', (
      tester,
    ) async {
      when(
        () => mockRepository.getPackageDetail('http'),
      ).thenThrow(const NetworkException());
      when(
        () => mockRepository.getPackagePublisher('http'),
      ).thenAnswer(
        (_) async => PackagePublisherResponse.fromJson(
          Map<String, dynamic>.from(
            packagePublisherResponseJson,
          ),
        ),
      );

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('再試行'), findsOneWidget);
    });
  });
}
