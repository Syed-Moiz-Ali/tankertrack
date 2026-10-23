import 'package:flutter/material.dart';

import 'app_surface.dart';
import 'palette.dart';
import 'status_colors.dart';
import 'tokens.dart';

/// Builds the three surface themes from the single [AppPalette].
///
/// Set once at the app root:
/// ```dart
/// MaterialApp.router(
///   theme: AppTheme.build(surface: AppSurface.web, brightness: Brightness.light, arabic: false),
///   darkTheme: AppTheme.build(surface: AppSurface.web, brightness: Brightness.dark, arabic: false),
///   themeMode: mode,
/// )
/// ```
/// Control room forces [AppSurface.controlRoom] with dark default.
/// Font files (`Inter`, `IBM Plex Sans Arabic`) are bundled by the apps
/// (P1 app shells); until then the family names fall back to system fonts
/// without breaking layout.
class AppTheme {
  const AppTheme._();

  static const String fontLatin = 'Inter';
  static const String fontArabic = 'IBM Plex Sans Arabic';

  /// Glyph fallback when the primary family lacks a codepoint.
  /// Always applied: EN screens show Arabic native names (العربية) and
  /// Arabic master-data names; without this they render as tofu.
  static const List<String> fallbackArabic = ['Noto Sans Arabic'];

  static ThemeData build({
    required AppSurface surface,
    required Brightness brightness,
    required bool arabic,
    Color? accentOverride,
  }) {
    var scheme =
        brightness == Brightness.light ? AppPalette.lightScheme : AppPalette.darkScheme;
    if (accentOverride != null) {
      scheme = scheme.copyWith(
        primary: accentOverride,
        surfaceTint: accentOverride,
      );
    }
    final status =
        brightness == Brightness.light ? StatusColors.light : StatusColors.dark;
    final tokens = surface == AppSurface.controlRoom
        ? AppTokens.base.copyWith(
            gutterMobile: 24, gutterTablet: 32, gutterDesktop: 48,
            iconMd: 26, iconLg: 34,
          )
        : AppTokens.base;
    final text = _textTheme(surface: surface, arabic: arabic, onScheme: scheme);
    final radius = tokens.radiusCard;
    final fieldRadius = tokens.radiusField;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      extensions: <ThemeExtension<dynamic>>[status, tokens],
      textTheme: text,
      scaffoldBackgroundColor: scheme.surfaceContainer,
      canvasColor: scheme.surface,
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: 1,
        space: tokens.spaceLg,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        titleTextStyle: text.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        elevation: tokens.elevationCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: BorderSide(color: scheme.outlineVariant),
        ),
        margin: EdgeInsets.all(tokens.spaceSm),
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
        minVerticalPadding: tokens.spaceSm,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        titleTextStyle: text.titleMedium,
        subtitleTextStyle: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          minimumSize: Size(
            0,
            surface == AppSurface.driver ? tokens.touchDriver : tokens.touchWeb,
          ),
          padding: EdgeInsets.symmetric(horizontal: tokens.spaceXl),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(fieldRadius),
          ),
          textStyle: text.labelLarge,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: Size(
            0,
            surface == AppSurface.driver ? tokens.touchDriver : tokens.touchWeb,
          ),
          padding: EdgeInsets.symmetric(horizontal: tokens.spaceXl),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(fieldRadius),
          ),
          textStyle: text.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.primary,
          minimumSize: Size(
            0,
            surface == AppSurface.driver ? tokens.touchDriver : tokens.touchWeb,
          ),
          padding: EdgeInsets.symmetric(horizontal: tokens.spaceXl),
          side: BorderSide(color: scheme.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(fieldRadius),
          ),
          textStyle: text.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          padding: EdgeInsets.symmetric(
            horizontal: tokens.spaceLg,
            vertical: tokens.spaceSm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(fieldRadius),
          ),
          textStyle: text.labelLarge,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: scheme.onSurfaceVariant,
          minimumSize: Size(
            surface == AppSurface.driver ? tokens.touchDriver : tokens.touchWeb,
            surface == AppSurface.driver ? tokens.touchDriver : tokens.touchWeb,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surface,
        contentPadding: EdgeInsets.symmetric(
          horizontal: tokens.spaceLg,
          vertical: tokens.spaceLg,
        ),
        hintStyle: text.bodyLarge?.copyWith(color: scheme.onSurfaceVariant),
        labelStyle: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(fieldRadius),
          borderSide: BorderSide(color: scheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(fieldRadius),
          borderSide: BorderSide(color: scheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(fieldRadius),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(fieldRadius),
          borderSide: BorderSide(color: scheme.error),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surfaceContainerHighest,
        labelStyle: text.labelMedium,
        secondaryLabelStyle: text.labelMedium,
        padding: EdgeInsets.symmetric(
          horizontal: tokens.spaceMd,
          vertical: tokens.spaceXs,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(tokens.radiusPill),
        ),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surface,
        elevation: tokens.elevationSheet,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(tokens.radiusSheet),
        ),
        titleTextStyle: text.headlineSmall,
        contentTextStyle: text.bodyLarge,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surface,
        elevation: tokens.elevationSheet,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(tokens.radiusSheet),
          ),
        ),
        showDragHandle: true,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        indicatorColor: scheme.primaryContainer,
        height: surface == AppSurface.driver ? 76 : 64,
        labelTextStyle: WidgetStatePropertyAll(text.labelMedium),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: scheme.surface,
        indicatorColor: scheme.primaryContainer,
        selectedLabelTextStyle: text.labelMedium,
        unselectedLabelTextStyle:
            text.labelMedium?.copyWith(color: scheme.onSurfaceVariant),
      ),
      dataTableTheme: DataTableThemeData(
        headingTextStyle: text.titleSmall,
        dataTextStyle: text.bodyMedium,
        headingRowColor: WidgetStatePropertyAll(scheme.surfaceContainerHighest),
        dividerThickness: 1,
        dataRowMinHeight: 56,
        dataRowMaxHeight: 56,
      ),
      tabBarTheme: TabBarThemeData(
        labelStyle: text.titleSmall,
        unselectedLabelStyle:
            text.titleSmall?.copyWith(color: scheme.onSurfaceVariant),
        labelColor: scheme.primary,
        unselectedLabelColor: scheme.onSurfaceVariant,
        indicatorColor: scheme.primary,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: scheme.inverseSurface,
        contentTextStyle:
            text.bodyMedium?.copyWith(color: scheme.onInverseSurface),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(tokens.radiusCard),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      tooltipTheme: TooltipThemeData(
        textStyle: text.bodySmall?.copyWith(color: scheme.onInverseSurface),
        decoration: BoxDecoration(
          color: scheme.inverseSurface,
          borderRadius: BorderRadius.circular(tokens.spaceSm),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return scheme.onPrimary;
          return null;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return scheme.primary;
          return null;
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return scheme.primary;
          return null;
        }),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(tokens.spaceXs),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        linearTrackColor: scheme.surfaceContainerHighest,
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStatePropertyAll(scheme.outline),
        thickness: const WidgetStatePropertyAll(6),
        radius: Radius.circular(tokens.spaceXs),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.linux: FadeForwardsPageTransitionsBuilder(),
        },
      ),
    );
  }

  /// Locale-aware type scale. Arabic gets ×1.12 line-height (min 1.6 body)
  /// per the RTL strategy; control room scales up for distance reading.
  static TextTheme _textTheme({
    required AppSurface surface,
    required bool arabic,
    required ColorScheme onScheme,
  }) {
    final family = arabic ? fontArabic : fontLatin;
    final scale = switch (surface) {
      AppSurface.driver => 1.06,
      AppSurface.web => 1.0,
      AppSurface.controlRoom => 1.3,
    };
    double fs(double v) => v * scale;
    double lh(double v) => arabic ? v * 1.12 : v;

    TextStyle s(double size, double height, FontWeight weight) => TextStyle(
          fontFamily: family,
          fontFamilyFallback: fallbackArabic,
          fontSize: size,
          height: height,
          fontWeight: weight,
          color: onScheme.onSurface,
          fontFeatures: const [FontFeature.tabularFigures()],
        );

    return TextTheme(
      displayLarge: s(fs(32), lh(1.25), FontWeight.w700),
      displayMedium: s(fs(28), lh(1.25), FontWeight.w700),
      displaySmall: s(fs(24), lh(1.3), FontWeight.w700),
      headlineLarge: s(fs(22), lh(1.27), FontWeight.w700),
      headlineMedium: s(fs(20), lh(1.3), FontWeight.w600),
      headlineSmall: s(fs(18), lh(1.33), FontWeight.w600),
      titleLarge: s(fs(18), lh(1.33), FontWeight.w600),
      titleMedium: s(fs(16), lh(1.4), FontWeight.w500),
      titleSmall: s(fs(14), lh(1.43), FontWeight.w500),
      bodyLarge: s(fs(surface == AppSurface.driver ? 16 : 15), arabic ? 1.6 : 1.47, FontWeight.w400),
      bodyMedium: s(fs(14), arabic ? 1.6 : 1.5, FontWeight.w400),
      bodySmall: s(fs(12), lh(1.33), FontWeight.w400),
      labelLarge: s(fs(surface == AppSurface.driver ? 16 : 14), lh(1.43), FontWeight.w600),
      labelMedium: s(fs(12), lh(1.33), FontWeight.w500),
      labelSmall: s(fs(11), lh(1.36), FontWeight.w500),
    );
  }
}
