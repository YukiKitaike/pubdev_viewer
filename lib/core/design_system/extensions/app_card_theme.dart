import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:pubdev_viewer/core/design_system/tokens/app_radius.dart';
import 'package:pubdev_viewer/core/design_system/tokens/app_spacing.dart';

class AppCardTheme extends ThemeExtension<AppCardTheme> {
  const AppCardTheme({
    required this.borderRadius,
    required this.padding,
    required this.margin,
  });

  final double borderRadius;
  final EdgeInsets padding;
  final EdgeInsets margin;

  @override
  AppCardTheme copyWith({
    double? borderRadius,
    EdgeInsets? padding,
    EdgeInsets? margin,
  }) {
    return AppCardTheme(
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
    );
  }

  @override
  AppCardTheme lerp(AppCardTheme? other, double t) {
    if (other == null) {
      return this;
    }
    return AppCardTheme(
      borderRadius:
          lerpDouble(borderRadius, other.borderRadius, t) ?? borderRadius,
      padding: EdgeInsets.lerp(padding, other.padding, t) ?? padding,
      margin: EdgeInsets.lerp(margin, other.margin, t) ?? margin,
    );
  }
}

/// デフォルトのカードテーマ。ThemeExtension が未設定の場合のフォールバック用。
const AppCardTheme defaultCardTheme = AppCardTheme(
  borderRadius: AppRadius.card,
  padding: EdgeInsets.all(AppSpacing.xl),
  margin: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
);
