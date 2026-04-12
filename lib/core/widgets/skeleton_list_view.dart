import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pubdev_viewer/core/design_system/design_system.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonListView extends StatelessWidget {
  const SkeletonListView({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Shimmer.fromColors(
      baseColor: tokens.skeletonBase,
      highlightColor: tokens.skeletonHighlight,
      child: ListView.builder(
        padding: const EdgeInsets.only(
          top: AppSpacing.sm,
          bottom: AppSpacing.lg,
        ),
        // 一般的な画面サイズでスクロール不要な程度に埋まる数。
        itemCount: 10,
        itemBuilder: (context, index) => const _SkeletonTile(),
      ),
    );
  }
}

class _SkeletonTile extends StatelessWidget {
  const _SkeletonTile();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xs,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.shimmerPlaceholder,
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.shimmerPlaceholder,
                borderRadius: BorderRadius.circular(AppRadius.avatar),
              ),
            ),
            const Gap(AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 14,
                          decoration: BoxDecoration(
                            color: AppColors.shimmerPlaceholder,
                            borderRadius: BorderRadius.circular(
                              AppRadius.skeleton,
                            ),
                          ),
                        ),
                      ),
                      const Gap(AppSpacing.sm),
                      Container(
                        width: 48,
                        height: 20,
                        decoration: BoxDecoration(
                          color: AppColors.shimmerPlaceholder,
                          borderRadius: BorderRadius.circular(AppRadius.full),
                        ),
                      ),
                    ],
                  ),
                  const Gap(AppSpacing.sm),
                  Container(
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppColors.shimmerPlaceholder,
                      borderRadius: BorderRadius.circular(AppRadius.skeleton),
                    ),
                  ),
                  const Gap(AppSpacing.xs),
                  Container(
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppColors.shimmerPlaceholder,
                      borderRadius: BorderRadius.circular(AppRadius.skeleton),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
