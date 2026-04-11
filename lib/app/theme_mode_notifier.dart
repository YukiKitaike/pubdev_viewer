import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_mode_notifier.g.dart';

/// アプリのテーマモード（ライト/ダーク/システム）を管理する Notifier。
@Riverpod(keepAlive: true)
class ThemeModeNotifier extends _$ThemeModeNotifier {
  @override
  ThemeMode build() => ThemeMode.system;

  /// ライト ↔ ダークをトグルする。
  /// システムモードのときはダークに切り替える。
  void toggle() {
    state = switch (state) {
      ThemeMode.dark => ThemeMode.light,
      _ => ThemeMode.dark,
    };
  }
}
