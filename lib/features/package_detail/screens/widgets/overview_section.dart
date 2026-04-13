import 'package:flutter/material.dart';

import 'package:pubdev_viewer/core/design_system/design_system.dart';
import 'package:pubdev_viewer/core/strings/app_strings.dart';
import 'package:pubdev_viewer/features/package_detail/models/package_detail_response.dart';
import 'package:pubdev_viewer/features/package_detail/screens/widgets/section_header.dart';

// パブリッシャー情報はヒーローヘッダーに表示するためここでは省略。
class OverviewSection extends StatelessWidget {
  const OverviewSection({
    required this.detail,
    super.key,
  });

  static const _dividerHeight = 20.0;
  static const _descriptionLineHeight = 1.6;

  final PackageDetailResponse detail;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardTheme =
        Theme.of(context).extension<AppCardTheme>() ?? defaultCardTheme;
    final description = detail.latest.pubspec.description;

    return Card(
      margin: cardTheme.margin.copyWith(top: AppSpacing.lg, bottom: 0),
      child: Padding(
        padding: cardTheme.padding,
        child: Column(
          crossAxisAlignment: .start,
          children: [
            const SectionHeader(label: AppStrings.sectionOverview),
            const Divider(height: _dividerHeight),
            Text(
              description,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: _descriptionLineHeight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
