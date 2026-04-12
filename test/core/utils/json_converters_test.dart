@Tags(['unit'])
library;

import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pubdev_viewer/core/utils/json_converters.dart';

void main() {
  group('dateTimeFromIso8601', () {
    test('UTC 文字列を DateTime に変換する', () {
      final result = dateTimeFromIso8601('2025-11-10T18:27:56.434747Z');

      check(result.year).equals(2025);
      check(result.month).equals(11);
      check(result.day).equals(10);
      check(result.hour).equals(18);
      check(result.minute).equals(27);
      check(result.second).equals(56);
      check(result.isUtc).isTrue();
    });

    test('タイムゾーンなし文字列を DateTime に変換する', () {
      final result = dateTimeFromIso8601('2025-06-01T12:00:00.000000');

      check(result.year).equals(2025);
      check(result.month).equals(6);
      check(result.day).equals(1);
      check(result.hour).equals(12);
    });
  });

  group('dateTimeToIso8601', () {
    test('DateTime を ISO 8601 文字列に変換する', () {
      final result = dateTimeToIso8601(DateTime.utc(2025, 11, 10, 18, 27, 56));

      check(result).equals('2025-11-10T18:27:56.000Z');
    });
  });

  group('ラウンドトリップ', () {
    test('変換後に元の値と一致する', () {
      final original = DateTime.utc(2025, 11, 10, 18, 27, 56);
      final roundTripped = dateTimeFromIso8601(dateTimeToIso8601(original));

      check(roundTripped).equals(original);
    });
  });
}
