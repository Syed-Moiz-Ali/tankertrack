import 'package:flutter/material.dart';

import '../context_ext.dart';
import '../status_colors.dart';
import 'tt_gap.dart';
import 'tt_stat.dart';

/// Typographic entity card (R3 §6): title + secondary line + detail rows +
/// optional status pill. No decorative imagery, no big shadows — borders +
/// tonal surfaces only (R3 §2 anti-SaaS rules).
///
/// Hover/pressed/focus animate over [AppTokens.motionMicro].
class TTEntityCard extends StatefulWidget {
  const TTEntityCard({
    super.key,
    required this.title,
    this.subtitle,
    this.details = const <String>[],
    this.statusStyle,
    this.statusLabel,
    this.footer,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final List<String> details;
  final StatusStyle? statusStyle;
  final String? statusLabel;
  final Widget? footer;
  final VoidCallback? onTap;

  @override
  State<TTEntityCard> createState() => _TTEntityCardState();
}

class _TTEntityCardState extends State<TTEntityCard> {
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
              padding: EdgeInsets.all(t.spaceLg),
              decoration: BoxDecoration(
                color: _pressed
                    ? c.surfaceContainerHigh
                    : _hover && tappable
                        ? c.surfaceContainerHighest
                        : c.surface,
                borderRadius: BorderRadius.circular(t.radiusCard),
                border: Border.all(
                  color: _focused
                      ? c.primary
                      : _hover && tappable
                          ? c.outline
                          : c.outlineVariant,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(widget.title, style: context.text.titleMedium),
                            if (widget.subtitle != null) ...<Widget>[
                              const TTGap.xs(),
                              Text(
                                widget.subtitle!,
                                style: context.text.bodyMedium?.copyWith(
                                  color: c.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (widget.statusStyle != null && widget.statusLabel != null) ...<Widget>[
                        const TTGap.md(axis: Axis.horizontal),
                        TTStatusPill(
                          style: widget.statusStyle!,
                          label: widget.statusLabel!,
                        ),
                      ],
                    ],
                  ),
                  if (widget.details.isNotEmpty) ...<Widget>[
                    const TTGap.md(),
                    const Divider(),
                    const TTGap.xs(),
                    for (final line in widget.details)
                      Padding(
                        padding: EdgeInsets.only(top: t.spaceXs),
                        child: Text(
                          line,
                          style: context.text.bodyMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                  if (widget.footer != null) ...<Widget>[
                    const TTGap.md(),
                    widget.footer!,
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
