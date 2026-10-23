import 'package:flutter/material.dart';

import '../context_ext.dart';
import '../icons.dart';
import 'tt_gap.dart';
import 'tt_icon_button.dart';

/// Section header (R1/R3): 22 w600 title at the row start, action at the row
/// end.
///
/// With [actionLabel] the end shows a grey "Show all" pill; with only
/// [onAction] it shows the circular next arrow (directional, RTL-mirrored);
/// with neither, just the title.
class TTSectionHeader extends StatelessWidget {
  const TTSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final action = actionLabel == null
        ? (onAction == null
            ? null
            : TTIconCircleButton(icon: AppIcons.next, onPressed: onAction))
        : _TTShowAllPill(label: actionLabel!, onTap: onAction);
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(title, style: context.text.headlineLarge),
        ),
        if (action != null) const TTGap.md(axis: Axis.horizontal),
        if (action != null) action,
      ],
    );
  }
}

class _TTShowAllPill extends StatefulWidget {
  const _TTShowAllPill({required this.label, required this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  State<_TTShowAllPill> createState() => _TTShowAllPillState();
}

class _TTShowAllPillState extends State<_TTShowAllPill> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.tokens;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: InkWell(
        borderRadius: BorderRadius.circular(t.radiusPill),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: t.motionMicro,
          curve: t.curve,
          padding: EdgeInsets.symmetric(
            horizontal: t.spaceLg,
            vertical: t.spaceSm,
          ),
          decoration: BoxDecoration(
            color: _hover ? c.outlineVariant : c.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(t.radiusPill),
          ),
          child: Text(
            widget.label,
            style: context.text.labelLarge?.copyWith(color: c.onSurface),
          ),
        ),
      ),
    );
  }
}
