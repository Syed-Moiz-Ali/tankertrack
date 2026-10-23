import 'package:flutter/material.dart';

import '../context_ext.dart';
import '../icons.dart';
import '../tokens.dart';
import 'tt_button.dart';
import 'tt_gap.dart';
import 'tt_logo_mark.dart';

/// One [TTTopBar] nav item: localized label, semantic icon, count badge.
@immutable
class TTTopBarItem {
  const TTTopBarItem({required this.label, required this.icon, this.badgeCount = 0});

  final String label;
  final AppIcon icon;
  final int badgeCount;
}

/// Slim back-office top bar (R3 §5): product mark + 5–6 items + compact
/// command trigger + bell + profile menu entry.
///
/// Row order auto-mirrors in RTL. Hover states animate over
/// [AppTokens.motionMicro]; pressed/focus come from the underlying
/// [InkWell]/[IconButton] themes.
class TTTopBar extends StatelessWidget implements PreferredSizeWidget {
  const TTTopBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelect,
    required this.commandHint,
    required this.shortcutHint,
    required this.onCommand,
    this.hasNotifications = false,
    required this.notificationsLabel,
    required this.onNotifications,
    required this.profileLabel,
    required this.profileTooltip,
    required this.onProfile,
    this.elevated = false,
  });

  final List<TTTopBarItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final String commandHint;
  final String shortcutHint;
  final VoidCallback onCommand;
  final bool hasNotifications;
  final String notificationsLabel;
  final VoidCallback onNotifications;
  final String profileLabel;
  final String profileTooltip;
  final VoidCallback onProfile;
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
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  for (var i = 0; i < items.length; i++)
                    _TTTopBarTab(
                      item: items[i],
                      selected: i == selectedIndex,
                      onTap: () => onSelect(i),
                    ),
                ],
              ),
            ),
          ),
          const TTGap.md(axis: Axis.horizontal),
          _TTCommandTrigger(
            hint: commandHint,
            shortcutHint: shortcutHint,
            onTap: onCommand,
          ),
          const TTGap.sm(axis: Axis.horizontal),
          _TTBellAction(
            hasNotifications: hasNotifications,
            semanticLabel: notificationsLabel,
            onTap: onNotifications,
          ),
          const TTGap.sm(axis: Axis.horizontal),
          _TTProfileAction(
            label: profileLabel,
            tooltip: profileTooltip,
            onTap: onProfile,
          ),
        ],
      ),
    );
  }
}

class _TTTopBarTab extends StatefulWidget {
  const _TTTopBarTab({required this.item, required this.selected, required this.onTap});

  final TTTopBarItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_TTTopBarTab> createState() => _TTTopBarTabState();
}

class _TTTopBarTabState extends State<_TTTopBarTab> {
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
              color: widget.selected
                  ? c.surfaceContainerHighest
                  : _hover
                      ? c.surfaceContainerHigh
                      : null,
              borderRadius: BorderRadius.circular(t.radiusCard),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: t.spaceLg,
              vertical: t.spaceSm,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  AppIcons.iconFor(widget.item.icon, context),
                  color: fg,
                  size: t.iconMd,
                ),
                const TTGap.sm(axis: Axis.horizontal),
                Text(
                  widget.item.label,
                  style: context.text.titleSmall?.copyWith(
                    color: fg,
                    fontWeight: widget.selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (widget.item.badgeCount > 0) ...<Widget>[
                  const TTGap.sm(axis: Axis.horizontal),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: t.spaceXs),
                    constraints: BoxConstraints(minWidth: t.iconSm, minHeight: t.iconSm),
                    decoration: BoxDecoration(
                      color: c.error,
                      borderRadius: BorderRadius.circular(t.radiusPill),
                    ),
                    child: Center(
                      child: Text(
                        '${widget.item.badgeCount}',
                        style: context.text.labelSmall?.copyWith(color: c.onError),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Compact command-palette trigger: search icon + hint + keyboard shortcut.
class _TTCommandTrigger extends StatefulWidget {
  const _TTCommandTrigger({required this.hint, required this.shortcutHint, required this.onTap});

  final String hint;
  final String shortcutHint;
  final VoidCallback onTap;

  @override
  State<_TTCommandTrigger> createState() => _TTCommandTriggerState();
}

class _TTCommandTriggerState extends State<_TTCommandTrigger> {
  bool _hover = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.tokens;
    final highlight = _hover || _focused;
    return Semantics(
      button: true,
      child: Focus(
        onFocusChange: (v) => setState(() => _focused = v),
        child: MouseRegion(
          onEnter: (_) => setState(() => _hover = true),
          onExit: (_) => setState(() => _hover = false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: widget.onTap,
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: t.motionMicro,
              curve: t.curve,
              padding: EdgeInsets.symmetric(
                horizontal: t.spaceMd,
                vertical: t.spaceSm,
              ),
              decoration: BoxDecoration(
                color: highlight ? c.surfaceContainerHighest : c.surfaceContainer,
                borderRadius: BorderRadius.circular(t.radiusField),
                border: Border.all(
                  color: _focused ? c.primary : c.outlineVariant,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    AppIcons.iconFor(AppIcons.search, context),
                    color: c.onSurfaceVariant,
                    size: t.iconMd,
                  ),
                  const TTGap.sm(axis: Axis.horizontal),
                  Flexible(
                    child: Text(
                      widget.hint,
                      style: context.text.bodyMedium?.copyWith(
                        color: c.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const TTGap.md(axis: Axis.horizontal),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: t.spaceXs),
                    decoration: BoxDecoration(
                      border: Border.all(color: c.outline),
                      borderRadius: BorderRadius.circular(t.radiusCard),
                    ),
                    child: Text(widget.shortcutHint, style: context.text.labelSmall),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TTBellAction extends StatelessWidget {
  const _TTBellAction({required this.hasNotifications, required this.semanticLabel, required this.onTap});

  final bool hasNotifications;
  final String semanticLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        TTIconButton(
          icon: Icon(AppIcons.iconFor(AppIcons.bell, context)),
          semanticLabel: semanticLabel,
          tooltip: semanticLabel,
          onPressed: onTap,
        ),
        if (hasNotifications)
          PositionedDirectional(
            top: t.spaceXs,
            end: t.spaceXs,
            child: Container(
              width: t.spaceSm,
              height: t.spaceSm,
              decoration: BoxDecoration(
                color: context.colors.error,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}

class _TTProfileAction extends StatefulWidget {
  const _TTProfileAction({required this.label, required this.tooltip, required this.onTap});

  final String label;
  final String tooltip;
  final VoidCallback onTap;

  @override
  State<_TTProfileAction> createState() => _TTProfileActionState();
}

class _TTProfileActionState extends State<_TTProfileAction> {
  bool _hover = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.tokens;
    return Semantics(
      button: true,
      label: widget.tooltip,
      child: Focus(
        onFocusChange: (v) => setState(() => _focused = v),
        child: MouseRegion(
          onEnter: (_) => setState(() => _hover = true),
          onExit: (_) => setState(() => _hover = false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: widget.onTap,
            behavior: HitTestBehavior.opaque,
            child: Tooltip(
              message: widget.tooltip,
              child: AnimatedContainer(
                duration: t.motionMicro,
                curve: t.curve,
                width: t.touchWeb,
                height: t.touchWeb,
                decoration: BoxDecoration(
                  color: c.primaryContainer,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: (_hover || _focused) ? c.primary : c.outlineVariant,
                  ),
                ),
                child: Center(
                  child: Text(
                    widget.label,
                    style: context.text.titleSmall?.copyWith(
                      color: c.onPrimaryContainer,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
