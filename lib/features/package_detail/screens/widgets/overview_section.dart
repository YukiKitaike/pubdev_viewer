import 'package:flutter/material.dart';

import '../../../../core/design_system/design_system.dart';
import '../../models/package_detail_response.dart';
import 'section_header.dart';

// パブリッシャー情報はヒーローヘッダーに表示するためここでは省略。
class OverviewSection extends StatelessWidget {
  const OverviewSection({
    required this.detail,
    super.key,
  });

  final PackageDetailResponse detail;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardTheme =
        Theme.of(context).extension<AppCardTheme>() ?? defaultCardTheme;

    return Card(
      margin: cardTheme.margin.copyWith(top: AppSpacing.lg, bottom: 0),
      child: Padding(
        padding: cardTheme.padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(label: 'Overview'),
            const Divider(height: 20),
            Text(
              detail.latest.pubspec.description,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}
