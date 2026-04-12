import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pubdev_viewer/core/design_system/design_system.dart';
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
    return Shimmer.fromColors(
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
    );
  }
}

class SkeletonTile extends StatelessWidget {
  const SkeletonTile({super.key});

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
                width: 44,
                height: 44,
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
                            height: 14,
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
                          width: 48,
                          height: 20,
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
                      height: 12,
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
                      height: 12,
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
