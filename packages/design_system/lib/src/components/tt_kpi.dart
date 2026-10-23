import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../context_ext.dart';
import '../icons.dart';
import 'tt_gap.dart';

/// KPI tile content (dashboard "Today"): tinted icon, grey caption, large
/// tabular value, optional trend line.
///
/// Compose inside [TTCard]/[TTStickyActionCard]; the tile itself is
/// chrome-free. A leading `+` trends completed-green, a leading `-`/`−`/`(`
/// trends critical-red, anything else stays neutral.
class TTKpiTile extends StatelessWidget {
  const TTKpiTile({
    super.key,
    required this.icon,
    required this.value,
    required this.caption,
    this.trend,
  });

  final AppIcon icon;
  final String value;
  final String caption;
  final String? trend;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.tokens;
    Color? trendColor;
    final trend = this.trend;
    if (trend != null) {
      final head = trend.trimLeft();
      if (head.startsWith('+')) {
        trendColor = context.status.completed;
      } else if (head.startsWith('-') ||
          head.startsWith('\u2212') ||
          head.startsWith('(')) {
        trendColor = context.status.critical;
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(t.spaceSm),
              decoration: BoxDecoration(
                color: c.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                AppIcons.iconFor(icon, context),
                color: c.onPrimaryContainer,
                size: t.iconMd,
              ),
            ),
            const TTGap.sm(axis: Axis.horizontal),
            Expanded(
              child: Text(
                caption,
                style: context.text.bodySmall?.copyWith(
                  color: c.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const TTGap.sm(),
        // Never wrap the figure mid-unit ("266,000. / 0 IG"): scale down
        // on narrow tiles instead.
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: AlignmentDirectional.centerStart,
          child: Text(value, style: context.text.displaySmall),
        ),
        if (trend != null) const TTGap.xs(),
        if (trend != null)
          Text(
            trend,
            style: context.text.labelMedium?.copyWith(
              color: trendColor ?? c.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }
}

/// Single-series sparkline. Color resolves from the theme (accent); the
/// painter itself only receives plain colors via its constructor.
class TTSparkline extends StatelessWidget {
  const TTSparkline({super.key, required this.values});

  final List<double> values;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.tokens.spaceXxxl,
      width: double.infinity,
      child: CustomPaint(
        painter: TTSparklinePainter(
          values: values,
          color: context.colors.primary,
        ),
      ),
    );
  }
}

/// Sparkline painter: plain [values] + plain [color] in, pixels out.
/// No [BuildContext] inside — callers resolve theme colors before passing.
class TTSparklinePainter extends CustomPainter {
  const TTSparklinePainter({
    required this.values,
    required this.color,
    this.strokeWidth = 2,
  });

  final List<double> values;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty || size.isEmpty) return;
    final min = values.reduce(math.min);
    final max = values.reduce(math.max);
    final span = (max - min) == 0 ? 1 : max - min;
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final path = Path();
    for (var i = 0; i < values.length; i++) {
      final x = values.length < 2
          ? size.width / 2
          : (size.width / (values.length - 1)) * i;
      final y = size.height - ((values[i] - min) / span) * size.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant TTSparklinePainter oldDelegate) =>
      !listEquals(oldDelegate.values, values) ||
      oldDelegate.color != color ||
      oldDelegate.strokeWidth != strokeWidth;
}
