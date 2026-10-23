import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../status_colors.dart';

/// Theme-mapped SVG illustration (docs/plan/10-illustration-style.md).
///
/// Asset files contain ONLY placeholder fills (`#TT_ACCENT`,
/// `#TT_N100..700`, …). This loader string-replaces them with the active
/// Theme's colors at load time — no ColorFilter, no hard-coded hex in
/// feature code (check_centralization scans this file; the map below reads
/// exclusively from `Theme.of`).
class ThemedSvg extends StatelessWidget {
  const ThemedSvg({
    super.key,
    required this.uri,
    this.semanticsLabel,
    this.flipForRtl = false,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });

  final String uri;
  final String? semanticsLabel;

  /// Mirror scenes with driving direction in RTL (tanker, offline…).
  final bool flipForRtl;
  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final tokens = illustrationTokens(context);
    final flip = flipForRtl &&
        Directionality.of(context) == TextDirection.rtl;
    return FutureBuilder<String>(
      future: DefaultAssetBundle.of(context).loadString(uri),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();
        var source = snapshot.data!;
        tokens.forEach((key, value) {
          source = source.replaceAll(key, value);
        });
        final picture = SvgPicture.memory(
          Uint8List.fromList(utf8.encode(source)),
          semanticsLabel: semanticsLabel,
          width: width,
          height: height,
          fit: fit,
        );
        if (!flip) return picture;
        return Transform.flip(flipX: true, child: picture);
      },
    );
  }
}

/// Placeholder → theme-color hex map. Every value derives from
/// `Theme.of(context)` (or the fixed skin ramp, per the style guide).
Map<String, String> illustrationTokens(BuildContext context) {
  final scheme = Theme.of(context).colorScheme;
  final status = Theme.of(context).extension<StatusColors>()!;
  final dark = Theme.of(context).brightness == Brightness.dark;

  String hex(Color c) =>
      '#${c.toARGB32().toRadixString(16).padLeft(8, '0')}';

  Color shift(Color c, double amount) {
    final hsl = HSLColor.fromColor(c);
    final l = (hsl.lightness + (dark ? -amount : amount)).clamp(0.0, 1.0);
    return hsl.withLightness(l).toColor();
  }

  final onVariant = scheme.onSurfaceVariant;
  return {
    '#TT_ACCENT': hex(scheme.primary),
    '#TT_ACCENT_DARK': hex(shift(scheme.primary, 0.15)),
    '#TT_ACCENT_LIGHT': hex(scheme.primaryContainer),
    '#TT_BLOB':
        hex(scheme.primaryContainer.withValues(alpha: 0.4)),
    '#TT_N100': hex(scheme.surfaceContainerHighest),
    '#TT_N200': hex(scheme.outlineVariant),
    '#TT_N300': hex(scheme.outline),
    '#TT_N400': hex(onVariant.withValues(alpha: 0.6)),
    '#TT_N500': hex(onVariant),
    '#TT_N600': hex(scheme.onSurface.withValues(alpha: 0.85)),
    '#TT_N700': hex(scheme.onSurface),
    '#TT_INK': hex(scheme.onSurface),
    '#TT_CRITICAL': hex(status.critical),
    '#TT_OK': hex(status.completed),
    // Fixed skin ramp (style guide §5 — the only fixed hues allowed).
    '#TT_SKIN_1': '#8D5524',
    '#TT_SKIN_2': '#C68642',
    '#TT_SKIN_3': '#E0AC69',
    '#TT_SKIN_4': '#F1C27D',
  };
}
