import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:pubdev_viewer/app/router.dart';
import 'package:pubdev_viewer/core/design_system/design_system.dart';
import 'package:pubdev_viewer/core/strings/app_strings.dart';
import 'package:pubdev_viewer/core/utils/gradient_selector.dart';
import 'package:pubdev_viewer/core/utils/string_utils.dart';
import 'package:pubdev_viewer/features/package_list/models/package_list_item.dart';

class PackageListTile extends StatefulWidget {
  const PackageListTile({
    required this.package,
    super.key,
  });

  final PackageListItem package;

  @override
  State<PackageListTile> createState() => _PackageListTileState();
}

class _PackageListTileState extends State<PackageListTile> {
  static const _pressedScale = 0.97;
  // WHY: Material Design のマイクロインタラクション推奨値に準拠。
  static const _animationDuration = Duration(milliseconds: 150);
  static const _avatarSize = 44.0;
  static const _descriptionLineHeight = 1.5;
  static const _chevronIconSize = 16.0;
  static const _badgeBorderAlpha = 0.4;
  static const _chevronAlpha = 0.5;

  bool _pressed = false;
  late List<Color> _gradient;

  @override
  void initState() {
    super.initState();
    final name = widget.package.name;
    _gradient = selectGradientByName(name);
  }

  // ListView のリサイクルで別パッケージが割り当てられた場合にグラデーションを再計算する。
  @override
  void didUpdateWidget(PackageListTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldName = oldWidget.package.name;
    final newName = widget.package.name;
    if (oldName != newName) {
      _gradient = selectGradientByName(newName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = context.tokens;
    final package = widget.package;
    final name = package.name;
    final latest = package.latest;
    final version = latest.version;
    final description = latest.pubspec.description;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xs,
      ),
      child: AnimatedScale(
        scale: _pressed ? _pressedScale : 1.0,
        duration: _animationDuration,
        curve: Curves.easeOut,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: tokens.surface,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: tokens.cardBorder),
            boxShadow: cardElevatedShadow(
              theme.colorScheme.primary,
              isDark: theme.brightness == .dark,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.card),
            child: InkWell(
              borderRadius: BorderRadius.circular(AppRadius.card),
              onTap: () {
                // 画面遷移という重要な操作に触覚フィードバックで応答性を伝える。
                HapticFeedback.lightImpact();
                PackageDetailRoute(name: name).go(context);
              },
              onHighlightChanged: (highlighted) =>
                  setState(() => _pressed = highlighted),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  crossAxisAlignment: .start,
                  children: [
                    SizedBox(
                      width: _avatarSize,
                      height: _avatarSize,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: _gradient,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(AppRadius.avatar),
                        ),
                        child: Center(
                          child: Text(
                            firstGrapheme(name).toUpperCase(),
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: AppColors.avatarText,
                              fontWeight: .w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Gap(AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  name,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: .w600,
                                  ),
                                  maxLines: 1,
                                  overflow: .ellipsis,
                                ),
                              ),
                              const Gap(AppSpacing.sm),
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: theme.colorScheme.primary.withValues(
                                      alpha: _badgeBorderAlpha,
                                    ),
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.full,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.sm,
                                    vertical: AppSpacing.xxs,
                                  ),
                                  child: Text(
                                    AppStrings.versionLabel(version),
                                    style: GoogleFonts.jetBrainsMono(
                                      fontSize: AppTextSize.mono10,
                                      fontWeight: .w600,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Gap(AppSpacing.xs),
                          Text(
                            description,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              height: _descriptionLineHeight,
                            ),
                            maxLines: 2,
                            overflow: .ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const Gap(AppSpacing.sm),
                    Icon(
                      Icons.chevron_right,
                      size: _chevronIconSize,
                      color: theme.colorScheme.onSurfaceVariant.withValues(
                        alpha: _chevronAlpha,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
