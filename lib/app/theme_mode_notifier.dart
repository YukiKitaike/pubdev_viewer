import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_mode_notifier.g.dart';

/// アプリ全体のテーマモード（ライト/ダーク/システム）を保持する Notifier。
/// keepAlive: テーマ設定はアプリ全体で共有するため autoDispose しない。
@Riverpod(keepAlive: true)
class ThemeModeNotifier extends _$ThemeModeNotifier {
  @override
  ThemeMode build() => .system;

  void toggle() {
    state = switch (state) {
      .dark => .light,
      .light => .dark,
      // system モードの「今の明暗」は PlatformDispatcher で確認し、逆に切り替える。
      .system =>
        PlatformDispatcher.instance.platformBrightness == .dark
            ? .light
            : .dark,
    };
  }
}
