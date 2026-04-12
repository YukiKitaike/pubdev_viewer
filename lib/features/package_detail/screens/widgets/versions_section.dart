import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:pubdev_viewer/core/design_system/design_system.dart';
import 'package:pubdev_viewer/core/strings/app_strings.dart';
import 'package:pubdev_viewer/features/package_detail/models/package_detail_version.dart';
import 'package:pubdev_viewer/features/package_detail/screens/widgets/section_header.dart';

class VersionsSection extends StatelessWidget {
  const VersionsSection({
    required this.versions,
    super.key,
  });

  final List<PackageDetailVersion> versions;

  // DateFormat の生成コストを避けるため static で再利用する。
  static final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    final cardTheme =
        Theme.of(context).extension<AppCardTheme>() ?? defaultCardTheme;

    return Card(
      margin: cardTheme.margin.copyWith(top: AppSpacing.lg),
      child: Padding(
        padding: cardTheme.padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(label: AppStrings.sectionVersions),
            const Divider(height: 20),
            // .indexed で index を取得。先頭の LATEST 判定と末尾の線描画制御に必要。
            ...versions.indexed.map((entry) {
              final (index, v) = entry;
              return _VersionTimelineItem(
                version: v,
                isLatest: index == 0,
                isLast: index == versions.length - 1,
                dateFormat: _dateFormat,
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _VersionTimelineItem extends StatelessWidget {
  const _VersionTimelineItem({
    required this.version,
    required this.isLatest,
    required this.isLast,
    required this.dateFormat,
  });

  final PackageDetailVersion version;
  final bool isLatest;
  final bool isLast;
  final DateFormat dateFormat;

  String _formatDate(DateTime published) => dateFormat.format(published);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final lineColor = context.tokens.cardBorder;

    // IntrinsicHeight でタイムラインの縦線を隣のコンテンツ高さに合わせる。
    // stretch だけでは子の高さが決まらない。
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // タイムラインのドット & ライン
          SizedBox(
            width: 20,
            child: Column(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(top: 5),
                  decoration: BoxDecoration(
                    color: isLatest ? primary : lineColor,
                    shape: BoxShape.circle,
                    border: isLatest ? null : Border.all(color: lineColor),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1,
                      color: lineColor,
                      margin: const EdgeInsets.symmetric(
                        vertical: AppSpacing.xxs,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const Gap(AppSpacing.sm),
          // バージョン情報
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.md),
              child: Row(
                children: [
                  Text(
                    version.version,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: AppTextSize.mono12,
                      fontWeight: isLatest ? FontWeight.w600 : FontWeight.w400,
                      color: isLatest
                          ? theme.colorScheme.onSurface
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (isLatest) ...[
                    const Gap(AppSpacing.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xxs,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: primary),
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                      child: Text(
                        AppStrings.latestBadge,
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: AppTextSize.mono10,
                          fontWeight: FontWeight.w700,
                          color: primary,
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
                  Text(
                    _formatDate(version.published),
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: AppTextSize.mono12,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
