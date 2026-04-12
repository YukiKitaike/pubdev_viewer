import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pubdev_viewer/core/design_system/design_system.dart';
import 'package:pubdev_viewer/core/utils/gradient_selector.dart';

void main() {
  group('selectGradientByName', () {
    test('同じ名前で常に同じグラデーションを返す', () {
      final first = selectGradientByName('http');
      final second = selectGradientByName('http');

      expect(first, second);
    });

    test('異なる名前で異なるグラデーションを返す可能性がある', () {
      final httpGradient = selectGradientByName('http');
      final dioGradient = selectGradientByName('dio');

      expect(httpGradient, isNot(equals(dioGradient)));
    });

    test('空文字列でもクラッシュしない', () {
      final result = selectGradientByName('');

      expect(result, isA<List<Color>>());
      expect(result, isNotEmpty);
    });

    test('結果が AppColors.avatarGradients に含まれる', () {
      final result = selectGradientByName('http');

      expect(AppColors.avatarGradients, contains(result));
    });

    test('長い名前でもインデックス範囲内に収まる', () {
      final result = selectGradientByName(
        'very_long_package_name_that_exceeds_normal_length',
      );

      expect(result, isA<List<Color>>());
      expect(AppColors.avatarGradients, contains(result));
    });
  });
}
