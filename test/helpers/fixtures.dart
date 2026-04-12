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
