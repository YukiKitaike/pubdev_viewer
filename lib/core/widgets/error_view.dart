import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../error/app_exception.dart';

/// エラー発生時に表示する再利用可能な Widget。
///
/// エラー種別に応じたメッセージと再試行ボタンを表示する。
class ErrorView extends StatelessWidget {
  const ErrorView({
    required this.error,
    required this.onRetry,
    super.key,
  });

  final Object error;
  final VoidCallback onRetry;

  String get _title {
    if (error is NetworkException) {
      return '通信エラー';
    }
    if (error is ServerException) {
      return 'サーバーエラー';
    }
    return '予期しないエラー';
  }

  String get _message {
    if (error is NetworkException) {
      return 'ネットワーク接続を確認してから\n再試行してください。';
    }
    if (error is ServerException) {
      return 'しばらくしてから再試行してください。';
    }
    return '問題が解決しない場合はアプリを再起動してください。';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.cloud_off_rounded,
                size: 36,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const Gap(20),
            Text(
              _title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const Gap(8),
            Text(
              _message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.6,
              ),
            ),
            const Gap(28),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('再試行'),
            ),
          ],
        ),
      ),
    );
  }
}
