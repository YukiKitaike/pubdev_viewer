@Tags(['unit'])
library;

import 'package:checks/checks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pubdev_viewer/core/error/app_exception.dart';
import 'package:pubdev_viewer/features/package_detail/models/package_detail_response.dart';
import 'package:pubdev_viewer/features/package_detail/models/package_publisher_response.dart';
import 'package:pubdev_viewer/features/package_detail/notifiers/package_detail_notifier.dart';
import 'package:pubdev_viewer/features/package_detail/repository/package_detail_repository.dart';

import '../../../helpers/fakes.dart';
import '../../../helpers/fixtures.dart';

// Fake のコールバック型に合わせるためのラッパー
Future<PackageDetailResponse> _detailCallback(String _) async =>
    detailResponse();

Future<PackagePublisherResponse> _publisherCallback(String _) async =>
    publisherResponse();

void main() {
  late FakePackageDetailRepository fakeRepository;
  late ProviderContainer container;

  setUp(() {
    fakeRepository = FakePackageDetailRepository();
    container = ProviderContainer.test(
      // Riverpod v3 の自動リトライを無効化。エラー系テストが安定しなくなるため。
      retry: (_, _) => null,
      overrides: [
        packageDetailRepositoryProvider.overrideWithValue(fakeRepository),
      ],
    );
  });

  group('PackageDetailNotifier', () {
    test('build が detail と publisher を並列取得する', () async {
      fakeRepository
        ..onGetPackageDetail = _detailCallback
        ..onGetPackagePublisher = _publisherCallback;

      final state = await container.read(
        packageDetailProvider('http').future,
      );

      check(state.detail.name).equals('http');
      check(state.publisher.publisherId).equals('dart.dev');
      check(fakeRepository.getPackageDetailCallCount).equals(1);
      check(fakeRepository.getPackagePublisherCallCount).equals(1);
    });

    test('publisherId が null のケースを処理する', () async {
      fakeRepository
        ..onGetPackageDetail = _detailCallback
        ..onGetPackagePublisher = (name) async =>
            PackagePublisherResponse.fromJson(
              Map<String, dynamic>.from(packagePublisherNullResponseJson),
            );

      final state = await container.read(
        packageDetailProvider('http').future,
      );

      check(state.publisher.publisherId).isNull();
    });

    test('getPackageDetail が例外を投げると AsyncError になる', () async {
      fakeRepository.onGetPackageDetail = (_) => throw const NetworkException();
      // throw 式を含むアロー関数では cascade が使えないため個別代入する
      // ignore: cascade_invocations
      fakeRepository.onGetPackagePublisher = _publisherCallback;

      await container
          .read(packageDetailProvider('http').future)
          .then((_) => null)
          .catchError((_) => null);

      final asyncValue = container.read(
        packageDetailProvider('http'),
      );
      check(asyncValue.hasError).isTrue();
    });

    test('getPackagePublisher が例外を投げると AsyncError になる', () async {
      fakeRepository
        ..onGetPackageDetail = _detailCallback
        ..onGetPackagePublisher = (_) => throw const NetworkException();

      await container
          .read(packageDetailProvider('http').future)
          .then((_) => null)
          .catchError((_) => null);

      final asyncValue = container.read(
        packageDetailProvider('http'),
      );
      check(asyncValue.hasError).isTrue();
    });

    test('sortedVersions が published 降順で並んでいる', () async {
      fakeRepository
        ..onGetPackageDetail = _detailCallback
        ..onGetPackagePublisher = _publisherCallback;

      final state = await container.read(
        packageDetailProvider('http').future,
      );

      check(state.sortedVersions).length.equals(2);
      check(state.sortedVersions[0].version).equals('1.6.0');
      check(state.sortedVersions[1].version).equals('1.5.0');
      check(
        state.sortedVersions[0].published.isAfter(
          state.sortedVersions[1].published,
        ),
      ).isTrue();
    });

    test('refresh が再ビルドをトリガーする', () async {
      fakeRepository
        ..onGetPackageDetail = _detailCallback
        ..onGetPackagePublisher = _publisherCallback;

      await container.read(packageDetailProvider('http').future);
      check(fakeRepository.getPackageDetailCallCount).equals(1);

      await container.read(packageDetailProvider('http').notifier).refresh();
      check(fakeRepository.getPackageDetailCallCount).equals(2);
    });
  });
}
