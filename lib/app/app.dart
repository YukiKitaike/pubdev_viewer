import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pubdev_viewer/app/router.dart';
import 'package:pubdev_viewer/app/theme.dart';
import 'package:pubdev_viewer/app/theme_mode_notifier.dart';
import 'package:pubdev_viewer/core/strings/app_strings.dart';

class PubDevViewerApp extends ConsumerWidget {
  const PubDevViewerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeNotifierProvider);
    return MaterialApp.router(
      title: AppStrings.appTitle,
      theme: appLightTheme,
      darkTheme: appDarkTheme,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
