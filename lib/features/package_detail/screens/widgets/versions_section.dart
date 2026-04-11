import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/design_system/design_system.dart';
import '../../models/package_detail_version.dart';
import 'section_header.dart';

/// パッケージのバージョン一覧を公開日の降順でタイムライン形式で表示するセクション。
class VersionsSection extends StatelessWidget {
  const VersionsSection({
    required this.versions,
    super.key,
  });

  final List<PackageDetailVersion> versions;

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
            const SectionHeader(label: 'Versions'),
            const Divider(height: 20),
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
                      margin: const EdgeInsets.symmetric(vertical: 2),
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
                      fontSize: 13,
                      fontWeight: isLatest ? FontWeight.w600 : FontWeight.w400,
                      color: isLatest
                          ? theme.colorScheme.onSurface
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (isLatest) ...[
                    const SizedBox(width: AppSpacing.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: primary),
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                      child: Text(
                        'LATEST',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 9,
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
                      fontSize: 12,
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
