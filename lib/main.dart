import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marionette_flutter/marionette_flutter.dart';
import 'package:marionette_logging/marionette_logging.dart';

import 'package:pubdev_viewer/app/app.dart';
import 'package:pubdev_viewer/core/utils/app_log_formatter.dart';
import 'package:pubdev_viewer/core/utils/app_retry.dart';
import 'package:pubdev_viewer/core/utils/provider_logger.dart';

void main() {
  if (kDebugMode) {
    MarionetteBinding.ensureInitialized(
      MarionetteConfiguration(logCollector: LoggingLogCollector()),
    );
  } else {
    WidgetsFlutterBinding.ensureInitialized();
  }
  setupLogging();
  runApp(
    ProviderScope(
      retry: appRetry,
      observers: [ProviderLogger()],
      child: const PubDevViewerApp(),
    ),
  );
}
