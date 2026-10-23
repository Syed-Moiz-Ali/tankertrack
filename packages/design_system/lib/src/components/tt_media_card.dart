import 'package:flutter/material.dart';

import '../context_ext.dart';
import '../icons.dart';
import 'tt_gap.dart';
import 'tt_icon_button.dart';

/// White overlay pill pinned to the top start of a media image
/// ("Guest favourite", availability badges — R1).
class TTStatusOverlayBadge extends StatelessWidget {
  const TTStatusOverlayBadge({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final c = context.colors;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: t.spaceMd,
        vertical: t.spaceXs,
      ),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(t.radiusPill),
        boxShadow: <BoxShadow>[context.shadows.float],
      ),
      child: Text(
        label,
        style: context.text.labelMedium?.copyWith(color: c.onSurface),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

/// Fleet grid card (R1): 4:3 rounded image, overlay badge top-start, save pin
/// top-end, 15–16 w600 title, grey secondary line, bold figure.
///
/// Hover lifts the card via [MouseRegion] + [AnimatedContainer]
/// ([AppShadows.hover]). Needs a bounded width from the parent (grid cell).
///
/// NOTE: no heart glyph exists in [AppIcons] yet (icons slice owns that
/// file); the save pin uses [AppIcons.check] until `AppIcons.save` lands and
/// the main session swaps it.
class TTMediaCard extends StatefulWidget {
  const TTMediaCard({
    super.key,
    this.image,
    required this.title,
    this.subtitle,
    this.figure,
    this.badge,
    this.saved = false,
    this.onSave,
    this.onTap,
  });

  final Widget? image;
  final String title;
  final String? subtitle;
  final String? figure;
  final String? badge;
  final bool saved;
  final VoidCallback? onSave;
  final VoidCallback? onTap;

  @override
  State<TTMediaCard> createState() => _TTMediaCardState();
}

class _TTMediaCardState extends State<TTMediaCard> {
  static const double imageAspect = 4 / 3;

  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: InkWell(
        borderRadius: BorderRadius.circular(t.radiusCard),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: t.motionMicro,
          curve: t.curve,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(t.radiusCard),
            boxShadow: _hover ? <BoxShadow>[context.shadows.hover] : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AspectRatio(
                aspectRatio: imageAspect,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(t.radiusCard),
                  child: Container(
                    // Filled image well: vector illustrations (transparent
                    // bg) read as intentional cards, not floating glyphs.
                    color: context.colors.surfaceContainerHighest,
                    child: Stack(
                      children: <Widget>[
                        Positioned.fill(
                          child: widget.image ?? const _TTMediaPlaceholder(),
                        ),
                        if (widget.badge != null)
                          PositionedDirectional(
                            top: t.spaceSm,
                            start: t.spaceSm,
                            child: TTStatusOverlayBadge(label: widget.badge!),
                          ),
                        if (widget.onSave != null)
                          PositionedDirectional(
                            top: t.spaceSm,
                            end: t.spaceSm,
                            child: TTIconCircleButton(
                              icon: AppIcons.heart,
                              onPressed: widget.onSave,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: t.spaceSm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      widget.title,
                      style: context.text.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (widget.subtitle != null)
                      Text(
                        widget.subtitle!,
                        style: context.text.bodyMedium?.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (widget.figure != null) const TTGap.xs(),
                    if (widget.figure != null)
                      Text(
                        widget.figure!,
                        style: context.text.titleSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TTMediaPlaceholder extends StatelessWidget {
  const _TTMediaPlaceholder();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      color: c.surfaceContainerHighest,
      child: Center(
        child: Icon(
          AppIcons.iconFor(AppIcons.truck, context),
          color: c.onSurfaceVariant,
          size: context.tokens.iconLg,
        ),
      ),
    );
  }
}
