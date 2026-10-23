import 'package:flutter/material.dart';

import '../context_ext.dart';
import '../icons.dart';
import '../status_colors.dart';
import 'tt_gap.dart';

/// One headline number: localized label + tabular value + optional caption.
///
/// At most four render in a [TTStatStrip] (R3 §2: max 4 headline numbers).
@immutable
class TTStatData {
  const TTStatData({required this.label, required this.value, this.caption});

  final String label;
  final String value;
  final String? caption;
}

/// Four-number headline strip (dashboard "Live operations" numbers).
///
/// Direction-aware: cells flow start→end (auto-mirror in RTL) with a
/// directional hairline between cells. Values use theme tabular figures.
class TTStatStrip extends StatelessWidget {
  const TTStatStrip({super.key, required this.stats})
      : assert(stats.length <= 4, 'TTStatStrip shows at most 4 numbers');

  final List<TTStatData> stats;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        for (var i = 0; i < stats.length; i++)
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: i == 0
                    ? null
                    : BorderDirectional(
                        start: BorderSide(
                          color: context.colors.outlineVariant,
                        ),
                      ),
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.only(
                  start: i == 0 ? context.tokens.spaceSm : context.tokens.spaceLg,
                  end: context.tokens.spaceSm,
                ),
                child: _TTStatCell(stat: stats[i]),
              ),
            ),
          ),
      ],
    );
  }
}

class _TTStatCell extends StatelessWidget {
  const _TTStatCell({required this.stat});

  final TTStatData stat;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(stat.value, style: context.text.titleLarge),
        const TTGap.xs(),
        Text(
          stat.label,
          style: context.text.bodySmall?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
        if (stat.caption != null)
          Text(
            stat.caption!,
            style: context.text.bodySmall?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
      ],
    );
  }
}

/// Status pill (tonal background + label, optional leading icon).
///
/// Differs from [StatusChip] (dot + label): the pill is the compact
/// list-row/cell treatment. Colors come from [StatusColors] via [style] —
/// callers never pass raw colors.
class TTStatusPill extends StatelessWidget {
  const TTStatusPill({super.key, required this.style, required this.label, this.icon});

  final StatusStyle style;
  final String label;
  final AppIcon? icon;

  @override
  Widget build(BuildContext context) {
    final s = context.status;
    final (bg, fg) = switch (style) {
      StatusStyle.completed => (s.completedBg, s.completed),
      StatusStyle.active => (s.activeBg, s.active),
      StatusStyle.loading => (s.loadingBg, s.loading),
      StatusStyle.unloading => (s.unloadingBg, s.unloading),
      StatusStyle.waiting => (s.waitingBg, s.waiting),
      StatusStyle.critical => (s.criticalBg, s.critical),
      StatusStyle.offline => (s.offlineBg, s.offline),
    };
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.tokens.spaceMd,
        vertical: context.tokens.spaceXs,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(context.tokens.radiusPill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (icon != null)
            Icon(
              AppIcons.iconFor(icon!, context),
              color: fg,
              size: context.tokens.iconSm,
            ),
          if (icon != null) const TTGap.xs(axis: Axis.horizontal),
          Flexible(
            child: Text(
              label,
              style: context.text.labelSmall?.copyWith(color: fg),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
