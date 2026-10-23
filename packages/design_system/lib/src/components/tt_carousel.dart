import 'package:flutter/material.dart';

import '../context_ext.dart';
import '../icons.dart';
import 'tt_gap.dart';
import 'tt_icon_button.dart';

/// Horizontal snap carousel (R1 dashboard sections): fixed-[itemWidth]
/// children, hover-revealed arrows overlaid at the row ends.
///
/// Arrows use [PositionedDirectional] + directional [AppIcons] so both the
/// placement and the glyphs mirror in RTL; forward always advances toward
/// later children in either direction.
class TTCarousel extends StatefulWidget {
  const TTCarousel({super.key, required this.children, required this.itemWidth});

  final List<Widget> children;
  final double itemWidth;

  @override
  State<TTCarousel> createState() => _TTCarouselState();
}

class _TTCarouselState extends State<TTCarousel> {
  late final ScrollController _controller = ScrollController();
  bool _hover = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _step(int direction) {
    if (!_controller.hasClients) return;
    final step = widget.itemWidth + context.tokens.spaceMd;
    final target = (_controller.offset + direction * step)
        .clamp(_controller.position.minScrollExtent,
            _controller.position.maxScrollExtent)
        .toDouble();
    _controller.animateTo(
      target,
      duration: context.tokens.motionStandard,
      curve: context.tokens.curve,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    if (widget.children.isEmpty) return const SizedBox.shrink();
    // Touch-first viewports swipe; arrow buttons are a desktop affordance.
    return LayoutBuilder(
      builder: (context, constraints) {
        final showArrows =
            constraints.maxWidth >= t.breakpointTablet;
        return MouseRegion(
          onEnter: (_) => setState(() => _hover = true),
          onExit: (_) => setState(() => _hover = false),
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                controller: _controller,
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    for (var i = 0; i < widget.children.length; i++) ...<Widget>[
                      SizedBox(
                        width: widget.itemWidth,
                        child: widget.children[i],
                      ),
                      if (i < widget.children.length - 1)
                        const TTGap.md(axis: Axis.horizontal),
                    ],
                  ],
                ),
              ),
              if (showArrows && widget.children.length > 1)
                PositionedDirectional(
                  start: t.spaceSm,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: _TTCarouselArrow(
                      visible: _hover,
                      icon: AppIcons.back,
                      onPressed: () => _step(-1),
                    ),
                  ),
                ),
              if (showArrows && widget.children.length > 1)
                PositionedDirectional(
                  end: t.spaceSm,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: _TTCarouselArrow(
                      visible: _hover,
                      icon: AppIcons.forward,
                      onPressed: () => _step(1),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _TTCarouselArrow extends StatelessWidget {
  const _TTCarouselArrow({
    required this.visible,
    required this.icon,
    required this.onPressed,
  });

  final bool visible;
  final AppIcon icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: visible ? 1 : 0.55,
      duration: context.tokens.motionMicro,
      child: TTIconCircleButton(icon: icon, onPressed: onPressed),
    );
  }
}
