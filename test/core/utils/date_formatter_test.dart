@Tags(['unit'])
library;

import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pubdev_viewer/core/utils/date_formatter.dart';

void main() {
  group('formatDate', () {
    test('通常の日時を yyyy-MM-dd 形式にフォーマットする', () {
      check(formatDate(DateTime(2025, 3, 15))).equals('2025-03-15');
    });

    test('UTC の日時を正しくフォーマットする', () {
      check(formatDate(DateTime.utc(2025))).equals('2025-01-01');
    });

    test('年末の日時を正しくフォーマットする', () {
      check(formatDate(DateTime(2025, 12, 31))).equals('2025-12-31');
    });

    test('1 桁の月日をゼロ埋めする', () {
      check(formatDate(DateTime(2025, 1, 5))).equals('2025-01-05');
    });
  });
}
