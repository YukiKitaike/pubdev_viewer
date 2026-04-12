import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pubdev_viewer/app/theme.dart';

/// ウィジェットテスト用の共通ヘルパー。
///
/// [overrides] が空でない場合は [ProviderScope] でラップする。
/// テーマは [appLightTheme] をデフォルトとし、[theme] で上書き可能。
Widget createTestApp({
  required Widget home,
  List<Override> overrides = const [],
  ThemeData? theme,
}) {
  final app = MaterialApp(
    theme: theme ?? appLightTheme,
    home: home,
  );

  if (overrides.isEmpty) {
    return app;
  }

  return ProviderScope(overrides: overrides, child: app);
}
