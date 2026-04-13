@Tags(['unit'])
library;

import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pubdev_viewer/core/utils/string_utils.dart';

void main() {
  group('firstGrapheme', () {
    test('通常の英字は先頭 1 文字を返す', () {
      check(firstGrapheme('flutter')).equals('f');
    });

    test('空文字はデフォルト fallback を返す', () {
      check(firstGrapheme('')).equals('?');
    });

    test('空文字 + カスタム fallback を返す', () {
      check(firstGrapheme('', fallback: '#')).equals('#');
    });

    test('絵文字は合字単位で 1 グラフィムを返す', () {
      // ZWJ 合字絵文字は UTF-16 単位では複数 code unit だが、
      // グラフィムクラスタとしては 1 単位になる。
      check(firstGrapheme('👨‍👩‍👧 family').length).isGreaterThan(1);
    });

    test('マルチバイト文字は 1 文字を返す', () {
      check(firstGrapheme('あいうえお')).equals('あ');
    });
  });
}
