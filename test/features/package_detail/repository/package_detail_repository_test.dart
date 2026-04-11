import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pubdev_viewer/features/package_detail/repository/package_detail_repository.dart';

import '../../../helpers/fixtures.dart';
import '../../../helpers/mocks.dart';

void main() {
  late MockPubDevApiClient mockApiClient;
  late PackageDetailRepository repository;

  setUp(() {
    mockApiClient = MockPubDevApiClient();
    repository = PackageDetailRepository(mockApiClient);
  });

  group('PackageDetailRepository', () {
    test('getPackageDetail returns parsed response', () async {
      when(() => mockApiClient.getPackageDetail('http'))
          .thenAnswer(
        (_) async => Map<String, dynamic>.from(
          packageDetailResponseJson,
        ),
      );

      final response =
          await repository.getPackageDetail('http');

      expect(response.name, 'http');
      expect(response.versions, hasLength(2));
      verify(
        () => mockApiClient.getPackageDetail('http'),
      ).called(1);
    });

    test(
      'getPackagePublisher returns parsed response',
      () async {
        when(
          () => mockApiClient.getPackagePublisher('http'),
        ).thenAnswer(
          (_) async => Map<String, dynamic>.from(
            packagePublisherResponseJson,
          ),
        );

        final response =
            await repository.getPackagePublisher('http');

        expect(response.publisherId, 'dart.dev');
        verify(
          () => mockApiClient.getPackagePublisher('http'),
        ).called(1);
      },
    );
  });
}
