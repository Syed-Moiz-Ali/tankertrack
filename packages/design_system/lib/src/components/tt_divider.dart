import 'package:flutter/material.dart';

import '../context_ext.dart';

/// Token divider. Theme provides color/thickness; optional indent uses the
/// page gutter token (never a literal).
class TTDivider extends StatelessWidget {
  const TTDivider({super.key, this.indented = false});
  final bool indented;

  @override
  Widget build(BuildContext context) {
    if (!indented) return const Divider();
    final t = context.tokens;
    return Divider(indent: t.gutterMobile, endIndent: t.gutterMobile);
  }
}
