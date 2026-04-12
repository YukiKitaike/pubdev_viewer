@Tags(['unit'])
library;

import 'package:checks/checks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pubdev_viewer/app/theme_mode_notifier.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer.test();
  });

  group('ThemeModeNotifier', () {
    test('初期状態が ThemeMode.system である', () {
      final state = container.read(themeModeProvider);

      check(state).equals(ThemeMode.system);
    });

    test('system からトグルするとプラットフォームの逆になる', () {
      // Flutter テスト環境のデフォルトは Brightness.light → ThemeMode.dark
      container.read(themeModeProvider.notifier).toggle();

      check(container.read(themeModeProvider)).equals(ThemeMode.dark);
    });

    test('dark から light にトグルする', () {
      final notifier = container.read(themeModeProvider.notifier)
        // system → dark
        ..toggle();
      check(container.read(themeModeProvider)).equals(ThemeMode.dark);

      // dark → light
      notifier.toggle();
      check(container.read(themeModeProvider)).equals(ThemeMode.light);
    });

    test('light から dark にトグルする', () {
      final notifier = container.read(themeModeProvider.notifier)
        // system → dark → light
        ..toggle()
        ..toggle();
      check(container.read(themeModeProvider)).equals(ThemeMode.light);

      // light → dark
      notifier.toggle();
      check(container.read(themeModeProvider)).equals(ThemeMode.dark);
    });
  });
}
