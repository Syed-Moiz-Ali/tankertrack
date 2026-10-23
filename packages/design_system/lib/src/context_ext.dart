import 'package:flutter/material.dart';

import 'app_surface.dart';
import 'shadows.dart';
import 'status_colors.dart';
import 'tokens.dart';

/// The ONLY styling accessors feature code may use.
///
/// Every accessor resolves through [Theme.of] (or an inherited theme
/// extension) — no globals, no static colors — so theme switching,
/// dark mode and per-subtree overrides always work.
///
/// (Localization accessor `context.l10n` lives in `package:l10n` to keep
/// this package dependency-free.)
extension DesignContext on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get text => Theme.of(this).textTheme;
  StatusColors get status => Theme.of(this).extension<StatusColors>()!;
  AppTokens get tokens => Theme.of(this).extension<AppTokens>()!;
  AppShadows get shadows => Theme.of(this).extension<AppShadows>()!;

  bool get isRtl => Directionality.of(this) == TextDirection.rtl;

  /// Surface is encoded in the active theme's extensions: control-room
  /// themes carry widened gutters. Falls back to [AppSurface.web].
  AppSurface get surface {
    final t = tokens;
    if (t.gutterDesktop >= 48) return AppSurface.controlRoom;
    return AppSurface.web;
  }
}
