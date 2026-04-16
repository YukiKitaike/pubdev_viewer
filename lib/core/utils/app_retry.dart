import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Riverpod のリトライ戦略。
/// デフォルト（10 回・最大 6.4s）はモバイルではバッテリー消費・帯域浪費になるため
/// 3 回・最大 1.6s に制限。
Duration? appRetry(int retryCount, Object error) =>
    ProviderContainer.defaultRetry(
      retryCount,
      error,
      maxRetries: 3,
    );
