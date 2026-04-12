import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:pubdev_viewer/app/theme.dart';
import 'package:pubdev_viewer/core/error/app_exception.dart';
import 'package:pubdev_viewer/core/strings/app_strings.dart';
import 'package:pubdev_viewer/features/package_detail/models/package_detail_response.dart';
import 'package:pubdev_viewer/features/package_detail/models/package_publisher_response.dart';
import 'package:pubdev_viewer/features/package_detail/repository/package_detail_repository.dart';
import 'package:pubdev_viewer/features/package_detail/screens/package_detail_screen.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import '../../../helpers/fakes.dart';
import '../../../helpers/fixtures.dart';

Future<PackageDetailResponse> _detailResponse(String _) async =>
    PackageDetailResponse.fromJson(
      Map<String, dynamic>.from(packageDetailResponseJson),
    );

Future<PackageDetailResponse> _detailResponseNoHomepage(String _) async =>
    PackageDetailResponse.fromJson(
      Map<String, dynamic>.from(packageDetailResponseNoHomepageJson),
    );

Future<PackageDetailResponse> _detailResponseNoUrl(String _) async =>
    PackageDetailResponse.fromJson(
      Map<String, dynamic>.from(packageDetailResponseNoUrlJson),
    );

Future<PackagePublisherResponse> _publisherResponse(String _) async =>
    PackagePublisherResponse.fromJson(
      Map<String, dynamic>.from(packagePublisherResponseJson),
    );

class _FakeUrlLauncher extends Fake
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {
  final List<String> launchedUrls = [];

  @override
  Future<bool> launchUrl(String url, LaunchOptions options) async {
    launchedUrls.add(url);
    return true;
  }
}

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
        theme: appLightTheme,
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
    testWidgets('初期表示でローディングインジケータが表示される', (tester) async {
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

    testWidgets('成功時に概要とバージョンが表示される', (tester) async {
      stubSuccessResponse();

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('http'), findsNWidgets(2)); // AppBar title + hero header
      expect(find.text('Overview'), findsOneWidget);
      expect(
        find.text('A composable API for HTTP requests.'),
        findsOneWidget,
      );
      expect(find.text('dart.dev'), findsOneWidget);
      expect(find.text('Versions'), findsOneWidget);
      expect(
        find.text('1.6.0'),
        findsNWidgets(2),
      ); // hero header + versions section
      expect(find.text('1.5.0'), findsOneWidget);
    });

    testWidgets(
      'homepage が存在する場合に外部リンクアイコンが表示される',
      (tester) async {
        stubSuccessResponse();

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.open_in_new), findsOneWidget);
      },
    );

    testWidgets(
      'homepage が null のとき repository URL で外部リンクアイコンが表示される',
      (tester) async {
        fakeRepository
          ..onGetPackageDetail = _detailResponseNoHomepage
          ..onGetPackagePublisher = _publisherResponse;

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.open_in_new), findsOneWidget);
      },
    );

    testWidgets(
      'homepage と repository が両方 null のとき外部リンクアイコンが非表示になる',
      (tester) async {
        fakeRepository
          ..onGetPackageDetail = _detailResponseNoUrl
          ..onGetPackagePublisher = _publisherResponse;

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.open_in_new), findsNothing);
      },
    );

    testWidgets(
      '外部リンクアイコンをタップすると homepage URL が開かれる',
      (tester) async {
        final fakeUrlLauncher = _FakeUrlLauncher();
        UrlLauncherPlatform.instance = fakeUrlLauncher;

        stubSuccessResponse();

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.open_in_new));
        await tester.pumpAndSettle();

        expect(fakeUrlLauncher.launchedUrls, ['https://example.com']);
      },
    );

    testWidgets(
      'homepage が null のとき外部リンクアイコンをタップすると repository URL が開かれる',
      (tester) async {
        final fakeUrlLauncher = _FakeUrlLauncher();
        UrlLauncherPlatform.instance = fakeUrlLauncher;

        fakeRepository
          ..onGetPackageDetail = _detailResponseNoHomepage
          ..onGetPackagePublisher = _publisherResponse;

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.open_in_new));
        await tester.pumpAndSettle();

        expect(
          fakeUrlLauncher.launchedUrls,
          ['https://github.com/dart-lang/http'],
        );
      },
    );

    testWidgets('エラー時にエラー画面が表示される', (tester) async {
      fakeRepository.onGetPackageDetail = (name) =>
          throw const NetworkException();
      // ignore: cascade_invocations
      fakeRepository.onGetPackagePublisher = _publisherResponse;

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.retry), findsOneWidget);
    });
  });
}
