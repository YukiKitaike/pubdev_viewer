import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pubdev_viewer/features/package_detail/models/package_detail_response.dart';
import 'package:pubdev_viewer/features/package_detail/models/package_publisher_response.dart';
import 'package:pubdev_viewer/features/package_detail/notifiers/package_detail_notifier.dart';
import 'package:pubdev_viewer/features/package_detail/repository/package_detail_repository.dart';

import '../../../helpers/fixtures.dart';
import '../../../helpers/mocks.dart';

void main() {
  late MockPackageDetailRepository mockRepository;
  late ProviderContainer container;

  setUp(() {
    mockRepository = MockPackageDetailRepository();
    container = ProviderContainer(
      overrides: [
        packageDetailRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('PackageDetailNotifier', () {
    test(
      'build fetches detail and publisher in parallel',
      () async {
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

        final state = await container.read(
          packageDetailNotifierProvider('http').future,
        );

        expect(state.detail.name, 'http');
        expect(state.publisher.publisherId, 'dart.dev');
        verify(
          () => mockRepository.getPackageDetail('http'),
        ).called(1);
        verify(
          () => mockRepository.getPackagePublisher('http'),
        ).called(1);
      },
    );

    test(
      'handles null publisherId',
      () async {
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
              packagePublisherNullResponseJson,
            ),
          ),
        );

        final state = await container.read(
          packageDetailNotifierProvider('http').future,
        );

        expect(state.publisher.publisherId, isNull);
      },
    );
  });
}
