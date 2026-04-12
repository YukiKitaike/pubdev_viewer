import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_mode_notifier.g.dart';

// keepAlive: テーマ設定はアプリ全体で共有するため autoDispose しない。
@Riverpod(keepAlive: true)
class ThemeModeNotifier extends _$ThemeModeNotifier {
  @override
  ThemeMode build() => ThemeMode.system;

  void toggle() {
    state = switch (state) {
      ThemeMode.dark => ThemeMode.light,
      ThemeMode.light => ThemeMode.dark,
      // system モードの「今の明暗」は PlatformDispatcher で確認し、逆に切り替える。
      ThemeMode.system =>
        PlatformDispatcher.instance.platformBrightness == Brightness.dark
            ? ThemeMode.light
            : ThemeMode.dark,
    };
  }
}
