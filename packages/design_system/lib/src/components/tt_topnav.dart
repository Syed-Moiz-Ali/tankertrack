import 'package:flutter/material.dart';

import '../context_ext.dart';
import '../icons.dart';
import '../tokens.dart';
import 'tt_gap.dart';
import 'tt_logo_mark.dart';

/// Data for one [TTTopNav] tab: localized label, semantic icon, count badge.
///
/// [badgeCount] renders a small count badge when greater than zero.
@immutable
class TTNavTabData {
  const TTNavTabData({
    required this.label,
    required this.icon,
    this.badgeCount = 0,
  });

  final String label;
  final AppIcon icon;
  final int badgeCount;
}

/// Web top navigation (R1 header): [TTLogoMark] at the start, primary tabs
/// centered, [trailing] cluster (profile/search) at the end.
///
/// When [center] is provided it replaces the tab row (compact search pill on
/// non-home pages, R2). Height is [AppTokens.headerHeight]; the bar uses the
/// theme surface with a bottom hairline, plus [AppShadows.float] when
/// [elevated] (content scrolled underneath).
class TTTopNav extends StatelessWidget implements PreferredSizeWidget {
  const TTTopNav({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onSelect,
    this.center,
    this.trailing,
    this.elevated = false,
  });

  final List<TTNavTabData> tabs;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final Widget? center;
  final Widget? trailing;
  final bool elevated;

  @override
  Size get preferredSize => Size.fromHeight(AppTokens.base.headerHeight);

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final c = context.colors;
    return Container(
      height: t.headerHeight,
      decoration: BoxDecoration(
        color: c.surface,
        border: Border(bottom: BorderSide(color: c.outlineVariant)),
        boxShadow: elevated ? <BoxShadow>[context.shadows.float] : null,
      ),
      padding: EdgeInsets.symmetric(horizontal: t.spaceXl),
      child: Row(
        children: <Widget>[
          const TTLogoMark(),
          const TTGap.lg(axis: Axis.horizontal),
          Expanded(
            child: center ??
                _TTNavTabs(
                  tabs: tabs,
                  selectedIndex: selectedIndex,
                  onSelect: onSelect,
                ),
          ),
          if (trailing != null) const TTGap.lg(axis: Axis.horizontal),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

/// Centered tab row. Scrolls horizontally on narrow screens (no overflow
/// at 800px, incl. long Arabic labels). Row order auto-mirrors in RTL.
class _TTNavTabs extends StatelessWidget {
  const _TTNavTabs({
    required this.tabs,
    required this.selectedIndex,
    required this.onSelect,
  });

  final List<TTNavTabData> tabs;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    // Centered when content fits, scrollable when it overflows (narrow
    // screens / long Arabic labels): minWidth pins the row to the viewport
    // so mainAxisAlignment.center actually centers.
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: constraints.maxWidth),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              for (var i = 0; i < tabs.length; i++)
                _TTNavTab(
                  data: tabs[i],
                  selected: i == selectedIndex,
                  onTap: () => onSelect(i),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TTNavTab extends StatefulWidget {
  const _TTNavTab({
    required this.data,
    required this.selected,
    required this.onTap,
  });

  final TTNavTabData data;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_TTNavTab> createState() => _TTNavTabState();
}

class _TTNavTabState extends State<_TTNavTab> {
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
            decoration: BoxDecoration(
              color: _hover ? c.surfaceContainerHighest : null,
              borderRadius: BorderRadius.circular(t.radiusCard),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: t.spaceLg,
              vertical: t.spaceSm,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _TTNavTabIcon(data: widget.data, color: fg),
                const TTGap.xs(),
                Text(
                  widget.data.label,
                  style: context.text.titleSmall?.copyWith(
                    color: fg,
                    fontWeight:
                        widget.selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const TTGap.xs(),
                Container(
                  height: t.spaceXs,
                  width: t.spaceXl,
                  decoration: BoxDecoration(
                    color: widget.selected ? c.onSurface : null,
                    borderRadius: BorderRadius.circular(t.radiusPill),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TTNavTabIcon extends StatelessWidget {
  const _TTNavTabIcon({required this.data, required this.color});

  final TTNavTabData data;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final icon = Icon(
      AppIcons.iconFor(data.icon, context),
      color: color,
      size: context.tokens.iconLg,
    );
    if (data.badgeCount <= 0) return icon;
    final t = context.tokens;
    final c = context.colors;
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        icon,
        PositionedDirectional(
          top: -t.spaceXs,
          end: -t.spaceSm,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: t.spaceXs),
            constraints: BoxConstraints(
              minWidth: t.iconSm,
              minHeight: t.iconSm,
            ),
            decoration: BoxDecoration(
              color: c.error,
              borderRadius: BorderRadius.circular(t.radiusPill),
            ),
            child: Center(
              child: Text(
                '${data.badgeCount}',
                style: context.text.labelSmall?.copyWith(color: c.onError),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
