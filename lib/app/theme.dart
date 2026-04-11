import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// アプリ共通のカードセクション装飾を定義する [ThemeExtension]。
///
/// カード風セクションで統一的なスタイルを適用するために使用する。
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
  borderRadius: 12,
  padding: EdgeInsets.all(16),
  margin: EdgeInsets.symmetric(horizontal: 16),
);

/// ライトテーマ。
final ThemeData appLightTheme = _buildTheme(Brightness.light);

/// ダークテーマ。
final ThemeData appDarkTheme = _buildTheme(Brightness.dark);

ThemeData _buildTheme(Brightness brightness) {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF0175C2),
    brightness: brightness,
  );
  final baseTextTheme = brightness == Brightness.light
      ? GoogleFonts.notoSansJpTextTheme()
      : GoogleFonts.notoSansJpTextTheme(ThemeData.dark().textTheme);

  return ThemeData(
    colorScheme: colorScheme,
    textTheme: baseTextTheme,
    useMaterial3: true,
    cardTheme: CardThemeData(
      elevation: 1,
      surfaceTintColor: colorScheme.surfaceTint,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
    ),
    appBarTheme: AppBarTheme(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 2,
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
    ),
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 16),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    chipTheme: ChipThemeData(
      labelStyle: baseTextTheme.labelSmall,
      padding: const EdgeInsets.symmetric(horizontal: 6),
    ),
    extensions: const [defaultCardTheme],
  );
}
