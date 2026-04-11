import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

import '../design_system/design_system.dart';
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

  String get _title => switch (error) {
    NetworkException() => '通信エラー',
    ServerException() => 'サーバーエラー',
    _ => '予期しないエラー',
  };

  String get _message => switch (error) {
    NetworkException() => 'ネットワーク接続を確認してから\n再試行してください。',
    ServerException() => 'しばらくしてから再試行してください。',
    _ => '問題が解決しない場合はアプリを再起動してください。',
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxxl),
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
            const Gap(AppSpacing.xl),
            Text(
              _title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const Gap(AppSpacing.sm),
            Text(
              _message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.6,
              ),
            ),
            const Gap(AppSpacing.xxl),
            FilledButton.icon(
              onPressed: () {
                HapticFeedback.lightImpact();
                onRetry();
              },
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('再試行'),
            ),
          ],
        ),
      ),
    );
  }
}
