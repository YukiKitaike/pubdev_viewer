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

      expect(response.name, 'http');
      expect(response.latest.version, '1.6.0');
      expect(
        response.latest.pubspec.description,
        'A composable API for HTTP requests.',
      );
      expect(
        response.latest.pubspec.homepage,
        'https://example.com',
      );
      expect(response.versions, hasLength(2));
    });
  });

  group('PackagePublisherResponse', () {
    test('fromJson が publisherId 付きでパースする', () {
      final response = PackagePublisherResponse.fromJson(
        Map<String, dynamic>.from(
          packagePublisherResponseJson,
        ),
      );

      expect(response.publisherId, 'dart.dev');
    });

    test('fromJson が publisherId null でパースする', () {
      final response = PackagePublisherResponse.fromJson(
        Map<String, dynamic>.from(
          packagePublisherNullResponseJson,
        ),
      );

      expect(response.publisherId, isNull);
    });
  });
}
