import 'package:flutter_riverpod/flutter_riverpod.dart';

// Riverpod デフォルトは 10 回・最大 6.4s だが、モバイルでは過度なリトライは
// バッテリー消費・帯域浪費になるため 3 回・最大 1.6s に制限。
Duration? appRetry(int retryCount, Object error) =>
    ProviderContainer.defaultRetry(
      retryCount,
      error,
      maxRetries: 3,
    );
