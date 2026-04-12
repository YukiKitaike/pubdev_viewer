import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pubdev_viewer/app/theme_mode_notifier.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });

  group('ThemeModeNotifier', () {
    test('初期状態が ThemeMode.system である', () {
      final state = container.read(themeModeNotifierProvider);

      expect(state, ThemeMode.system);
    });

    test('system からトグルするとプラットフォームの逆になる', () {
      // Flutter テスト環境のデフォルトは Brightness.light → ThemeMode.dark
      container.read(themeModeNotifierProvider.notifier).toggle();

      expect(container.read(themeModeNotifierProvider), ThemeMode.dark);
    });

    test('dark から light にトグルする', () {
      final notifier = container.read(themeModeNotifierProvider.notifier)
        // system → dark
        ..toggle();
      expect(container.read(themeModeNotifierProvider), ThemeMode.dark);

      // dark → light
      notifier.toggle();
      expect(container.read(themeModeNotifierProvider), ThemeMode.light);
    });

    test('light から dark にトグルする', () {
      final notifier = container.read(themeModeNotifierProvider.notifier)
        // system → dark → light
        ..toggle()
        ..toggle();
      expect(container.read(themeModeNotifierProvider), ThemeMode.light);

      // light → dark
      notifier.toggle();
      expect(container.read(themeModeNotifierProvider), ThemeMode.dark);
    });
  });
}
