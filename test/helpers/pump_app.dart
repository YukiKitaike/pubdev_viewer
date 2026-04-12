import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pubdev_viewer/app/theme.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart' show Override;

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

  // Riverpod v3 の自動リトライを無効化。エラー系テストが安定しなくなるため。
  return ProviderScope(
    retry: (_, _) => null,
    overrides: overrides,
    child: app,
  );
}
