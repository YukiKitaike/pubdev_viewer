@Tags(['unit'])
library;

import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pubdev_viewer/features/package_list/models/package_list_response.dart';

import '../../../helpers/fixtures.dart';

void main() {
  group('PackageListResponse', () {
    test('fromJson が正しくパースする', () {
      final response = PackageListResponse.fromJson(
        Map<String, dynamic>.from(packageListResponseJson),
      );

      check(response.nextUrl).isNotNull();
      check(response.packages).length.equals(2);
      check(response.packages[0].name).equals('http');
      check(response.packages[0].latest.version).equals('1.6.0');
      check(response.packages[1].name).equals('dio');
    });

    test('fromJson が next_url null の最終ページをパースする', () {
      final response = PackageListResponse.fromJson(
        Map<String, dynamic>.from(
          packageListResponseLastPageJson,
        ),
      );

      check(response.nextUrl).isNull();
      check(response.packages).isEmpty();
    });
  });
}
