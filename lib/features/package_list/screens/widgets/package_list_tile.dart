import 'package:flutter/material.dart';

import '../../../../app/router.dart';
import '../../models/package_list_item.dart';

/// パッケージ一覧の各行をカード形式で表示する Widget。
class PackageListTile extends StatelessWidget {
  const PackageListTile({
    required this.package,
    super.key,
  });

  final PackageListItem package;

  static const List<Color> _avatarColors = [
    Color(0xFF1565C0),
    Color(0xFF6A1B9A),
    Color(0xFF00695C),
    Color(0xFFE65100),
    Color(0xFFC62828),
    Color(0xFF283593),
    Color(0xFF2E7D32),
    Color(0xFF4527A0),
  ];

  Color get _avatarColor {
    final hash = package.name.codeUnits.fold(0, (a, b) => a + b);
    return _avatarColors[hash % _avatarColors.length];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: InkWell(
          onTap: () => PackageDetailRoute(name: package.name).go(context),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: _avatarColor,
                  radius: 20,
                  child: Text(
                    package.name[0].toUpperCase(),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              package.name,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              'v${package.latest.version}',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        package.latest.pubspec.description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
