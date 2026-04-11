import 'package:flutter_test/flutter_test.dart';
import 'package:pubdev_viewer/core/error/app_exception.dart';
import 'package:pubdev_viewer/features/package_detail/repository/package_detail_repository.dart';

import '../../../helpers/fakes.dart';
import '../../../helpers/fixtures.dart';

void main() {
  late FakePubDevApiClient fakeApiClient;
  late PackageDetailRepository repository;

  setUp(() {
    fakeApiClient = FakePubDevApiClient();
    repository = PackageDetailRepository(fakeApiClient);
  });

  group('PackageDetailRepository', () {
    test('getPackageDetail returns parsed response', () async {
      fakeApiClient.onGetPackageDetail = (name) async =>
          Map<String, dynamic>.from(packageDetailResponseJson);

      final response = await repository.getPackageDetail('http');

      expect(response.name, 'http');
      expect(response.versions, hasLength(2));
      expect(fakeApiClient.getPackageDetailCalls, ['http']);
    });

    test('getPackagePublisher returns parsed response', () async {
      fakeApiClient.onGetPackagePublisher = (name) async =>
          Map<String, dynamic>.from(packagePublisherResponseJson);

      final response = await repository.getPackagePublisher('http');

      expect(response.publisherId, 'dart.dev');
      expect(fakeApiClient.getPackagePublisherCalls, ['http']);
    });

    test('getPackageDetail rethrows NetworkException', () {
      fakeApiClient.onGetPackageDetail = (name) =>
          throw const NetworkException();

      expect(
        () => repository.getPackageDetail('http'),
        throwsA(isA<NetworkException>()),
      );
    });

    test('getPackagePublisher rethrows ServerException', () {
      fakeApiClient.onGetPackagePublisher = (name) =>
          throw const ServerException(500);

      expect(
        () => repository.getPackagePublisher('http'),
        throwsA(isA<ServerException>()),
      );
    });
  });
}
