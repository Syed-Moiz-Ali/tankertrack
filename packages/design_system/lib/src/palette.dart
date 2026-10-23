import 'package:flutter/material.dart';

/// Single palette both themes are derived from (09 reference values).
///
/// Accent is the ONE CTA color (warm coral-red). Teal is the secondary
/// token. Status colors stay reserved for statuses.
class AppPalette {
  const AppPalette._();

  // Brand accent — the ONE strong CTA color. Never used for statuses.
  static const Color accent = Color(0xFFFF385C);
  static const Color accentDark = Color(0xFFFF6B8A);

  // Secondary token (kept from P0 teal for informational highlights).
  static const Color secondary = Color(0xFF0E7C7B);
  static const Color secondaryDark = Color(0xFF2DD4BF);

  // Neutrals (Airbnbogra: pure-white page, near-black ink).
  static const Color paper = Color(0xFFFFFFFF);
  static const Color paperElevated = Color(0xFFFFFFFF);
  static const Color ink = Color(0xFF222222);
  static const Color inkSecondary = Color(0xFF717171);
  static const Color inkTertiary = Color(0xFFB0B0B0);
  static const Color line = Color(0xFFDDDDDD);
  static const Color lineSoft = Color(0xFFEBEBEB);
  static const Color fillSubtle = Color(0xFFF7F7F7);

  // Dark surfaces.
  static const Color night = Color(0xFF0F1419);
  static const Color nightElevated = Color(0xFF161D24);
  static const Color nightLine = Color(0x26FFFFFF);
  static const Color nightInk = Color(0xFFF2F4F7);
  static const Color nightInkSecondary = Color(0xFFB0B0B0);

  // Grey ramp (text-on-fill pairs are AA-checked in theme_test).
  static const Color grey = Color(0xFF717171);

  /// Light [ColorScheme] derived from this palette.
  static ColorScheme get lightScheme => const ColorScheme(
        brightness: Brightness.light,
        primary: accent,
        onPrimary: Color(0xFFFFFFFF),
        primaryContainer: Color(0xFFFFE8EC),
        onPrimaryContainer: Color(0xFF680A22),
        secondary: secondary,
        onSecondary: Color(0xFFFFFFFF),
        secondaryContainer: Color(0xFFCCFBF1),
        onSecondaryContainer: Color(0xFF042F2E),
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
        outlineVariant: lineSoft,
        shadow: Color(0x1F000000),
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
        onPrimary: Color(0xFF4A0018),
        primaryContainer: Color(0xFF9E1B3C),
        onPrimaryContainer: Color(0xFFFFE8EC),
        secondary: secondaryDark,
        onSecondary: Color(0xFF042F2E),
        secondaryContainer: Color(0xFF0E7C7B),
        onSecondaryContainer: Color(0xFFCCFBF1),
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
