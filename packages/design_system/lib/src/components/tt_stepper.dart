import 'package:flutter/material.dart';

import '../context_ext.dart';
import '../icons.dart';

/// Guided stepper (Start Day 1-2-3, Loading 4 steps). Direction-aware:
/// progress flows start→end (mirrors in RTL automatically via Row).
class TTStepper extends StatelessWidget {
  const TTStepper({
    super.key,
    required this.steps,
    required this.current,
  });

  final List<String> steps;
  final int current;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(
      children: [
        for (var i = 0; i < steps.length; i++) ...[
          _Dot(
            done: i < current,
            active: i == current,
            index: i,
          ),
          if (i < steps.length - 1)
            Expanded(
              child: Container(
                height: context.tokens.spaceXs / 2,
                color: i < current ? c.primary : c.outlineVariant,
              ),
            ),
        ],
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.done, required this.active, required this.index});
  final bool done;
  final bool active;
  final int index;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final bg = done || active ? c.primary : c.surfaceContainerHighest;
    final fg = done || active ? c.onPrimary : c.onSurfaceVariant;
    return Semantics(
      label: 'Step ${index + 1}',
      child: CircleAvatar(
        backgroundColor: bg,
        foregroundColor: fg,
        radius: context.tokens.iconMd,
        child: done
            ? Icon(
                AppIcons.iconFor(AppIcons.check, context),
                size: context.tokens.iconSm,
              )
            : Text('${index + 1}', style: context.text.labelMedium),
      ),
    );
  }
}
