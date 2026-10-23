import 'package:flutter/material.dart';

/// Single palette both themes are derived from.
///
/// Change a value here and the whole product (driver app, back office,
/// control room, light/dark) updates. No other file in the repo may define
/// a product color.
class AppPalette {
  const AppPalette._();

  // Brand accent — the ONE strong color. Never used for statuses.
  static const Color accent = Color(0xFF0E7C7B);
  static const Color accentDark = Color(0xFF2DD4BF);

  // Neutrals (warm paper / cool ink — Airbnb warmth).
  static const Color paper = Color(0xFFFAFAF8);
  static const Color paperElevated = Color(0xFFFFFFFF);
  static const Color ink = Color(0xFF101828);
  static const Color inkSecondary = Color(0xFF475467);
  static const Color inkTertiary = Color(0xFF98A2B3);
  static const Color line = Color(0xFFE4E7EC);
  static const Color fillSubtle = Color(0xFFF2F4F7);

  // Dark surfaces.
  static const Color night = Color(0xFF0F1419);
  static const Color nightElevated = Color(0xFF161D24);
  static const Color nightLine = Color(0x26FFFFFF);
  static const Color nightInk = Color(0xFFF2F4F7);
  static const Color nightInkSecondary = Color(0xFF98A2B3);

  // Grey ramp (text-on-fill pairs are AA-checked in theme_test).
  static const Color grey = Color(0xFF6B7280);

  /// Light [ColorScheme] derived from this palette.
  static ColorScheme get lightScheme => const ColorScheme(
        brightness: Brightness.light,
        primary: accent,
        onPrimary: Color(0xFFFFFFFF),
        primaryContainer: Color(0xFFCCFBF1),
        onPrimaryContainer: Color(0xFF042F2E),
        secondary: Color(0xFF155E75),
        onSecondary: Color(0xFFFFFFFF),
        secondaryContainer: Color(0xFFE0F2FE),
        onSecondaryContainer: Color(0xFF082F49),
        tertiary: Color(0xFF6D28D9),
        onTertiary: Color(0xFFFFFFFF),
        error: Color(0xFFB42318),
        onError: Color(0xFFFFFFFF),
        errorContainer: Color(0xFFFEE4E2),
        onErrorContainer: Color(0xFF912018),
        surface: paperElevated,
        onSurface: ink,
        surfaceContainerHighest: fillSubtle,
        surfaceContainer: paper,
        onSurfaceVariant: inkSecondary,
        outline: line,
        outlineVariant: Color(0xFFEAECF0),
        shadow: Color(0x14000000),
        scrim: Color(0x52000000),
        inverseSurface: ink,
        onInverseSurface: Color(0xFFFFFFFF),
        inversePrimary: accentDark,
        surfaceTint: accent,
      );

  /// Dark [ColorScheme] derived from this palette.
  static ColorScheme get darkScheme => const ColorScheme(
        brightness: Brightness.dark,
        primary: accentDark,
        onPrimary: Color(0xFF042F2E),
        primaryContainer: Color(0xFF0E7C7B),
        onPrimaryContainer: Color(0xFFCCFBF1),
        secondary: Color(0xFF7DD3FC),
        onSecondary: Color(0xFF082F49),
        secondaryContainer: Color(0xFF155E75),
        onSecondaryContainer: Color(0xFFE0F2FE),
        tertiary: Color(0xFFC4B5FD),
        onTertiary: Color(0xFF2E1065),
        error: Color(0xFFF97066),
        onError: Color(0xFF3B0A06),
        errorContainer: Color(0xFF7A271A),
        onErrorContainer: Color(0xFFFEE4E2),
        surface: nightElevated,
        onSurface: nightInk,
        surfaceContainerHighest: Color(0xFF1F2937),
        surfaceContainer: night,
        onSurfaceVariant: nightInkSecondary,
        outline: nightLine,
        outlineVariant: Color(0x1FFFFFFF),
        shadow: Color(0x40000000),
        scrim: Color(0x99000000),
        inverseSurface: nightInk,
        onInverseSurface: ink,
        inversePrimary: accent,
        surfaceTint: accentDark,
      );
}
