import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pubdev_viewer/core/design_system/design_system.dart';

final ThemeData appLightTheme = _buildTheme(Brightness.light);
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
      // ダークモードではシャドウが目立たないため transparent にし、ボーダーで区別する。
      shadowColor: isLight
          ? AppColors.pubBlue.withValues(alpha: 0.07)
          : Colors.transparent,
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
    ),
    appBarTheme: AppBarTheme(
      centerTitle: false,
      elevation: 0,
      // スクロール時のみ微細な影を付けて AppBar とコンテンツの境界を示す。
      scrolledUnderElevation: 3,
      backgroundColor: tokens.background,
      foregroundColor: colorScheme.onSurface,
      titleTextStyle: GoogleFonts.notoSansJp(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: colorScheme.onSurface,
      ),
      // M3 デフォルトの surfaceTint（スクロール時に紫がかる挙動）を無効化。
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
      padding: const EdgeInsets.symmetric(horizontal: 6),
    ),
    dividerTheme: DividerThemeData(
      color: tokens.border,
      thickness: 1,
    ),
    extensions: [defaultCardTheme, tokens],
  );
}
