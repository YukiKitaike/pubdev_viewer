import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

import 'package:pubdev_viewer/core/design_system/design_system.dart';
import 'package:pubdev_viewer/core/error/app_exception.dart';
import 'package:pubdev_viewer/core/strings/app_strings.dart';

/// AppException の種別に応じてエラータイトル・メッセージとリトライボタンを表示する共通ウィジェット。
class ErrorView extends StatelessWidget {
  const ErrorView({
    required this.error,
    required this.onRetry,
    super.key,
  });

  static const _iconContainerSize = 80.0;
  static const _errorIconSize = 36.0;
  static const _retryIconSize = 18.0;
  static const _messageLineHeight = 1.6;

  final Object error;
  final VoidCallback onRetry;

  String get _title => switch (error) {
    NetworkException() => AppStrings.networkErrorTitle,
    ServerException() => AppStrings.serverErrorTitle,
    _ => AppStrings.unexpectedErrorTitle,
  };

  String get _message => switch (error) {
    NetworkException() => AppStrings.networkErrorMessage,
    ServerException() => AppStrings.serverErrorMessage,
    _ => AppStrings.unexpectedErrorMessage,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxxl),
        child: Column(
          mainAxisSize: .min,
          children: [
            SizedBox(
              width: _iconContainerSize,
              height: _iconContainerSize,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  shape: .circle,
                ),
                child: Icon(
                  Icons.cloud_off_rounded,
                  size: _errorIconSize,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const Gap(AppSpacing.xl),
            Text(
              _title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: .w700,
              ),
            ),
            const Gap(AppSpacing.sm),
            Text(
              _message,
              textAlign: .center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: _messageLineHeight,
              ),
            ),
            const Gap(AppSpacing.xxl),
            FilledButton.icon(
              onPressed: () {
                HapticFeedback.lightImpact();
                onRetry();
              },
              icon: const Icon(Icons.refresh, size: _retryIconSize),
              label: const Text(AppStrings.retry),
            ),
          ],
        ),
      ),
    );
  }
}
