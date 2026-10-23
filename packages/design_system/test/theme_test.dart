import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppTheme', () {
    for (final surface in AppSurface.values) {
      for (final brightness in Brightness.values) {
        test(
          '$surface/$brightness builds with palette + extensions',
          () {
            for (final arabic in [false, true]) {
              final theme = AppTheme.build(
                surface: surface,
                brightness: brightness,
                arabic: arabic,
              );
              expect(theme.brightness, brightness);
              expect(theme.useMaterial3, isTrue);
              // Single-palette derivation.
              if (brightness == Brightness.light) {
                expect(theme.colorScheme.primary, AppPalette.accent);
              } else {
                expect(theme.colorScheme.primary, AppPalette.accentDark);
              }
              // Extensions present.
              expect(
                theme.extension<StatusColors>(),
                brightness == Brightness.light
                    ? StatusColors.light
                    : StatusColors.dark,
              );
              expect(theme.extension<AppTokens>(), isNotNull);
              // Arabic line-height rule (body ≥ 1.6 effective via 1.12x).
              final body = theme.textTheme.bodyMedium!;
              expect(body.height, arabic ? greaterThan(1.55) : lessThan(1.55));
              expect(body.fontFamily,
                  arabic ? AppTheme.fontArabic : AppTheme.fontLatin);
            }
          },
        );
      }
    }

    test('controlRoom type scale exceeds web (distance reading)', () {
      const arabic = false;
      final web = AppTheme.build(
        surface: AppSurface.web,
        brightness: Brightness.dark,
        arabic: arabic,
      );
      final cr = AppTheme.build(
        surface: AppSurface.controlRoom,
        brightness: Brightness.dark,
        arabic: arabic,
      );
      expect(
        cr.textTheme.displayLarge!.fontSize,
        greaterThan(web.textTheme.displayLarge!.fontSize!),
      );
    });

    test('component themes all installed', () {
      final theme = AppTheme.build(
        surface: AppSurface.web,
        brightness: Brightness.light,
        arabic: false,
      );
      expect(theme.elevatedButtonTheme.style, isNotNull);
      expect(theme.outlinedButtonTheme.style, isNotNull);
      expect(theme.textButtonTheme.style, isNotNull);
      expect(theme.filledButtonTheme.style, isNotNull);
      expect(theme.inputDecorationTheme.border, isNotNull);
      expect(theme.cardTheme.shape, isNotNull);
      expect(theme.chipTheme.shape, isNotNull);
      expect(theme.dialogTheme.shape, isNotNull);
      expect(theme.bottomSheetTheme.showDragHandle, isTrue);
      expect(theme.appBarTheme.elevation, 0);
      expect(theme.navigationBarTheme.backgroundColor, isNotNull);
      expect(theme.navigationRailTheme.backgroundColor, isNotNull);
      expect(theme.dataTableTheme.dataRowMinHeight, 56);
      expect(theme.tabBarTheme.indicatorColor, isNotNull);
      expect(theme.snackBarTheme.behavior, SnackBarBehavior.floating);
      expect(theme.tooltipTheme.textStyle, isNotNull);
      expect(theme.switchTheme.trackColor, isNotNull);
      expect(theme.checkboxTheme.shape, isNotNull);
      expect(theme.progressIndicatorTheme.color, isNotNull);
      expect(theme.dividerTheme.thickness, 1);
      expect(theme.listTileTheme.shape, isNotNull);
      expect(theme.scrollbarTheme.thickness, isNotNull);
    });
  });
}
