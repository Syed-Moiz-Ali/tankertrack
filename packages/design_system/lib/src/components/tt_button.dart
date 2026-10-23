import 'package:flutter/material.dart';

import 'tt_gap.dart';

/// Button variants. Look comes from the theme's button themes; screens pick
/// only [variant], never a style.
enum TTButtonVariant { primary, secondary, tertiary, destructive }

/// The one button screens may use. Sizing follows the active surface theme
/// (driver ≥56px, web 48px) via the theme's button themes.
class TTButton extends StatelessWidget {
  const TTButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = TTButtonVariant.primary,
    this.icon,
    this.expanded = true,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final TTButtonVariant variant;
  final Widget? icon;
  final bool expanded;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final child = loading
        ? const SizedBox.square(
            dimension: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : icon == null
            ? Text(label)
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  icon!,
                  const TTGap.sm(axis: Axis.horizontal),
                  Text(label),
                ],
              );
    final button = switch (variant) {
      TTButtonVariant.primary =>
        ElevatedButton(onPressed: loading ? null : onPressed, child: child),
      TTButtonVariant.secondary =>
        OutlinedButton(onPressed: loading ? null : onPressed, child: child),
      TTButtonVariant.tertiary =>
        TextButton(onPressed: loading ? null : onPressed, child: child),
      TTButtonVariant.destructive => ElevatedButton(
          onPressed: loading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Theme.of(context).colorScheme.onError,
          ),
          child: child,
        ),
    };
    if (!expanded) return button;
    return SizedBox(width: double.infinity, child: button);
  }
}

/// Theme-sized icon button (touch target from tokens).
class TTIconButton extends StatelessWidget {
  const TTIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.semanticLabel,
    this.tooltip,
  });

  final Widget icon;
  final VoidCallback? onPressed;
  final String? semanticLabel;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel ?? tooltip,
      child: IconButton(
        icon: icon,
        onPressed: onPressed,
        tooltip: tooltip,
      ),
    );
  }
}
