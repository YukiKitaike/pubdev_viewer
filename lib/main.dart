import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

import 'app/router.dart';
import 'app/theme.dart';
import 'app/theme_mode_notifier.dart';

void main() {
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.loggerName}: ${record.message}');
  });
  runApp(const ProviderScope(child: PubDevViewerApp()));
}

class PubDevViewerApp extends ConsumerWidget {
  const PubDevViewerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeNotifierProvider);
    return MaterialApp.router(
      title: 'pub.dev Viewer',
      theme: appLightTheme,
      darkTheme: appDarkTheme,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
