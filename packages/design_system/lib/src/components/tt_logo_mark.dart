import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../assets.dart';
import '../context_ext.dart';

/// TankerTrack logo mark (fuel-drop + route-pin fusion).
///
/// Renders [AppAssets.logoMark] at [size] (defaults to `tokens.iconLg`).
class TTLogoMark extends StatelessWidget {
  /// Creates the TankerTrack logo mark.
  const TTLogoMark({super.key, this.size, this.semanticsLabel});

  /// Square edge length in logical pixels. Defaults to `tokens.iconLg`.
  final double? size;

  /// Accessibility label for the mark.
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final resolved = size ?? context.tokens.iconLg;
    return SvgPicture.asset(
      AppAssets.logoMark,
      width: resolved,
      height: resolved,
      semanticsLabel: semanticsLabel,
    );
  }
}
