import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:pubdev_viewer/core/design_system/design_system.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({required this.label, super.key});

  final String label;

  static const double _accentWidth = 3;
  static const double _accentHeight = 18;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Row(
      children: [
        Container(
          width: _accentWidth,
          height: _accentHeight,
          decoration: BoxDecoration(
            color: primary,
            borderRadius: BorderRadius.circular(AppRadius.sectionAccent),
          ),
        ),
        const Gap(AppSpacing.sm),
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
