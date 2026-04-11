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

  String get _message {
    if (error is NetworkException) {
      return '通信エラーが発生しました。\nネットワーク接続を確認してください。';
    }
    if (error is ServerException) {
      return 'サーバーエラーが発生しました。\nしばらくしてから再試行してください。';
    }
    return '予期しないエラーが発生しました。';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const Gap(16),
            Text(
              _message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Gap(24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('再試行'),
            ),
          ],
        ),
      ),
    );
  }
}
