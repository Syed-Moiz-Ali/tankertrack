import 'package:flutter/material.dart';

import '../context_ext.dart';
import 'tt_button.dart';
import 'tt_gap.dart';

/// Sticky booking/action card (R2): bordered r12 surface with float shadow.
/// Callers pass any content (price line, date fields, CTA).
class TTStickyActionCard extends StatelessWidget {
  const TTStickyActionCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final c = context.colors;
    return Container(
      padding: EdgeInsets.all(t.spaceLg),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(t.radiusCard),
        border: Border.all(color: c.outline),
        boxShadow: <BoxShadow>[context.shadows.float],
      ),
      child: child,
    );
  }
}

/// Sticky bottom bar (mobile detail pages): top hairline, safe-area aware,
/// optional [number]/[caption] column plus CTA.
///
/// Either side may be omitted: number-only and CTA-only bars both render.
class TTStickyBottomBar extends StatelessWidget {
  const TTStickyBottomBar({
    super.key,
    this.number,
    this.caption,
    this.ctaLabel,
    this.onCta,
  });

  final String? number;
  final String? caption;
  final String? ctaLabel;
  final VoidCallback? onCta;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final c = context.colors;
    final info = (number != null || caption != null)
        ? Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (number != null)
                  Text(number!, style: context.text.titleLarge),
                if (caption != null)
                  Text(
                    caption!,
                    style: context.text.bodySmall?.copyWith(
                      color: c.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          )
        : null;
    final cta = ctaLabel == null
        ? null
        : TTButton(label: ctaLabel!, onPressed: onCta, expanded: info == null);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const Divider(),
        SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.all(t.spaceLg),
            child: info == null
                ? (cta ?? const SizedBox.shrink())
                : Row(
                    children: <Widget>[
                      info,
                      if (cta != null)
                        const TTGap.lg(axis: Axis.horizontal),
                      if (cta != null) Expanded(child: cta),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}
