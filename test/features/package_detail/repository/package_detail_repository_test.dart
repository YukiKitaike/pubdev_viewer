@Tags(['unit'])
library;

import 'package:checks/checks.dart';
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
    test('getPackageDetail がパース済みレスポンスを返す', () async {
      fakeApiClient.onGetPackageDetail = (name) async =>
          Map<String, dynamic>.from(packageDetailResponseJson);

      final response = await repository.getPackageDetail('http');

      check(response.name).equals('http');
      check(response.versions).length.equals(2);
      check(fakeApiClient.getPackageDetailCalls).deepEquals(['http']);
    });

    test('getPackagePublisher がパース済みレスポンスを返す', () async {
      fakeApiClient.onGetPackagePublisher = (name) async =>
          Map<String, dynamic>.from(packagePublisherResponseJson);

      final response = await repository.getPackagePublisher('http');

      check(response.publisherId).equals('dart.dev');
      check(fakeApiClient.getPackagePublisherCalls).deepEquals(['http']);
    });

    test('getPackageDetail が NetworkException を再スローする', () async {
      fakeApiClient.onGetPackageDetail = (name) =>
          throw const NetworkException();

      await check(
        repository.getPackageDetail('http'),
      ).throws<NetworkException>();
    });

    test('getPackagePublisher が ServerException を再スローする', () async {
      fakeApiClient.onGetPackagePublisher = (name) =>
          throw const ServerException(500);

      await check(
        repository.getPackagePublisher('http'),
      ).throws<ServerException>();
    });
  });
}
