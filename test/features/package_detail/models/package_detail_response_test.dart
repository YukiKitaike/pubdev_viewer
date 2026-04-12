@Tags(['unit'])
library;

import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pubdev_viewer/features/package_detail/models/package_detail_response.dart';
import 'package:pubdev_viewer/features/package_detail/models/package_publisher_response.dart';

import '../../../helpers/fixtures.dart';

void main() {
  group('PackageDetailResponse', () {
    test('fromJson が正しくパースする', () {
      final response = PackageDetailResponse.fromJson(
        Map<String, dynamic>.from(
          packageDetailResponseJson,
        ),
      );

      check(response.name).equals('http');
      check(response.latest.version).equals('1.6.0');
      check(
        response.latest.pubspec.description,
      ).equals('A composable API for HTTP requests.');
      check(response.latest.pubspec.homepage).equals('https://example.com');
      check(response.versions).length.equals(2);
    });
  });

  group('PackagePublisherResponse', () {
    test('fromJson が publisherId 付きでパースする', () {
      final response = PackagePublisherResponse.fromJson(
        Map<String, dynamic>.from(
          packagePublisherResponseJson,
        ),
      );

      check(response.publisherId).equals('dart.dev');
    });

    test('fromJson が publisherId null でパースする', () {
      final response = PackagePublisherResponse.fromJson(
        Map<String, dynamic>.from(
          packagePublisherNullResponseJson,
        ),
      );

      check(response.publisherId).isNull();
    });
  });
}
