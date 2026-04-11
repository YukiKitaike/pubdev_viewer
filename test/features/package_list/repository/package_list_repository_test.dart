import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pubdev_viewer/features/package_list/repository/package_list_repository.dart';

import '../../../helpers/fixtures.dart';
import '../../../helpers/mocks.dart';

void main() {
  late MockPubDevApiClient mockApiClient;
  late PackageListRepository repository;

  setUp(() {
    mockApiClient = MockPubDevApiClient();
    repository = PackageListRepository(mockApiClient);
  });

  group('PackageListRepository', () {
    test('getPackages returns parsed response', () async {
      when(() => mockApiClient.getPackages())
          .thenAnswer(
        (_) async => Map<String, dynamic>.from(
          packageListResponseJson,
        ),
      );

      final response = await repository.getPackages();

      expect(response.packages, hasLength(2));
      expect(response.packages[0].name, 'http');
      verify(() => mockApiClient.getPackages()).called(1);
    });

    test(
      'getPackages passes pageUrl to api client',
      () async {
        const url =
            'https://pub.dev/api/packages?page=2';
        when(
          () => mockApiClient.getPackages(pageUrl: url),
        ).thenAnswer(
          (_) async => Map<String, dynamic>.from(
            packageListResponseLastPageJson,
          ),
        );

        final response = await repository.getPackages(
          pageUrl: url,
        );

        expect(response.packages, isEmpty);
        expect(response.nextUrl, isNull);
        verify(
          () => mockApiClient.getPackages(pageUrl: url),
        ).called(1);
      },
    );
  });
}
