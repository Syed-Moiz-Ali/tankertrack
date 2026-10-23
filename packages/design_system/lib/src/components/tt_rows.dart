import 'package:flutter/material.dart';

import '../context_ext.dart';
import '../icons.dart';
import '../status_colors.dart';
import 'tt_gap.dart';
import 'tt_stat.dart';

/// Typographic list row (R3 §6): avatar + primary + secondary line +
/// status pill, hover highlight. Filter pills carry real counts; list rows
/// carry real statuses — no fake filters, no fake pills.
///
/// Row order auto-mirrors in RTL. Hover/pressed/focus animate over
/// [AppTokens.motionMicro].
class TTListRow extends StatefulWidget {
  const TTListRow({
    super.key,
    required this.title,
    required this.subtitle,
    this.initials,
    this.style,
    this.pillLabel,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final String? initials;
  final StatusStyle? style;
  final String? pillLabel;
  final VoidCallback? onTap;

  @override
  State<TTListRow> createState() => _TTListRowState();
}

class _TTListRowState extends State<TTListRow> {
  bool _hover = false;
  bool _focused = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.tokens;
    final tappable = widget.onTap != null;
    return Semantics(
      button: tappable,
      child: Focus(
        onFocusChange: (v) => setState(() => _focused = v),
        child: MouseRegion(
          onEnter: (_) => setState(() => _hover = true),
          onExit: (_) => setState(() {
            _hover = false;
            _pressed = false;
          }),
          cursor: tappable ? SystemMouseCursors.click : SystemMouseCursors.basic,
          child: GestureDetector(
            onTap: widget.onTap,
            onTapDown: (_) => setState(() => _pressed = true),
            onTapUp: (_) => setState(() => _pressed = false),
            onTapCancel: () => setState(() => _pressed = false),
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: t.motionMicro,
              curve: t.curve,
              padding: EdgeInsets.symmetric(
                horizontal: t.spaceLg,
                vertical: t.spaceMd,
              ),
              decoration: BoxDecoration(
                color: _pressed
                    ? c.surfaceContainerHigh
                    : _hover && tappable
                        ? c.surfaceContainerHighest
                        : null,
                borderRadius: BorderRadius.circular(t.radiusCard),
                border: Border.all(
                  color: _focused ? c.primary : c.outlineVariant,
                ),
              ),
              child: Row(
                children: <Widget>[
                  _TTAvatar(initials: widget.initials),
                  const TTGap.md(axis: Axis.horizontal),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          widget.title,
                          style: context.text.titleSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          widget.subtitle,
                          style: context.text.bodySmall?.copyWith(
                            color: c.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  if (widget.style != null && widget.pillLabel != null) ...<Widget>[
                    const TTGap.md(axis: Axis.horizontal),
                    TTStatusPill(style: widget.style!, label: widget.pillLabel!),
                  ],
                  if (tappable) ...<Widget>[
                    const TTGap.sm(axis: Axis.horizontal),
                    Icon(
                      AppIcons.iconFor(AppIcons.next, context),
                      color: c.onSurfaceVariant,
                      size: t.iconMd,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TTAvatar extends StatelessWidget {
  const _TTAvatar({required this.initials});

  final String? initials;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.tokens;
    return Container(
      width: t.touchWeb,
      height: t.touchWeb,
      decoration: BoxDecoration(
        color: c.primaryContainer,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: initials == null
            ? Icon(
                AppIcons.iconFor(AppIcons.user, context),
                color: c.onPrimaryContainer,
                size: t.iconMd,
              )
            : Text(
                initials!,
                style: context.text.titleSmall?.copyWith(
                  color: c.onPrimaryContainer,
                ),
              ),
      ),
    );
  }
}
