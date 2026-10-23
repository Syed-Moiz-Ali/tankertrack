import 'package:flutter/material.dart';

import '../context_ext.dart';
import 'tt_gap.dart';

/// One segmented tab: localized label + live count badge.
@immutable
class TTCountTab {
  const TTCountTab({required this.label, required this.count});

  final String label;
  final int count;
}

/// Segmented control with per-tab counts (dashboard "Today" filters).
/// Selected segment floats on the theme surface; counts always render as
/// text so they stay testable and localizable.
class TTSegmentedTabs extends StatelessWidget {
  const TTSegmentedTabs({
    super.key,
    required this.tabs,
    required this.selected,
    required this.onSelect,
  });

  final List<TTCountTab> tabs;
  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return LayoutBuilder(
      builder: (context, constraints) {
        final cells = <Widget>[
          for (var i = 0; i < tabs.length; i++)
            _TTCountCell(
              tab: tabs[i],
              selected: i == selected,
              onTap: () => onSelect(i),
            ),
        ];
        // Wide: stretched pill row. Narrow (mobile): horizontal scroll with
        // readable min-width cells instead of truncated ellipsis labels.
        if (constraints.maxWidth >= context.tokens.breakpointTablet) {
          return Container(
            decoration: BoxDecoration(
              color: context.colors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(t.radiusPill),
            ),
            padding: EdgeInsets.all(t.spaceXs),
            child: Row(
              children: <Widget>[
                for (final cell in cells) Expanded(child: cell),
              ],
            ),
          );
        }
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              for (final cell in cells)
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: t.touchWeb * 2.5,
                  ),
                  child: cell,
                ),
            ],
          ),
        );
      },
    );
  }
}

class _TTCountCell extends StatefulWidget {
  const _TTCountCell({
    required this.tab,
    required this.selected,
    required this.onTap,
  });

  final TTCountTab tab;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_TTCountCell> createState() => _TTCountCellState();
}

class _TTCountCellState extends State<_TTCountCell> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.tokens;
    return Semantics(
      button: true,
      selected: widget.selected,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: GestureDetector(
          onTap: widget.onTap,
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: t.motionMicro,
            curve: t.curve,
            padding: EdgeInsets.symmetric(vertical: t.spaceSm),
            decoration: BoxDecoration(
              color: widget.selected
                  ? c.surface
                  : (_hover ? c.surface : null),
              borderRadius: BorderRadius.circular(t.radiusPill),
              boxShadow:
                  widget.selected ? <BoxShadow>[context.shadows.float] : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  child: Text(
                    widget.tab.label,
                    style: context.text.labelLarge?.copyWith(
                      color: widget.selected
                          ? c.onSurface
                          : c.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const TTGap.xs(axis: Axis.horizontal),
                _TTCountBadge(
                  count: widget.tab.count,
                  selected: widget.selected,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TTCountBadge extends StatelessWidget {
  const _TTCountBadge({required this.count, required this.selected});

  final int count;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.tokens;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: t.spaceSm),
      decoration: BoxDecoration(
        color: selected ? c.primaryContainer : c.outlineVariant,
        borderRadius: BorderRadius.circular(t.radiusPill),
      ),
      child: Text(
        '$count',
        style: context.text.labelMedium?.copyWith(
          color: selected ? c.onPrimaryContainer : c.onSurfaceVariant,
        ),
      ),
    );
  }
}
