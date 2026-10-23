import 'package:flutter/material.dart';

import '../context_ext.dart';
import '../status_colors.dart';

/// Status pill: dot + localized label. Colors from [StatusColors] ONLY —
/// callers pass a [StatusStyle], never a color.
class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.style, required this.label});

  final StatusStyle style;
  final String label;

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
        children: [
          Container(
            width: context.tokens.spaceSm,
            height: context.tokens.spaceSm,
            decoration: BoxDecoration(color: fg, shape: BoxShape.circle),
          ),
          SizedBox(width: context.tokens.spaceXs),
          Text(label, style: context.text.labelMedium?.copyWith(color: fg)),
        ],
      ),
    );
  }
}

/// Quantity badge: IG value + litre sub-line; tolerance coloring
/// (ok → completed, warn → waiting, breach → critical).
enum QuantityState { ok, warn, breach }

class QuantityBadge extends StatelessWidget {
  const QuantityBadge({
    super.key,
    required this.primary,
    this.secondary,
    this.state = QuantityState.ok,
  });

  final String primary;
  final String? secondary;
  final QuantityState state;

  @override
  Widget build(BuildContext context) {
    final s = context.status;
    final color = switch (state) {
      QuantityState.ok => s.completed,
      QuantityState.warn => s.waiting,
      QuantityState.breach => s.critical,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          primary,
          style: context.text.titleMedium?.copyWith(
            color: color,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        if (secondary != null)
          Text(secondary!, style: context.text.bodySmall),
      ],
    );
  }
}

/// Sync state badge: Pending Sync / Synced / Sync Failed.
enum SyncState { pending, synced, failed }

class SyncBadge extends StatelessWidget {
  const SyncBadge({super.key, required this.state, required this.label});

  final SyncState state;
  final String label;

  @override
  Widget build(BuildContext context) {
    final s = context.status;
    final (bg, fg) = switch (state) {
      SyncState.pending => (s.waitingBg, s.waiting),
      SyncState.synced => (s.completedBg, s.completed),
      SyncState.failed => (s.criticalBg, s.critical),
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
      child: Text(label, style: context.text.labelSmall?.copyWith(color: fg)),
    );
  }
}
