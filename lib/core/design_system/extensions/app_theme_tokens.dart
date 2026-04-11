import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';

/// ライト・ダーク両テーマで使うセマンティックカラーを提供する [ThemeExtension]。
///
/// コンポーネント内での `isLight ? Color(0xFF...) : Color(0xFF...)` パターンを排除する。
///
/// 使用例:
/// ```dart
/// final tokens = Theme.of(context).extension<AppThemeTokens>()!;
/// color: tokens.surface,
/// ```
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

  /// セクション区切り・AppBar の下線ボーダー
  final Color border;

  /// カードの外枠ボーダー（ダークモードでは少し明るい）
  final Color cardBorder;

  final Color skeletonBase;
  final Color skeletonHighlight;

  /// ライトテーマ用トークンセット
  static const AppThemeTokens light = AppThemeTokens(
    background: AppColors.lightBackground,
    surface: AppColors.lightSurface,
    border: AppColors.lightBorder,
    cardBorder: AppColors.lightBorder,
    skeletonBase: AppColors.lightSkeletonBase,
    skeletonHighlight: AppColors.lightSkeletonHighlight,
  );

  /// ダークテーマ用トークンセット
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

/// [BuildContext] から [AppThemeTokens] を簡単に取得する拡張。
extension AppThemeTokensX on BuildContext {
  AppThemeTokens get tokens {
    return Theme.of(this).extension<AppThemeTokens>() ?? AppThemeTokens.light;
  }
}
