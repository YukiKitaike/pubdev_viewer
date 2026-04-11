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
    test('getPackages returns parsed response', () async {
      fakeApiClient.onGetPackages = ({String? pageUrl}) async =>
          Map<String, dynamic>.from(packageListResponseJson);

      final response = await repository.getPackages();

      expect(response.packages, hasLength(2));
      expect(response.packages[0].name, 'http');
      expect(fakeApiClient.getPackagesCalls, hasLength(1));
    });

    test('getPackages passes pageUrl to api client', () async {
      const url = 'https://pub.dev/api/packages?page=2';
      fakeApiClient.onGetPackages = ({String? pageUrl}) async =>
          Map<String, dynamic>.from(packageListResponseLastPageJson);

      final response = await repository.getPackages(pageUrl: url);

      expect(response.packages, isEmpty);
      expect(response.nextUrl, isNull);
      expect(fakeApiClient.getPackagesCalls, [url]);
    });

    test('getPackages rethrows NetworkException', () {
      fakeApiClient.onGetPackages = ({String? pageUrl}) =>
          throw const NetworkException();

      expect(
        () => repository.getPackages(),
        throwsA(isA<NetworkException>()),
      );
    });

    test('getPackages rethrows ServerException', () {
      fakeApiClient.onGetPackages = ({String? pageUrl}) =>
          throw const ServerException(500);

      expect(
        () => repository.getPackages(),
        throwsA(
          isA<ServerException>().having(
            (e) => e.statusCode,
            'statusCode',
            500,
          ),
        ),
      );
    });
  });
}
