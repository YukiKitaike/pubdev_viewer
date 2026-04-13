import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pubdev_viewer/core/design_system/design_system.dart';
import 'package:pubdev_viewer/core/strings/app_strings.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonListView extends StatelessWidget {
  const SkeletonListView({
    super.key,
    this.itemBuilder,
    this.itemCount = 10,
    this.padding,
  });

  final Widget Function(BuildContext, int)? itemBuilder;

  /// 一般的な画面サイズでスクロール不要な程度に埋まるデフォルト値。
  final int itemCount;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    // スクリーンリーダーには「読み込み中のプレースホルダー」と 1 度だけ通知し、
    // 内部のスケルトン矩形が個別に読み上げられるノイズを抑制する。
    return Semantics(
      label: AppStrings.skeletonLoading,
      container: true,
      child: ExcludeSemantics(
        child: Shimmer.fromColors(
          baseColor: tokens.skeletonBase,
          highlightColor: tokens.skeletonHighlight,
          child: ListView.builder(
            padding:
                padding ??
                const EdgeInsets.only(
                  top: AppSpacing.sm,
                  bottom: AppSpacing.lg,
                ),
            itemCount: itemCount,
            itemBuilder: itemBuilder ?? (_, _) => const SkeletonTile(),
          ),
        ),
      ),
    );
  }
}

class SkeletonTile extends StatelessWidget {
  const SkeletonTile({super.key});

  static const _avatarSize = 44.0;
  static const _titleHeight = 14.0;
  static const _tagWidth = 48.0;
  static const _tagHeight = 20.0;
  static const _descriptionHeight = 12.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xs,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.shimmerPlaceholder,
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
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
                    color: AppColors.shimmerPlaceholder,
                    borderRadius: BorderRadius.circular(AppRadius.avatar),
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
                          child: SizedBox(
                            height: _titleHeight,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: AppColors.shimmerPlaceholder,
                                borderRadius: BorderRadius.circular(
                                  AppRadius.skeleton,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Gap(AppSpacing.sm),
                        SizedBox(
                          width: _tagWidth,
                          height: _tagHeight,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: AppColors.shimmerPlaceholder,
                              borderRadius: BorderRadius.circular(
                                AppRadius.full,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(AppSpacing.sm),
                    SizedBox(
                      height: _descriptionHeight,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.shimmerPlaceholder,
                          borderRadius: BorderRadius.circular(
                            AppRadius.skeleton,
                          ),
                        ),
                      ),
                    ),
                    const Gap(AppSpacing.xs),
                    SizedBox(
                      height: _descriptionHeight,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.shimmerPlaceholder,
                          borderRadius: BorderRadius.circular(
                            AppRadius.skeleton,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
