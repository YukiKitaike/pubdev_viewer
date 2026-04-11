import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pubdev_viewer/core/error/app_exception.dart';
import 'package:pubdev_viewer/features/package_detail/models/package_detail_response.dart';
import 'package:pubdev_viewer/features/package_detail/models/package_publisher_response.dart';
import 'package:pubdev_viewer/features/package_detail/repository/package_detail_repository.dart';
import 'package:pubdev_viewer/features/package_detail/screens/package_detail_screen.dart';

import '../../../helpers/fakes.dart';
import '../../../helpers/fixtures.dart';

Future<PackageDetailResponse> _detailResponse(String _) async =>
    PackageDetailResponse.fromJson(
      Map<String, dynamic>.from(packageDetailResponseJson),
    );

Future<PackagePublisherResponse> _publisherResponse(String _) async =>
    PackagePublisherResponse.fromJson(
      Map<String, dynamic>.from(packagePublisherResponseJson),
    );

void main() {
  late FakePackageDetailRepository fakeRepository;

  setUp(() {
    fakeRepository = FakePackageDetailRepository();
  });

  Widget createTestWidget({String packageName = 'http'}) {
    return ProviderScope(
      overrides: [
        packageDetailRepositoryProvider.overrideWithValue(fakeRepository),
      ],
      child: MaterialApp(
        home: PackageDetailScreen(packageName: packageName),
      ),
    );
  }

  void stubSuccessResponse() {
    fakeRepository
      ..onGetPackageDetail = _detailResponse
      ..onGetPackagePublisher = _publisherResponse;
  }

  group('PackageDetailScreen', () {
    testWidgets('shows loading indicator initially', (tester) async {
      final detailCompleter = Completer<PackageDetailResponse>();
      fakeRepository
        ..getPackageDetailCompleter = detailCompleter
        ..onGetPackagePublisher = _publisherResponse;

      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(
        find.byType(CircularProgressIndicator),
        findsOneWidget,
      );

      detailCompleter.complete(
        PackageDetailResponse.fromJson(
          Map<String, dynamic>.from(packageDetailResponseJson),
        ),
      );
      await tester.pumpAndSettle();
    });

    testWidgets('shows overview and versions on success', (tester) async {
      stubSuccessResponse();

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('http'), findsOneWidget);
      expect(find.text('Overview'), findsOneWidget);
      expect(
        find.text('A composable API for HTTP requests.'),
        findsOneWidget,
      );
      expect(find.text('dart.dev'), findsOneWidget);
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

        expect(find.byIcon(Icons.open_in_new), findsOneWidget);
      },
    );

    testWidgets('golden test for package detail', (tester) async {
      stubSuccessResponse();

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(PackageDetailScreen),
        matchesGoldenFile('goldens/package_detail_screen.png'),
      );
    });

    testWidgets('shows error view on failure', (tester) async {
      fakeRepository.onGetPackageDetail = (name) =>
          throw const NetworkException();
      // ignore: cascade_invocations
      fakeRepository.onGetPackagePublisher = _publisherResponse;

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('再試行'), findsOneWidget);
    });
  });
}
