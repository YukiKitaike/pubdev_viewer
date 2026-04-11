import 'package:flutter/material.dart';

import '../../../../app/theme.dart';
import '../../models/package_detail_response.dart';
import '../../models/package_publisher_response.dart';

/// パッケージの概要情報（説明文・パブリッシャー）を表示するセクション。
class OverviewSection extends StatelessWidget {
  const OverviewSection({
    required this.detail,
    required this.publisher,
    super.key,
  });

  final PackageDetailResponse detail;
  final PackagePublisherResponse publisher;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardTheme =
        Theme.of(context).extension<AppCardTheme>() ?? defaultCardTheme;

    return Card(
      margin: cardTheme.margin.copyWith(top: 16, bottom: 0),
      child: Padding(
        padding: cardTheme.padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  'Overview',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            Text(
              detail.latest.pubspec.description,
              style: theme.textTheme.bodyMedium,
            ),
            if (publisher.publisherId != null) ...[
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.verified_outlined,
                        size: 12,
                        color: theme.colorScheme.onSecondaryContainer,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        publisher.publisherId!,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSecondaryContainer,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
