import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../models/package_detail_response.dart';
import '../../models/package_publisher_response.dart';

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
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Overview',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const Gap(8),
          Text(detail.latest.pubspec.description),
          if (publisher.publisherId != null) ...[
            const Gap(12),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                publisher.publisherId!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
