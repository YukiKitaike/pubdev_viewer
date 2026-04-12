import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

final class ProviderLogger extends ProviderObserver {
  ProviderLogger() : _logger = Logger('Riverpod');

  final Logger _logger;

  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    _logger.info(
      '[UPDATE] ${context.provider} '
      '| prev: $previousValue '
      '| new: $newValue'
      '${context.mutation != null ? ' | mutation: ${context.mutation}' : ''}',
    );
  }

  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    _logger.severe(
      '[FAIL] ${context.provider} | error: $error',
      error,
      stackTrace,
    );
  }
}
