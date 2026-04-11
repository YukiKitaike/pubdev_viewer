import 'package:flutter/material.dart';

import '../../../../core/design_system/design_system.dart';

/// パッケージ詳細画面の各セクション共通ヘッダー（左ボーダーアクセント + ラベル）。
class SectionHeader extends StatelessWidget {
  const SectionHeader({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Row(
      children: [
        Container(
          width: 3,
          height: 18,
          decoration: BoxDecoration(
            color: primary,
            borderRadius: BorderRadius.circular(AppRadius.sectionAccent),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          label,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}
