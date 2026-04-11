import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/router.dart';
import 'app/theme.dart';

void main() {
  runApp(const ProviderScope(child: PubDevViewerApp()));
}

class PubDevViewerApp extends StatelessWidget {
  const PubDevViewerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'pub.dev Viewer',
      theme: appTheme,
      routerConfig: router,
    );
  }
}
