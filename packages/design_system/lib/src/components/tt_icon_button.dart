import 'package:flutter/material.dart';

import '../context_ext.dart';
import '../icons.dart';

/// 40px circle button (R1 arrows / heart / row-end actions): theme surface
/// with a hairline border, optional count badge at the top end.
///
/// Size follows the token rhythm (`spaceXxxl − spaceSm` = 40). Hover lifts
/// the fill via [MouseRegion] + [AnimatedContainer] (motion tokens).
class TTIconCircleButton extends StatefulWidget {
  const TTIconCircleButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.badgeCount = 0,
    this.semanticLabel,
    this.tooltip,
  });

  final AppIcon icon;
  final VoidCallback? onPressed;
  final int badgeCount;
  final String? semanticLabel;
  final String? tooltip;

  @override
  State<TTIconCircleButton> createState() => _TTIconCircleButtonState();
}

class _TTIconCircleButtonState extends State<TTIconCircleButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.tokens;
    final size = t.spaceXxxl - t.spaceSm;
    final button = InkWell(
      customBorder: const CircleBorder(),
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: t.motionMicro,
        curve: t.curve,
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: _hover ? c.surfaceContainerHighest : c.surface,
          shape: BoxShape.circle,
          border: Border.all(color: c.outlineVariant),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Icon(
              AppIcons.iconFor(widget.icon, context),
              color: c.onSurfaceVariant,
              size: t.iconMd,
            ),
            if (widget.badgeCount > 0)
              PositionedDirectional(
                top: 0,
                end: 0,
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
                      '${widget.badgeCount}',
                      style: context.text.labelSmall?.copyWith(
                        color: c.onError,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
    final labeled = Semantics(
      button: true,
      label: widget.semanticLabel ?? widget.tooltip,
      child: button,
    );
    final withTooltip = widget.tooltip == null
        ? labeled
        : Tooltip(message: widget.tooltip!, child: labeled);
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: withTooltip,
    );
  }
}
