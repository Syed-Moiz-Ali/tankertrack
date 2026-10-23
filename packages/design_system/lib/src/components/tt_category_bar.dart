import 'package:flutter/material.dart';

import '../context_ext.dart';
import '../icons.dart';
import 'tt_gap.dart';

/// One category cell: semantic icon over a localized label.
@immutable
class TTCategoryItem {
  const TTCategoryItem({required this.icon, required this.label});

  final AppIcon icon;
  final String label;
}

/// Horizontally scrolling icon+label category bar (R1 tabs / fleet-grid
/// filters). Selected cell gets a [ColorScheme.surfaceContainerHighest] pill
/// (R3); unselected cells are plain. Row order auto-mirrors in RTL.
class TTCategoryBar extends StatelessWidget {
  const TTCategoryBar({
    super.key,
    required this.items,
    required this.selected,
    required this.onSelect,
  });

  final List<TTCategoryItem> items;
  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          for (var i = 0; i < items.length; i++) ...<Widget>[
            _TTCategoryCell(
              item: items[i],
              selected: i == selected,
              onTap: () => onSelect(i),
            ),
            if (i < items.length - 1)
              const TTGap.md(axis: Axis.horizontal),
          ],
        ],
      ),
    );
  }
}

class _TTCategoryCell extends StatefulWidget {
  const _TTCategoryCell({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final TTCategoryItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_TTCategoryCell> createState() => _TTCategoryCellState();
}

class _TTCategoryCellState extends State<_TTCategoryCell> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.tokens;
    final fg = widget.selected ? c.onSurface : c.onSurfaceVariant;
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
            padding: EdgeInsets.symmetric(
              horizontal: t.spaceLg,
              vertical: t.spaceSm,
            ),
            decoration: BoxDecoration(
              color: widget.selected
                  ? c.surfaceContainerHighest
                  : (_hover ? c.surfaceContainerHighest : null),
              borderRadius: BorderRadius.circular(t.radiusCard),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  AppIcons.iconFor(widget.item.icon, context),
                  color: fg,
                  size: t.iconLg,
                ),
                const TTGap.xs(),
                Text(
                  widget.item.label,
                  style: context.text.titleSmall?.copyWith(
                    color: fg,
                    fontWeight:
                        widget.selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
