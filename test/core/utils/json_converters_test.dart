import 'package:flutter_test/flutter_test.dart';
import 'package:pubdev_viewer/core/utils/json_converters.dart';

void main() {
  group('dateTimeFromIso8601', () {
    test('UTC 文字列を DateTime に変換する', () {
      final result = dateTimeFromIso8601('2025-11-10T18:27:56.434747Z');

      expect(result.year, 2025);
      expect(result.month, 11);
      expect(result.day, 10);
      expect(result.hour, 18);
      expect(result.minute, 27);
      expect(result.second, 56);
      expect(result.isUtc, isTrue);
    });

    test('タイムゾーンなし文字列を DateTime に変換する', () {
      final result = dateTimeFromIso8601('2025-06-01T12:00:00.000000');

      expect(result.year, 2025);
      expect(result.month, 6);
      expect(result.day, 1);
      expect(result.hour, 12);
    });
  });

  group('dateTimeToIso8601', () {
    test('DateTime を ISO 8601 文字列に変換する', () {
      final result = dateTimeToIso8601(DateTime.utc(2025, 11, 10, 18, 27, 56));

      expect(result, '2025-11-10T18:27:56.000Z');
    });
  });

  group('ラウンドトリップ', () {
    test('変換後に元の値と一致する', () {
      final original = DateTime.utc(2025, 11, 10, 18, 27, 56);
      final roundTripped = dateTimeFromIso8601(dateTimeToIso8601(original));

      expect(roundTripped, original);
    });
  });
}
