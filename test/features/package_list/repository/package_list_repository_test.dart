@Tags(['unit'])
library;

import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pubdev_viewer/core/error/app_exception.dart';
import 'package:pubdev_viewer/features/package_list/repository/package_list_repository.dart';

import '../../../helpers/fakes.dart';
import '../../../helpers/fixtures.dart';

void main() {
  late FakePubDevApiClient fakeApiClient;
  late PackageListRepository repository;

  setUp(() {
    fakeApiClient = FakePubDevApiClient();
    repository = PackageListRepository(fakeApiClient);
  });

  group('PackageListRepository', () {
    test('getPackages がパース済みレスポンスを返す', () async {
      fakeApiClient.onGetPackages = ({String? pageUrl}) async =>
          Map<String, dynamic>.from(packageListResponseJson);

      final response = await repository.getPackages();

      check(response.packages).length.equals(2);
      check(response.packages[0].name).equals('http');
      check(fakeApiClient.getPackagesCalls).length.equals(1);
    });

    test('getPackages が pageUrl を API クライアントに渡す', () async {
      const url = 'https://pub.dev/api/packages?page=2';
      fakeApiClient.onGetPackages = ({String? pageUrl}) async =>
          Map<String, dynamic>.from(packageListResponseLastPageJson);

      final response = await repository.getPackages(pageUrl: url);

      check(response.packages).isEmpty();
      check(response.nextUrl).isNull();
      check(fakeApiClient.getPackagesCalls).deepEquals([url]);
    });

    test('getPackages が NetworkException を再スローする', () async {
      fakeApiClient.onGetPackages = ({String? pageUrl}) =>
          throw const NetworkException();

      await check(repository.getPackages()).throws<NetworkException>();
    });

    test('getPackages が ServerException を再スローする', () async {
      fakeApiClient.onGetPackages = ({String? pageUrl}) =>
          throw const ServerException(500);

      await check(repository.getPackages()).throws<ServerException>();
    });
  });
}
