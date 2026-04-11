import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../models/package_detail_version.dart';

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

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
            'Versions',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const Gap(8),
          ...sorted.map(
            (v) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    v.version,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    _formatDate(v.published),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ],
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
