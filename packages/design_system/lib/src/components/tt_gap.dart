import 'package:flutter/material.dart';

import '../context_ext.dart';

/// Token spacing widget. Replaces ALL raw `SizedBox(width|height: <number>)`
/// in feature code (lint-enforced).
///
/// ```dart
/// const TTGap.md(),
/// const TTGap.lg(axis: Axis.horizontal),
/// ```
enum TTGapSize { xs, sm, md, lg, xl, xxl, xxxl }

class TTGap extends StatelessWidget {
  const TTGap(this.size, {super.key, this.axis = Axis.vertical});
  const TTGap.xs({super.key, this.axis = Axis.vertical})
      : size = TTGapSize.xs;
  const TTGap.sm({super.key, this.axis = Axis.vertical})
      : size = TTGapSize.sm;
  const TTGap.md({super.key, this.axis = Axis.vertical})
      : size = TTGapSize.md;
  const TTGap.lg({super.key, this.axis = Axis.vertical})
      : size = TTGapSize.lg;
  const TTGap.xl({super.key, this.axis = Axis.vertical})
      : size = TTGapSize.xl;
  const TTGap.xxl({super.key, this.axis = Axis.vertical})
      : size = TTGapSize.xxl;
  const TTGap.xxxl({super.key, this.axis = Axis.vertical})
      : size = TTGapSize.xxxl;

  final TTGapSize size;
  final Axis axis;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final v = switch (size) {
      TTGapSize.xs => t.spaceXs,
      TTGapSize.sm => t.spaceSm,
      TTGapSize.md => t.spaceMd,
      TTGapSize.lg => t.spaceLg,
      TTGapSize.xl => t.spaceXl,
      TTGapSize.xxl => t.spaceXxl,
      TTGapSize.xxxl => t.spaceXxxl,
    };
    return axis == Axis.vertical ? SizedBox(height: v) : SizedBox(width: v);
  }
}
