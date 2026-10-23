import 'package:flutter/material.dart';

import '../context_ext.dart';
import '../icons.dart';
import 'tt_gap.dart';

/// Detail hero grid (R2): one large cell + a 2×2 cluster, 8px gaps,
/// outer rounded-12, "show all" white pill pinned to the bottom end of the
/// last cell.
///
/// Images arrive as caller-built widgets (SVG snapshots, map tiles). Missing
/// cells (fewer than 5 images) render a themed placeholder so the grid keeps
/// its shape. The end-pinned action uses [AlignmentDirectional]/positioning
/// so it mirrors in RTL (sticky-side check).
class TTImageGrid extends StatelessWidget {
  const TTImageGrid({
    super.key,
    required this.images,
    required this.showAllLabel,
    this.onShowAll,
  });

  final List<Widget> images;
  final String showAllLabel;
  final VoidCallback? onShowAll;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    if (images.isEmpty) return const SizedBox.shrink();
    final rest = images.skip(1).take(4).toList();
    while (rest.length < 4) {
      rest.add(const _TTImagePlaceholder());
    }
    return AspectRatio(
      aspectRatio: 2,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(t.radiusCard),
        child: Stack(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(flex: 2, child: images.first),
                const TTGap.sm(axis: Axis.horizontal),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Expanded(child: rest[0]),
                            const TTGap.sm(axis: Axis.horizontal),
                            Expanded(child: rest[1]),
                          ],
                        ),
                      ),
                      const TTGap.sm(),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Expanded(child: rest[2]),
                            const TTGap.sm(axis: Axis.horizontal),
                            Expanded(child: rest[3]),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (onShowAll != null)
              PositionedDirectional(
                end: t.spaceMd,
                bottom: t.spaceMd,
                child: _TTShowAllButton(
                  label: showAllLabel,
                  onTap: onShowAll!,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TTImagePlaceholder extends StatelessWidget {
  const _TTImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      color: c.surfaceContainerHighest,
      child: Center(
        child: Icon(
          AppIcons.iconFor(AppIcons.photo, context),
          color: c.onSurfaceVariant,
          size: context.tokens.iconLg,
        ),
      ),
    );
  }
}

class _TTShowAllButton extends StatefulWidget {
  const _TTShowAllButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  State<_TTShowAllButton> createState() => _TTShowAllButtonState();
}

class _TTShowAllButtonState extends State<_TTShowAllButton> {
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
            color: _hover ? c.surfaceContainerHighest : c.surface,
            borderRadius: BorderRadius.circular(t.radiusPill),
            border: Border.all(color: c.outlineVariant),
            boxShadow: <BoxShadow>[context.shadows.float],
          ),
          child: Text(widget.label, style: context.text.labelLarge),
        ),
      ),
    );
  }
}
