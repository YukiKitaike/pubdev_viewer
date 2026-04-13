import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:pubdev_viewer/core/design_system/design_system.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({required this.label, super.key});

  final String label;

  static const double _accentWidth = 3;
  static const double _accentHeight = 18;
  static const _letterSpacing = 0.2;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Row(
      children: [
        // アクセントバーは純粋な視覚装飾のためスクリーンリーダーから除外する。
        ExcludeSemantics(
          child: SizedBox(
            width: _accentWidth,
            height: _accentHeight,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.circular(AppRadius.sectionAccent),
              ),
            ),
          ),
        ),
        const Gap(AppSpacing.sm),
        Semantics(
          header: true,
          child: Text(
            label,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: .w700,
              letterSpacing: _letterSpacing,
            ),
          ),
        ),
      ],
    );
  }
}
