import 'package:pubdev_viewer/features/package_detail/models/package_detail_response.dart';
import 'package:pubdev_viewer/features/package_detail/models/package_detail_version.dart';
import 'package:pubdev_viewer/features/package_detail/models/package_publisher_response.dart';
import 'package:pubdev_viewer/features/package_list/models/package_list_item.dart';
import 'package:pubdev_viewer/features/package_list/models/package_list_response.dart';

const Map<String, dynamic> packageListResponseJson = {
  'next_url': 'https://pub.dev/api/packages?page=2',
  'packages': [
    {
      'name': 'http',
      'latest': {
        'version': '1.6.0',
        'pubspec': {
          'name': 'http',
          'version': '1.6.0',
          'description': 'A composable API for HTTP requests.',
        },
        'archive_url': 'https://pub.dev/api/archives/http-1.6.0.tar.gz',
        'package_url': 'https://pub.dev/api/packages/http',
        'url': 'https://pub.dev/api/packages/http/versions/1.6.0',
      },
    },
    {
      'name': 'dio',
      'latest': {
        'version': '5.8.0',
        'pubspec': {
          'name': 'dio',
          'version': '5.8.0',
          'description': 'A powerful HTTP client for Dart.',
        },
        'archive_url': 'https://pub.dev/api/archives/dio-5.8.0.tar.gz',
        'package_url': 'https://pub.dev/api/packages/dio',
        'url': 'https://pub.dev/api/packages/dio/versions/5.8.0',
      },
    },
  ],
};

const Map<String, dynamic> packageListResponseLastPageJson = {
  'next_url': null,
  'packages': <Map<String, dynamic>>[],
};

const Map<String, dynamic> packageDetailResponseJson = {
  'name': 'http',
  'latest': {
    'version': '1.6.0',
    'pubspec': {
      'name': 'http',
      'version': '1.6.0',
      'description': 'A composable API for HTTP requests.',
      'homepage': 'https://example.com',
      'repository': 'https://github.com/dart-lang/http',
    },
    'archive_url': 'https://pub.dev/api/archives/http-1.6.0.tar.gz',
    'archive_sha256': 'abc123',
    'published': '2025-11-10T18:27:56.434747Z',
  },
  'versions': [
    {
      'version': '1.6.0',
      'pubspec': {
        'name': 'http',
        'version': '1.6.0',
        'description': 'A composable API for HTTP requests.',
      },
      'archive_url': 'https://pub.dev/api/archives/http-1.6.0.tar.gz',
      'archive_sha256': 'abc123',
      'published': '2025-11-10T18:27:56.434747Z',
    },
    {
      'version': '1.5.0',
      'pubspec': {
        'name': 'http',
        'version': '1.5.0',
        'description': 'A composable API for HTTP requests.',
      },
      'archive_url': 'https://pub.dev/api/archives/http-1.5.0.tar.gz',
      'archive_sha256': 'def456',
      'published': '2025-06-01T12:00:00.000000Z',
    },
  ],
};

/// homepage なし・repository ありのフィクスチャ
const Map<String, dynamic> packageDetailResponseNoHomepageJson = {
  'name': 'http',
  'latest': {
    'version': '1.6.0',
    'pubspec': {
      'name': 'http',
      'version': '1.6.0',
      'description': 'A composable API for HTTP requests.',
      'repository': 'https://github.com/dart-lang/http',
    },
    'archive_url': 'https://pub.dev/api/archives/http-1.6.0.tar.gz',
    'archive_sha256': 'abc123',
    'published': '2025-11-10T18:27:56.434747Z',
  },
  'versions': [
    {
      'version': '1.6.0',
      'pubspec': {
        'name': 'http',
        'version': '1.6.0',
        'description': 'A composable API for HTTP requests.',
      },
      'archive_url': 'https://pub.dev/api/archives/http-1.6.0.tar.gz',
      'archive_sha256': 'abc123',
      'published': '2025-11-10T18:27:56.434747Z',
    },
  ],
};

/// homepage・repository 両方なしのフィクスチャ
const Map<String, dynamic> packageDetailResponseNoUrlJson = {
  'name': 'http',
  'latest': {
    'version': '1.6.0',
    'pubspec': {
      'name': 'http',
      'version': '1.6.0',
      'description': 'A composable API for HTTP requests.',
    },
    'archive_url': 'https://pub.dev/api/archives/http-1.6.0.tar.gz',
    'archive_sha256': 'abc123',
    'published': '2025-11-10T18:27:56.434747Z',
  },
  'versions': [
    {
      'version': '1.6.0',
      'pubspec': {
        'name': 'http',
        'version': '1.6.0',
        'description': 'A composable API for HTTP requests.',
      },
      'archive_url': 'https://pub.dev/api/archives/http-1.6.0.tar.gz',
      'archive_sha256': 'abc123',
      'published': '2025-11-10T18:27:56.434747Z',
    },
  ],
};

const packagePublisherResponseJson = {
  'publisherId': 'dart.dev',
};

const packagePublisherNullResponseJson = {
  'publisherId': null,
};

// ---------------------------------------------------------------------------
// フィクスチャビルダー
// const マップを直接 fromJson に渡すと内部変換で UnmodifiableMapError になるため
// Map.from() でコピーしてからパースする
// ---------------------------------------------------------------------------

PackageListResponse firstPageResponse() => PackageListResponse.fromJson(
  Map<String, dynamic>.from(packageListResponseJson),
);

PackageListResponse lastPageResponse() => PackageListResponse.fromJson(
  Map<String, dynamic>.from(packageListResponseLastPageJson),
);

PackageDetailResponse detailResponse() => PackageDetailResponse.fromJson(
  Map<String, dynamic>.from(packageDetailResponseJson),
);

PackageDetailResponse detailResponseNoHomepage() =>
    PackageDetailResponse.fromJson(
      Map<String, dynamic>.from(packageDetailResponseNoHomepageJson),
    );

PackageDetailResponse detailResponseNoUrl() => PackageDetailResponse.fromJson(
  Map<String, dynamic>.from(packageDetailResponseNoUrlJson),
);

PackagePublisherResponse publisherResponse() =>
    PackagePublisherResponse.fromJson(
      Map<String, dynamic>.from(packagePublisherResponseJson),
    );

PackagePublisherResponse publisherNullResponse() =>
    PackagePublisherResponse.fromJson(
      Map<String, dynamic>.from(packagePublisherNullResponseJson),
    );

PackageListItem httpPackageItem() => PackageListItem.fromJson(
  Map<String, dynamic>.from(
    (packageListResponseJson['packages']! as List)[0] as Map,
  ),
);

PackageListItem dioPackageItem() => PackageListItem.fromJson(
  Map<String, dynamic>.from(
    (packageListResponseJson['packages']! as List)[1] as Map,
  ),
);

List<PackageDetailVersion> sortedVersions() {
  final detail = detailResponse();
  return [...detail.versions]
    ..sort((a, b) => b.published.compareTo(a.published));
}
