import 'package:flutter_test/flutter_test.dart';
import 'package:pubdev_viewer/core/utils/url_utils.dart';

void main() {
  group('pubDevPackageUrl', () {
    test('パッケージ名から正しい URI を生成する', () {
      expect(
        pubDevPackageUrl('http'),
        Uri.parse('https://pub.dev/packages/http'),
      );
    });

    test('スキームが https である', () {
      expect(pubDevPackageUrl('http').scheme, 'https');
    });

    test('ホストが pub.dev である', () {
      expect(pubDevPackageUrl('http').host, 'pub.dev');
    });
  });

  group('isHttpUrl', () {
    test('null の場合 false を返す', () {
      expect(isHttpUrl(null), isFalse);
    });

    test('空文字列の場合 false を返す', () {
      expect(isHttpUrl(''), isFalse);
    });

    test('https URL の場合 true を返す', () {
      expect(isHttpUrl('https://example.com'), isTrue);
    });

    test('http URL の場合 true を返す', () {
      expect(isHttpUrl('http://example.com'), isTrue);
    });

    test('ftp URL の場合 false を返す', () {
      expect(isHttpUrl('ftp://example.com'), isFalse);
    });

    test('スキームなしの文字列の場合 false を返す', () {
      expect(isHttpUrl('example.com'), isFalse);
    });

    test('不正な URL の場合 false を返す', () {
      expect(isHttpUrl('not a url'), isFalse);
    });
  });
}
