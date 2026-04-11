import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/design_system/design_system.dart';

export '../core/design_system/extensions/app_card_theme.dart'
    show AppCardTheme, defaultCardTheme;

/// ライトテーマ。
final ThemeData appLightTheme = _buildTheme(Brightness.light);

/// ダークテーマ。
final ThemeData appDarkTheme = _buildTheme(Brightness.dark);

ThemeData _buildTheme(Brightness brightness) {
  final isLight = brightness == Brightness.light;
  final colorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.pubBlue,
    brightness: brightness,
  );
  final baseTextTheme = isLight
      ? GoogleFonts.notoSansJpTextTheme()
      : GoogleFonts.notoSansJpTextTheme(ThemeData.dark().textTheme);
  final tokens = isLight ? AppThemeTokens.light : AppThemeTokens.dark;

  return ThemeData(
    colorScheme: colorScheme,
    textTheme: baseTextTheme,
    useMaterial3: true,
    scaffoldBackgroundColor: tokens.background,
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card),
        side: BorderSide(color: tokens.border),
      ),
      color: tokens.surface,
      shadowColor: isLight
          ? AppColors.pubBlue.withValues(alpha: 0.07)
          : Colors.transparent,
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
    ),
    appBarTheme: AppBarTheme(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 3,
      backgroundColor: tokens.background,
      foregroundColor: colorScheme.onSurface,
      titleTextStyle: GoogleFonts.notoSansJp(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: colorScheme.onSurface,
      ),
      surfaceTintColor: Colors.transparent,
    ),
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
        ),
      ),
    ),
    chipTheme: ChipThemeData(
      labelStyle: baseTextTheme.labelSmall,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm - 2),
    ),
    dividerTheme: DividerThemeData(
      color: tokens.border,
      thickness: 1,
    ),
    extensions: [defaultCardTheme, tokens],
  );
}
