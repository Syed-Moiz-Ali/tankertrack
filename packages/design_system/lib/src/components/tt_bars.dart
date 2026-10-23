import 'package:flutter/material.dart';

import '../context_ext.dart';
import '../status_colors.dart';
import 'tt_button.dart';
import 'tt_gap.dart';

/// One allocation slice: localized label, numeric value, status-styled color.
///
/// Colors resolve from [StatusColors] via [style] — callers never pass raw
/// colors (status hues stay reserved for statuses).
@immutable
class TTAllocationSegment {
  const TTAllocationSegment({required this.label, required this.value, required this.style});

  final String label;
  final double value;
  final StatusStyle style;
}

Color _allocationFill(StatusColors s, StatusStyle style) => switch (style) {
      StatusStyle.completed => s.completed,
      StatusStyle.active => s.active,
      StatusStyle.loading => s.loading,
      StatusStyle.unloading => s.unloading,
      StatusStyle.waiting => s.waiting,
      StatusStyle.critical => s.critical,
      StatusStyle.offline => s.offline,
    };

String _formatAmount(double value) => value == value.truncateToDouble()
    ? value.toStringAsFixed(0)
    : value.toStringAsFixed(1);

/// Trip-builder allocation bar (dispatch): 100%-stacked segments + total
/// row + per-segment legend with tabular values.
class TTAllocationBar extends StatelessWidget {
  const TTAllocationBar({super.key, required this.segments, this.totalLabel, this.totalValue});

  final List<TTAllocationSegment> segments;
  final String? totalLabel;
  final String? totalValue;

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
                    child: Container(color: context.colors.surfaceContainerHighest),
                  ),
                for (final seg in segments)
                  if (seg.value > 0)
                    Expanded(
                      flex: (seg.value * 100).round().clamp(1, 1000000).toInt(),
                      child: Container(color: _allocationFill(s, seg.style)),
                    ),
              ],
            ),
          ),
        ),
        if (totalLabel != null || totalValue != null) ...<Widget>[
          const TTGap.sm(),
          Row(
            children: <Widget>[
              if (totalLabel != null)
                Expanded(
                  child: Text(
                    totalLabel!,
                    style: context.text.bodySmall?.copyWith(
                      color: context.colors.onSurfaceVariant,
                    ),
                  ),
                ),
              if (totalValue != null)
                Text(totalValue!, style: context.text.titleMedium),
            ],
          ),
        ],
        const TTGap.sm(),
        for (final seg in segments)
          Padding(
            padding: EdgeInsets.only(top: t.spaceXs),
            child: Row(
              children: <Widget>[
                Container(
                  width: t.spaceSm,
                  height: t.spaceSm,
                  decoration: BoxDecoration(
                    color: _allocationFill(s, seg.style),
                    shape: BoxShape.circle,
                  ),
                ),
                const TTGap.sm(axis: Axis.horizontal),
                Expanded(child: Text(seg.label, style: context.text.bodyMedium)),
                Text(_formatAmount(seg.value), style: context.text.titleSmall),
              ],
            ),
          ),
      ],
    );
  }
}

/// Pinned bottom action bar (calm control): safe-area aware, top hairline,
/// optional title/caption, secondary text action + primary CTA.
///
/// Differs from [TTStickyBottomBar] (mobile detail pages): the bottom action
/// bar pins the primary CTA full-width with surface tint for desktop/web
/// flows and dispatch sheets.
class TTBottomActionBar extends StatelessWidget {
  const TTBottomActionBar({
    super.key,
    this.title,
    this.caption,
    required this.primaryLabel,
    required this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
    this.primaryLoading = false,
  });

  final String? title;
  final String? caption;
  final String primaryLabel;
  final VoidCallback? onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;
  final bool primaryLoading;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final c = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        border: Border(top: BorderSide(color: c.outlineVariant)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.all(t.spaceLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (title != null || caption != null) ...<Widget>[
                if (title != null) Text(title!, style: context.text.titleMedium),
                if (caption != null)
                  Text(
                    caption!,
                    style: context.text.bodySmall?.copyWith(
                      color: c.onSurfaceVariant,
                    ),
                  ),
                const TTGap.sm(),
              ],
              if (secondaryLabel != null)
                TTButton(
                  label: secondaryLabel!,
                  variant: TTButtonVariant.tertiary,
                  onPressed: onSecondary,
                ),
              if (secondaryLabel != null) const TTGap.sm(),
              TTButton(
                label: primaryLabel,
                loading: primaryLoading,
                onPressed: onPrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
