import 'package:flutter_test/flutter_test.dart';
import 'package:pubdev_viewer/core/utils/date_formatter.dart';

void main() {
  group('formatDate', () {
    test('通常の日時を yyyy-MM-dd 形式にフォーマットする', () {
      expect(formatDate(DateTime(2025, 3, 15)), '2025-03-15');
    });

    test('UTC の日時を正しくフォーマットする', () {
      expect(formatDate(DateTime.utc(2025)), '2025-01-01');
    });

    test('年末の日時を正しくフォーマットする', () {
      expect(formatDate(DateTime(2025, 12, 31)), '2025-12-31');
    });

    test('1 桁の月日をゼロ埋めする', () {
      expect(formatDate(DateTime(2025, 1, 5)), '2025-01-05');
    });
  });
}
