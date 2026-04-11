import 'package:flutter/material.dart';

import '../../../../app/theme.dart';
import '../../models/package_detail_response.dart';

/// パッケージの概要情報（説明文）を表示するセクション。
///
/// パブリッシャー情報はヒーローヘッダーに表示するためここでは省略。
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
      margin: cardTheme.margin.copyWith(top: 16, bottom: 0),
      child: Padding(
        padding: cardTheme.padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionHeader(label: 'Overview', icon: Icons.info_outline),
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

/// セクション共通ヘッダー（左ボーダーアクセント + ラベル）。
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.label,
    required this.icon,
  });

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Row(
      children: [
        Container(
          width: 3,
          height: 18,
          decoration: BoxDecoration(
            color: primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}
