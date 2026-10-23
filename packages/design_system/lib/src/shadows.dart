import 'package:flutter/material.dart';

/// Elevation language (09): cards rest flat (no shadow); search pills,
/// popovers and sticky cards float; cards lift on hover.
@immutable
class AppShadows extends ThemeExtension<AppShadows> {
  const AppShadows({required this.float, required this.hover});

  /// `0 6px 16px rgba(0,0,0,.12)` — search pill, popovers, sticky card.
  final BoxShadow float;

  /// Card hover lift.
  final BoxShadow hover;

  static const AppShadows light = AppShadows(
    float: BoxShadow(
      color: Color(0x1F000000),
      blurRadius: 16,
      offset: Offset(0, 6),
    ),
    hover: BoxShadow(
      color: Color(0x29000000),
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
  );

  static const AppShadows dark = AppShadows(
    float: BoxShadow(
      color: Color(0x66000000),
      blurRadius: 16,
      offset: Offset(0, 6),
    ),
    hover: BoxShadow(
      color: Color(0x80000000),
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
  );

  @override
  AppShadows copyWith({BoxShadow? float, BoxShadow? hover}) =>
      AppShadows(float: float ?? this.float, hover: hover ?? this.hover);

  @override
  AppShadows lerp(ThemeExtension<AppShadows>? other, double t) {
    if (other is! AppShadows) return this;
    return AppShadows(
      float: BoxShadow.lerp(float, other.float, t) ?? float,
      hover: BoxShadow.lerp(hover, other.hover, t) ?? hover,
    );
  }
}
