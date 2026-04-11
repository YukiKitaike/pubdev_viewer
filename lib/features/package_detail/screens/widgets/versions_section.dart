import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme.dart';
import '../../models/package_detail_version.dart';

/// パッケージのバージョン一覧を公開日の降順で表示するセクション。
class VersionsSection extends StatelessWidget {
  const VersionsSection({
    required this.versions,
    super.key,
  });

  final List<PackageDetailVersion> versions;

  static final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  List<PackageDetailVersion> get _sortedVersions {
    return [...versions]..sort(
      (a, b) => b.published.compareTo(a.published),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sorted = _sortedVersions;
    final theme = Theme.of(context);
    final cardTheme =
        Theme.of(context).extension<AppCardTheme>() ?? defaultCardTheme;

    return Card(
      margin: cardTheme.margin.copyWith(top: 16),
      child: Padding(
        padding: cardTheme.padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.history,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  'Versions',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            ...sorted.asMap().entries.map((entry) {
              final isLatest = entry.key == 0;
              final v = entry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Text(
                      v.version,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                    if (isLatest) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          'LATEST',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 9,
                          ),
                        ),
                      ),
                    ],
                    const Spacer(),
                    Text(
                      _formatDate(v.published),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  String _formatDate(String published) {
    final date = DateTime.tryParse(published);
    if (date == null) {
      return published;
    }
    return _dateFormat.format(date);
  }
}
