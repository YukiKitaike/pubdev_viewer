import 'package:flutter_test/flutter_test.dart';
import 'package:pubdev_viewer/features/package_list/models/package_list_response.dart';

import '../../../helpers/fixtures.dart';

void main() {
  group('PackageListResponse', () {
    test('fromJson が正しくパースする', () {
      final response = PackageListResponse.fromJson(
        Map<String, dynamic>.from(packageListResponseJson),
      );

      expect(response.nextUrl, isNotNull);
      expect(response.packages, hasLength(2));
      expect(response.packages[0].name, 'http');
      expect(
        response.packages[0].latest.version,
        '1.6.0',
      );
      expect(response.packages[1].name, 'dio');
    });

    test('fromJson が next_url null の最終ページをパースする', () {
      final response = PackageListResponse.fromJson(
        Map<String, dynamic>.from(
          packageListResponseLastPageJson,
        ),
      );

      expect(response.nextUrl, isNull);
      expect(response.packages, isEmpty);
    });
  });
}
