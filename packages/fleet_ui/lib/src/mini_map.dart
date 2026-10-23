import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mini_map.freezed.dart';
part 'mini_map.g.dart';

/// Bounds-aware live fleet dot (P1 slice D).
@freezed
abstract class MapPosition with _$MapPosition {
  const factory MapPosition({
    required String id,
    required double lat,
    required double lng,
    required StatusStyle style,
    String? label,
  }) = _MapPosition;

  factory MapPosition.fromJson(Map<String, Object?> json) =>
      _$MapPositionFromJson(json);
}

class MiniMap extends StatelessWidget {
  const MiniMap({
    super.key,
    required this.positions,
    this.title,
    this.labelFirst = 6,
  });

  final List<MapPosition> positions;
  final String? title;

  /// How many leading dots get a text label (label ?? id).
  final int labelFirst;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final status = context.status;
    final tokens = context.tokens;
    final dots = <StatusStyle, _DotColors>{
      StatusStyle.completed:
          _DotColors(status.completedBg, status.completed),
      StatusStyle.active: _DotColors(status.activeBg, status.active),
      StatusStyle.loading: _DotColors(status.loadingBg, status.loading),
      StatusStyle.unloading:
          _DotColors(status.unloadingBg, status.unloading),
      StatusStyle.waiting: _DotColors(status.waitingBg, status.waiting),
      StatusStyle.critical:
          _DotColors(status.criticalBg, status.critical),
      StatusStyle.offline: _DotColors(status.offlineBg, status.offline),
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null)
          Text(title!, style: context.text.titleMedium),
        if (title != null) const TTGap.sm(),
        SizedBox(
          height: tokens.spaceXxxl * 5,
          width: double.infinity,
          child: CustomPaint(
            painter: _MiniMapPainter(
              positions: positions,
              dots: dots,
              surface: colors.surfaceContainer,
              grid: colors.outlineVariant,
              labelStyle: context.text.labelSmall!,
              labelColor: colors.onSurface,
              labelFirst: labelFirst,
              radius: tokens.spaceSm,
              haloScale: tokens.spaceXs / tokens.spaceSm,
            ),
          ),
        ),
      ],
    );
  }
}

class _DotColors {
  const _DotColors(this.bg, this.fg);
  final Color bg;
  final Color fg;
}

class _MiniMapPainter extends CustomPainter {
  const _MiniMapPainter({
    required this.positions,
    required this.dots,
    required this.surface,
    required this.grid,
    required this.labelStyle,
    required this.labelColor,
    required this.labelFirst,
    required this.radius,
    required this.haloScale,
  });

  final List<MapPosition> positions;
  final Map<StatusStyle, _DotColors> dots;
  final Color surface;
  final Color grid;
  final TextStyle labelStyle;
  final Color labelColor;
  final int labelFirst;
  final double radius;
  final double haloScale;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = surface,
    );
    // Faint graticule: 3 vertical + 3 horizontal theme lines.
    final gridPaint = Paint()
      ..color = grid
      ..strokeWidth = 1;
    for (var i = 1; i <= 3; i++) {
      final dx = size.width * i / 4;
      canvas.drawLine(Offset(dx, 0), Offset(dx, size.height), gridPaint);
      final dy = size.height * i / 4;
      canvas.drawLine(Offset(0, dy), Offset(size.width, dy), gridPaint);
    }
    if (positions.isEmpty) return;

    var minLat = positions.first.lat;
    var maxLat = positions.first.lat;
    var minLng = positions.first.lng;
    var maxLng = positions.first.lng;
    for (final p in positions) {
      if (p.lat < minLat) minLat = p.lat;
      if (p.lat > maxLat) maxLat = p.lat;
      if (p.lng < minLng) minLng = p.lng;
      if (p.lng > maxLng) maxLng = p.lng;
    }
    // Guard degenerate bounds (single point / identical coords).
    if ((maxLat - minLat).abs() < 1e-9) {
      minLat -= 0.01;
      maxLat += 0.01;
    }
    if ((maxLng - minLng).abs() < 1e-9) {
      minLng -= 0.01;
      maxLng += 0.01;
    }
    // Uniform scale + center (aspect kept, no stretch).
    final pad = radius * 3;
    final sx = (size.width - pad * 2) / (maxLng - minLng);
    final sy = (size.height - pad * 2) / (maxLat - minLat);
    final s = sx < sy ? sx : sy;
    final ox =
        (size.width - (maxLng - minLng) * s) / 2 - minLng * s;
    final oy =
        (size.height - (maxLat - minLat) * s) / 2 - minLat * s;

    Offset project(MapPosition p) =>
        Offset(p.lng * s + ox, size.height - (p.lat * s + oy));

    for (final p in positions) {
      final c = project(p);
      final pair = dots[p.style]!;
      canvas.drawCircle(
        c,
        radius * (1 + haloScale),
        Paint()..color = pair.bg,
      );
      canvas.drawCircle(c, radius, Paint()..color = pair.fg);
    }
    // First N labeled (explicit label ?? vehicle id).
    final labeled = positions.take(labelFirst < 0 ? 0 : labelFirst);
    for (final p in labeled) {
      final c = project(p);
      final tp = TextPainter(
        text: TextSpan(
          text: p.label ?? p.id,
          style: labelStyle.copyWith(color: labelColor),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
        tp.paint(canvas, c + Offset(radius + haloScale, -tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant _MiniMapPainter old) =>
      old.positions != positions ||
      old.surface != surface ||
      old.grid != grid ||
      old.labelFirst != labelFirst;
}
