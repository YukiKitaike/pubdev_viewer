import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

/// Riverpod の状態変更とエラーを Logger 経由でデバッグ出力する ProviderObserver。
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
      '[UPDATE] ${context.provider.name ?? context.provider.runtimeType} '
      '| ${_summarize(previousValue)} \u2192 ${_summarize(newValue)}'
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
      '[FAIL] ${context.provider.name ?? context.provider.runtimeType} '
      '| $error',
      error,
      stackTrace,
    );
  }

  /// AsyncValue の中身をダンプせず型名だけ表示する。
  /// フル toString は数百文字になりデバッグコンソールが埋まるため。
  String _summarize(Object? value) {
    return switch (value) {
      AsyncData(:final value) => 'Data(${value.runtimeType})',
      AsyncLoading() => 'Loading',
      AsyncError(:final error) => 'Error($error)',
      null => 'null',
      _ => value.runtimeType.toString(),
    };
  }
}
