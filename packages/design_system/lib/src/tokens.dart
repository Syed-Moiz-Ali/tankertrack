import 'package:flutter/material.dart';

/// Spacing, radii, elevation, motion, sizes and breakpoints — the ONLY
/// numeric styling values in the product.
///
/// Accessed via `context.tokens`. Widgets must never use numeric literals
/// for [EdgeInsets], [BorderRadius], [SizedBox], icon sizes or durations.
@immutable
class AppTokens extends ThemeExtension<AppTokens> {
  const AppTokens({
    required this.spaceXs,
    required this.spaceSm,
    required this.spaceMd,
    required this.spaceLg,
    required this.spaceXl,
    required this.spaceXxl,
    required this.spaceXxxl,
    required this.radiusCard,
    required this.radiusSheet,
    required this.radiusPill,
    required this.radiusField,
    required this.elevationCard,
    required this.elevationRaised,
    required this.elevationSheet,
    required this.motionMicro,
    required this.motionStandard,
    required this.motionRotate,
    required this.curve,
    required this.iconSm,
    required this.iconMd,
    required this.iconLg,
    required this.touchDriver,
    required this.touchWeb,
    required this.maxContentWidth,
    required this.contentNarrow,
    required this.gutterMobile,
    required this.gutterTablet,
    required this.gutterDesktop,
    required this.breakpointMobile,
    required this.breakpointTablet,
    required this.breakpointDesktop,
  });

  // 8-pt grid.
  final double spaceXs; // 4
  final double spaceSm; // 8
  final double spaceMd; // 12
  final double spaceLg; // 16
  final double spaceXl; // 24
  final double spaceXxl; // 32
  final double spaceXxxl; // 48

  // Radii.
  final double radiusCard; // 12
  final double radiusSheet; // 16
  final double radiusPill; // 999
  final double radiusField; // 12

  // Elevations (soft shadows defined in CardTheme/DialogTheme).
  final double elevationCard; // 0 — bordered resting cards
  final double elevationRaised; // 1
  final double elevationSheet; // 2

  // Motion.
  final Duration motionMicro; // 150ms
  final Duration motionStandard; // 250ms
  final Duration motionRotate; // 20s control-room panel rotation
  final Curve curve; // easeOutCubic

  // Icons.
  final double iconSm;
  final double iconMd;
  final double iconLg;

  // Touch targets.
  final double touchDriver; // 56 glove-friendly
  final double touchWeb; // 48

  // Layout.
  final double maxContentWidth; // 1280
  final double contentNarrow; // 420 — auth cards, narrow forms
  final double gutterMobile; // 16
  final double gutterTablet; // 24
  final double gutterDesktop; // 32
  final double breakpointMobile; // 600
  final double breakpointTablet; // 1024
  final double breakpointDesktop; // 1280

  /// Base tokens shared by all surfaces; surface builders scale from these.
  static const AppTokens base = AppTokens(
    spaceXs: 4,
    spaceSm: 8,
    spaceMd: 12,
    spaceLg: 16,
    spaceXl: 24,
    spaceXxl: 32,
    spaceXxxl: 48,
    radiusCard: 12,
    radiusSheet: 16,
    radiusPill: 999,
    radiusField: 12,
    elevationCard: 0,
    elevationRaised: 1,
    elevationSheet: 3,
    motionMicro: Duration(milliseconds: 150),
    motionStandard: Duration(milliseconds: 250),
    motionRotate: Duration(seconds: 20),
    curve: Curves.easeOutCubic,
    iconSm: 18,
    iconMd: 22,
    iconLg: 28,
    touchDriver: 56,
    touchWeb: 48,
    maxContentWidth: 1280,
    contentNarrow: 420,
    gutterMobile: 16,
    gutterTablet: 24,
    gutterDesktop: 32,
    breakpointMobile: 600,
    breakpointTablet: 1024,
    breakpointDesktop: 1280,
  );

  @override
  AppTokens copyWith({
    double? spaceXs,
    double? spaceSm,
    double? spaceMd,
    double? spaceLg,
    double? spaceXl,
    double? spaceXxl,
    double? spaceXxxl,
    double? radiusCard,
    double? radiusSheet,
    double? radiusPill,
    double? radiusField,
    double? elevationCard,
    double? elevationRaised,
    double? elevationSheet,
    Duration? motionMicro,
    Duration? motionStandard,
    Duration? motionRotate,
    Curve? curve,
    double? iconSm,
    double? iconMd,
    double? iconLg,
    double? touchDriver,
    double? touchWeb,
    double? maxContentWidth,
    double? contentNarrow,
    double? gutterMobile,
    double? gutterTablet,
    double? gutterDesktop,
    double? breakpointMobile,
    double? breakpointTablet,
    double? breakpointDesktop,
  }) {
    return AppTokens(
      spaceXs: spaceXs ?? this.spaceXs,
      spaceSm: spaceSm ?? this.spaceSm,
      spaceMd: spaceMd ?? this.spaceMd,
      spaceLg: spaceLg ?? this.spaceLg,
      spaceXl: spaceXl ?? this.spaceXl,
      spaceXxl: spaceXxl ?? this.spaceXxl,
      spaceXxxl: spaceXxxl ?? this.spaceXxxl,
      radiusCard: radiusCard ?? this.radiusCard,
      radiusSheet: radiusSheet ?? this.radiusSheet,
      radiusPill: radiusPill ?? this.radiusPill,
      radiusField: radiusField ?? this.radiusField,
      elevationCard: elevationCard ?? this.elevationCard,
      elevationRaised: elevationRaised ?? this.elevationRaised,
      elevationSheet: elevationSheet ?? this.elevationSheet,
      motionMicro: motionMicro ?? this.motionMicro,
      motionStandard: motionStandard ?? this.motionStandard,
      motionRotate: motionRotate ?? this.motionRotate,
      curve: curve ?? this.curve,
      iconSm: iconSm ?? this.iconSm,
      iconMd: iconMd ?? this.iconMd,
      iconLg: iconLg ?? this.iconLg,
      touchDriver: touchDriver ?? this.touchDriver,
      touchWeb: touchWeb ?? this.touchWeb,
      maxContentWidth: maxContentWidth ?? this.maxContentWidth,
      contentNarrow: contentNarrow ?? this.contentNarrow,
      gutterMobile: gutterMobile ?? this.gutterMobile,
      gutterTablet: gutterTablet ?? this.gutterTablet,
      gutterDesktop: gutterDesktop ?? this.gutterDesktop,
      breakpointMobile: breakpointMobile ?? this.breakpointMobile,
      breakpointTablet: breakpointTablet ?? this.breakpointTablet,
      breakpointDesktop: breakpointDesktop ?? this.breakpointDesktop,
    );
  }

  @override
  AppTokens lerp(ThemeExtension<AppTokens>? other, double t) {
    if (other is! AppTokens) return this;
    double l(double a, double b) => a + (b - a) * t;
    return AppTokens(
      spaceXs: l(spaceXs, other.spaceXs),
      spaceSm: l(spaceSm, other.spaceSm),
      spaceMd: l(spaceMd, other.spaceMd),
      spaceLg: l(spaceLg, other.spaceLg),
      spaceXl: l(spaceXl, other.spaceXl),
      spaceXxl: l(spaceXxl, other.spaceXxl),
      spaceXxxl: l(spaceXxxl, other.spaceXxxl),
      radiusCard: l(radiusCard, other.radiusCard),
      radiusSheet: l(radiusSheet, other.radiusSheet),
      radiusPill: l(radiusPill, other.radiusPill),
      radiusField: l(radiusField, other.radiusField),
      elevationCard: l(elevationCard, other.elevationCard),
      elevationRaised: l(elevationRaised, other.elevationRaised),
      elevationSheet: l(elevationSheet, other.elevationSheet),
      motionMicro: t < 0.5 ? motionMicro : other.motionMicro,
      motionStandard: t < 0.5 ? motionStandard : other.motionStandard,
      motionRotate: t < 0.5 ? motionRotate : other.motionRotate,
      curve: t < 0.5 ? curve : other.curve,
      iconSm: l(iconSm, other.iconSm),
      iconMd: l(iconMd, other.iconMd),
      iconLg: l(iconLg, other.iconLg),
      touchDriver: l(touchDriver, other.touchDriver),
      touchWeb: l(touchWeb, other.touchWeb),
      maxContentWidth: l(maxContentWidth, other.maxContentWidth),
      contentNarrow: l(contentNarrow, other.contentNarrow),
      gutterMobile: l(gutterMobile, other.gutterMobile),
      gutterTablet: l(gutterTablet, other.gutterTablet),
      gutterDesktop: l(gutterDesktop, other.gutterDesktop),
      breakpointMobile: l(breakpointMobile, other.breakpointMobile),
      breakpointTablet: l(breakpointTablet, other.breakpointTablet),
      breakpointDesktop: l(breakpointDesktop, other.breakpointDesktop),
    );
  }
}
