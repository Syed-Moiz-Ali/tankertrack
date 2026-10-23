import 'package:flutter/material.dart';

import '../context_ext.dart';
import 'tt_gap.dart';
import 'tt_stat.dart';

/// Floating "Live operations" card data: localized title, ETA / distance /
/// remaining label+value pairs, and the view-action label.
///
/// All strings arrive via params (host passes `context.l10n` values).
@immutable
class TTLiveOpsInfo {
  const TTLiveOpsInfo({
    required this.title,
    required this.etaLabel,
    required this.etaValue,
    required this.distanceLabel,
    required this.distanceValue,
    required this.remainingLabel,
    required this.remainingValue,
    required this.viewLabel,
  });

  final String title;
  final String etaLabel;
  final String etaValue;
  final String distanceLabel;
  final String distanceValue;
  final String remainingLabel;
  final String remainingValue;
  final String viewLabel;
}

/// Floating live-operations card: counts + selected tanker ETA / distance /
/// remaining + view action. Renders on the theme surface with a single soft
/// shadow (R3 §2 anti-SaaS rule).
class TTLiveOpsCard extends StatelessWidget {
  const TTLiveOpsCard({super.key, required this.info, this.onView});

  final TTLiveOpsInfo info;
  final VoidCallback? onView;

  /// Display-only usages (catalogue, RTL smoke) omit [onView].

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final c = context.colors;
    return Container(
      padding: EdgeInsets.all(t.spaceLg),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(t.radiusCard),
        border: Border.all(color: c.outlineVariant),
        boxShadow: <BoxShadow>[context.shadows.float],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: t.spaceSm,
                height: t.spaceSm,
                decoration: BoxDecoration(
                  color: context.status.active,
                  shape: BoxShape.circle,
                ),
              ),
              const TTGap.sm(axis: Axis.horizontal),
              Expanded(
                child: Text(info.title, style: context.text.titleMedium),
              ),
              TextButton(onPressed: onView, child: Text(info.viewLabel)),
            ],
          ),
          const TTGap.md(),
          Row(
            children: <Widget>[
              Expanded(child: _TTLiveOpsMetric(label: info.etaLabel, value: info.etaValue)),
              Expanded(
                child: _TTLiveOpsMetric(label: info.distanceLabel, value: info.distanceValue),
              ),
              Expanded(
                child: _TTLiveOpsMetric(label: info.remainingLabel, value: info.remainingValue),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TTLiveOpsMetric extends StatelessWidget {
  const _TTLiveOpsMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          label,
          style: context.text.bodySmall?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(value, style: context.text.titleSmall),
      ],
    );
  }
}

/// Map-led hero (R3 §6): rounded live map with the floating live-ops card
/// overlaid at the bottom, followed by the 4-number [TTStatStrip].
///
/// [map] is supplied by the host (real tiles + attribution); the hero only
/// provides the rounded clip and overlay layout.
class TTHeroMap extends StatelessWidget {
  const TTHeroMap({
    super.key,
    required this.map,
    this.mapHeight,
    required this.liveOps,
    this.onViewLiveOps,
    required this.stats,
  });

  final Widget map;
  final double? mapHeight;
  final TTLiveOpsInfo liveOps;

  /// Display-only usages (catalogue, RTL smoke) omit [onViewLiveOps].
  final VoidCallback? onViewLiveOps;
  final List<TTStatData> stats;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(t.radiusLarge),
              child: SizedBox(
                height: mapHeight ?? t.spaceXxxl * 6,
                width: double.infinity,
                child: map,
              ),
            ),
            PositionedDirectional(
              bottom: t.spaceLg,
              start: t.spaceLg,
              end: t.spaceLg,
              child: TTLiveOpsCard(info: liveOps, onView: onViewLiveOps),
            ),
          ],
        ),
        const TTGap.md(),
        TTStatStrip(stats: stats),
      ],
    );
  }
}
