import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pubdev_viewer/core/error/app_exception.dart';
import 'package:pubdev_viewer/features/package_detail/models/package_detail_response.dart';
import 'package:pubdev_viewer/features/package_detail/models/package_publisher_response.dart';
import 'package:pubdev_viewer/features/package_detail/notifiers/package_detail_notifier.dart';
import 'package:pubdev_viewer/features/package_detail/repository/package_detail_repository.dart';

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
  late ProviderContainer container;

  setUp(() {
    fakeRepository = FakePackageDetailRepository();
    container = ProviderContainer(
      overrides: [
        packageDetailRepositoryProvider.overrideWithValue(fakeRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('PackageDetailNotifier', () {
    test('build が detail と publisher を並列取得する', () async {
      fakeRepository
        ..onGetPackageDetail = _detailResponse
        ..onGetPackagePublisher = _publisherResponse;

      final state = await container.read(
        packageDetailNotifierProvider('http').future,
      );

      expect(state.detail.name, 'http');
      expect(state.publisher.publisherId, 'dart.dev');
      expect(fakeRepository.getPackageDetailCallCount, 1);
      expect(fakeRepository.getPackagePublisherCallCount, 1);
    });

    test('publisherId が null のケースを処理する', () async {
      fakeRepository
        ..onGetPackageDetail = _detailResponse
        ..onGetPackagePublisher = (name) async =>
            PackagePublisherResponse.fromJson(
              Map<String, dynamic>.from(packagePublisherNullResponseJson),
            );

      final state = await container.read(
        packageDetailNotifierProvider('http').future,
      );

      expect(state.publisher.publisherId, isNull);
    });

    test('getPackageDetail が例外を投げると AsyncError になる', () async {
      fakeRepository.onGetPackageDetail = (_) => throw const NetworkException();
      // ignore: cascade_invocations
      fakeRepository.onGetPackagePublisher = _publisherResponse;

      await container
          .read(packageDetailNotifierProvider('http').future)
          .then((_) => null)
          .catchError((_) => null);

      final asyncValue = container.read(
        packageDetailNotifierProvider('http'),
      );
      expect(asyncValue.hasError, isTrue);
    });

    test('refresh が再ビルドをトリガーする', () async {
      fakeRepository
        ..onGetPackageDetail = _detailResponse
        ..onGetPackagePublisher = _publisherResponse;

      await container.read(packageDetailNotifierProvider('http').future);
      expect(fakeRepository.getPackageDetailCallCount, 1);

      await container
          .read(packageDetailNotifierProvider('http').notifier)
          .refresh();
      expect(fakeRepository.getPackageDetailCallCount, 2);
    });
  });
}
