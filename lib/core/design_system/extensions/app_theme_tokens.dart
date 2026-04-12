import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';

// コンポーネント内での `isLight ? Color(0xFF...) : Color(0xFF...)` パターンを排除する。
class AppThemeTokens extends ThemeExtension<AppThemeTokens> {
  const AppThemeTokens({
    required this.background,
    required this.surface,
    required this.border,
    required this.cardBorder,
    required this.skeletonBase,
    required this.skeletonHighlight,
  });

  final Color background;
  final Color surface;

  // 区切り線用。ダークモードでは cardBorder より暗くし、カードと区別する。
  final Color border;

  // カード外枠用。ダークモードでは border より少し明るくし輪郭を視認しやすくする。
  final Color cardBorder;

  final Color skeletonBase;
  final Color skeletonHighlight;

  static const AppThemeTokens light = AppThemeTokens(
    background: AppColors.lightBackground,
    surface: AppColors.lightSurface,
    border: AppColors.lightBorder,
    cardBorder: AppColors.lightBorder,
    skeletonBase: AppColors.lightSkeletonBase,
    skeletonHighlight: AppColors.lightSkeletonHighlight,
  );

  static const AppThemeTokens dark = AppThemeTokens(
    background: AppColors.darkBackground,
    surface: AppColors.darkSurface,
    border: AppColors.darkBorder,
    cardBorder: AppColors.darkBorderCard,
    skeletonBase: AppColors.darkSkeletonBase,
    skeletonHighlight: AppColors.darkSkeletonHighlight,
  );

  @override
  AppThemeTokens copyWith({
    Color? background,
    Color? surface,
    Color? border,
    Color? cardBorder,
    Color? skeletonBase,
    Color? skeletonHighlight,
  }) {
    return AppThemeTokens(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      border: border ?? this.border,
      cardBorder: cardBorder ?? this.cardBorder,
      skeletonBase: skeletonBase ?? this.skeletonBase,
      skeletonHighlight: skeletonHighlight ?? this.skeletonHighlight,
    );
  }

  @override
  AppThemeTokens lerp(AppThemeTokens? other, double t) {
    if (other == null) {
      return this;
    }
    return AppThemeTokens(
      background: Color.lerp(background, other.background, t) ?? background,
      surface: Color.lerp(surface, other.surface, t) ?? surface,
      border: Color.lerp(border, other.border, t) ?? border,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t) ?? cardBorder,
      skeletonBase:
          Color.lerp(skeletonBase, other.skeletonBase, t) ?? skeletonBase,
      skeletonHighlight:
          Color.lerp(skeletonHighlight, other.skeletonHighlight, t) ??
          skeletonHighlight,
    );
  }
}

extension AppThemeTokensX on BuildContext {
  AppThemeTokens get tokens {
    return Theme.of(this).extension<AppThemeTokens>() ?? AppThemeTokens.light;
  }
}
