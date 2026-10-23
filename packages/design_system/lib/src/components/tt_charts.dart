import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../context_ext.dart';
import '../status_colors.dart';
import 'tt_gap.dart';

/// One chart slice: localized label, numeric value, status-styled color.
///
/// Colors resolve from [StatusColors] via [style] — callers never pass raw
/// colors (status hues stay reserved for statuses).
@immutable
class TTBarSegment {
  const TTBarSegment({
    required this.label,
    required this.value,
    required this.style,
  });

  final String label;
  final double value;
  final StatusStyle style;
}

Color _statusFill(StatusColors s, StatusStyle style) => switch (style) {
      StatusStyle.completed => s.completed,
      StatusStyle.active => s.active,
      StatusStyle.loading => s.loading,
      StatusStyle.unloading => s.unloading,
      StatusStyle.waiting => s.waiting,
      StatusStyle.critical => s.critical,
      StatusStyle.offline => s.offline,
    };

String _formatValue(double value) => value == value.truncateToDouble()
    ? value.toStringAsFixed(0)
    : value.toStringAsFixed(1);

/// Horizontal 100%-stacked bar + dot legend (control-room/tower mix views).
class TTStackedBar extends StatelessWidget {
  const TTStackedBar({super.key, required this.segments});

  final List<TTBarSegment> segments;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final s = context.status;
    final total = segments.fold(0.0, (sum, seg) => sum + seg.value);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(t.radiusPill),
          child: SizedBox(
            height: t.spaceLg,
            child: Row(
              children: <Widget>[
                if (total <= 0)
                  Expanded(
                    child: Container(
                      color: context.colors.surfaceContainerHighest,
                    ),
                  ),
                for (final seg in segments)
                  if (seg.value > 0)
                    Expanded(
                      flex: (seg.value * 100)
                          .round()
                          .clamp(1, 1000000)
                          .toInt(),
                      child: Container(color: _statusFill(s, seg.style)),
                    ),
              ],
            ),
          ),
        ),
        if (segments.isNotEmpty) const TTGap.sm(),
        if (segments.isNotEmpty)
          Wrap(
            spacing: t.spaceMd,
            runSpacing: t.spaceXs,
            children: <Widget>[
              for (final seg in segments)
                _TTChartLegend(
                  label: seg.label,
                  value: _formatValue(seg.value),
                  color: _statusFill(s, seg.style),
                ),
            ],
          ),
      ],
    );
  }
}

/// Donut with centered total + dot legend. Same [TTBarSegment] model as
/// [TTStackedBar].
class TTDonut extends StatelessWidget {
  const TTDonut({super.key, required this.segments});

  final List<TTBarSegment> segments;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final s = context.status;
    final colors = <Color>[
      for (final seg in segments) _statusFill(s, seg.style),
    ];
    final values = <double>[for (final seg in segments) seg.value];
    final total = values.fold(0.0, (sum, v) => sum + v);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox.square(
          dimension: t.spaceXxxl * 3,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              CustomPaint(
                painter: TTDonutPainter(
                  values: values,
                  colors: colors,
                  trackColor: context.colors.surfaceContainerHighest,
                ),
              ),
              Text(
                _formatValue(total),
                style: context.text.titleLarge,
              ),
            ],
          ),
        ),
        if (segments.isNotEmpty) const TTGap.sm(),
        if (segments.isNotEmpty)
          Wrap(
            spacing: t.spaceMd,
            runSpacing: t.spaceXs,
            alignment: WrapAlignment.center,
            children: <Widget>[
              for (final seg in segments)
                _TTChartLegend(
                  label: seg.label,
                  value: _formatValue(seg.value),
                  color: _statusFill(s, seg.style),
                ),
            ],
          ),
      ],
    );
  }
}

/// Donut painter: plain [values] + plain [colors]/[trackColor] in, pixels
/// out. No [BuildContext] inside.
class TTDonutPainter extends CustomPainter {
  const TTDonutPainter({
    required this.values,
    required this.colors,
    required this.trackColor,
    this.strokeWidth = 14,
  });

  final List<double> values;
  final List<Color> colors;
  final Color trackColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final total = values.fold(0.0, (sum, v) => sum + v);
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - strokeWidth) / 2;
    if (radius <= 0) return;
    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = trackColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );
    if (total <= 0 || values.isEmpty || colors.isEmpty) return;
    var start = -math.pi / 2;
    for (var i = 0; i < values.length; i++) {
      final sweep = (values[i] / total) * math.pi * 2;
      if (sweep <= 0) continue;
      canvas.drawArc(
        rect,
        start,
        sweep,
        false,
        Paint()
          ..color = colors[i % colors.length]
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.butt,
      );
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant TTDonutPainter oldDelegate) =>
      !listEquals(oldDelegate.values, values) ||
      !listEquals(oldDelegate.colors, colors) ||
      oldDelegate.trackColor != trackColor ||
      oldDelegate.strokeWidth != strokeWidth;
}

class _TTChartLegend extends StatelessWidget {
  const _TTChartLegend({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: t.spaceSm,
          height: t.spaceSm,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const TTGap.xs(axis: Axis.horizontal),
        Text(label, style: context.text.bodySmall),
        const TTGap.xs(axis: Axis.horizontal),
        Text(value, style: context.text.labelMedium),
      ],
    );
  }
}
