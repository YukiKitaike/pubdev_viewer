@Tags(['unit'])
library;

import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pubdev_viewer/core/utils/url_utils.dart';

void main() {
  group('pubDevPackageUrl', () {
    test('パッケージ名から正しい URI を生成する', () {
      check(
        pubDevPackageUrl('http'),
      ).equals(Uri.parse('https://pub.dev/packages/http'));
    });

    test('スキームが https である', () {
      check(pubDevPackageUrl('http').scheme).equals('https');
    });

    test('ホストが pub.dev である', () {
      check(pubDevPackageUrl('http').host).equals('pub.dev');
    });
  });

  group('isHttpUrl', () {
    test('null の場合 false を返す', () {
      check(isHttpUrl(null)).isFalse();
    });

    test('空文字列の場合 false を返す', () {
      check(isHttpUrl('')).isFalse();
    });

    test('https URL の場合 true を返す', () {
      check(isHttpUrl('https://example.com')).isTrue();
    });

    test('http URL の場合 true を返す', () {
      check(isHttpUrl('http://example.com')).isTrue();
    });

    test('ftp URL の場合 false を返す', () {
      check(isHttpUrl('ftp://example.com')).isFalse();
    });

    test('スキームなしの文字列の場合 false を返す', () {
      check(isHttpUrl('example.com')).isFalse();
    });

    test('不正な URL の場合 false を返す', () {
      check(isHttpUrl('not a url')).isFalse();
    });
  });
}
