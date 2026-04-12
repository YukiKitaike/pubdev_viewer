import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_mode_notifier.g.dart';

/// アプリのテーマモード（ライト/ダーク/システム）を管理する Notifier。
@Riverpod(keepAlive: true)
class ThemeModeNotifier extends _$ThemeModeNotifier {
  @override
  ThemeMode build() => ThemeMode.system;

  /// ライト ↔ ダークをトグルする。
  /// システムモードのときは端末の実際のテーマの逆に切り替える。
  void toggle() {
    state = switch (state) {
      ThemeMode.dark => ThemeMode.light,
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.system =>
        PlatformDispatcher.instance.platformBrightness == Brightness.dark
            ? ThemeMode.light
            : ThemeMode.dark,
    };
  }
}
