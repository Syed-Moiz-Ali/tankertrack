import 'package:flutter/material.dart';

import '../context_ext.dart';
import '../icons.dart';
import 'tt_gap.dart';

/// One step: localized label + optional caption.
@immutable
class TTStepData {
  const TTStepData({required this.label, this.caption});

  final String label;
  final String? caption;
}

/// Step progress (shift/inspection flows): dots + directional connectors +
/// labels with an animated theme progress bar.
///
/// Direction-aware: steps flow start→end (auto-mirrors in RTL). Progress
/// animates over [AppTokens.motionStandard] when [current] changes.
class TTStepProgress extends StatelessWidget {
  const TTStepProgress({super.key, required this.steps, required this.current});

  final List<TTStepData> steps;
  final int current;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final progress = steps.isEmpty ? 0.0 : (current + 1) / steps.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: progress.clamp(0.0, 1.0)),
          duration: t.motionStandard,
          curve: t.curve,
          builder: (context, value, _) => LinearProgressIndicator(value: value),
        ),
        const TTGap.md(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            for (var i = 0; i < steps.length; i++) ...<Widget>[
              if (i > 0)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: t.spaceLg),
                    child: Container(
                      height: t.spaceXs / 2,
                      color: i <= current
                          ? context.colors.primary
                          : context.colors.outlineVariant,
                    ),
                  ),
                ),
              _TTStepDot(
                step: steps[i],
                index: i,
                done: i < current,
                active: i == current,
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _TTStepDot extends StatelessWidget {
  const _TTStepDot({required this.step, required this.index, required this.done, required this.active});

  final TTStepData step;
  final int index;
  final bool done;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.tokens;
    final bg = done || active ? c.primary : c.surfaceContainerHighest;
    final fg = done || active ? c.onPrimary : c.onSurfaceVariant;
    return Semantics(
      label: step.label,
      child: SizedBox(
        width: t.spaceXxxl * 2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AnimatedContainer(
              duration: t.motionMicro,
              curve: t.curve,
              width: t.spaceXl,
              height: t.spaceXl,
              decoration: BoxDecoration(
                color: bg,
                shape: BoxShape.circle,
                border: active ? Border.all(color: c.primary) : null,
              ),
              child: Center(
                child: done
                    ? Icon(
                        AppIcons.iconFor(AppIcons.check, context),
                        color: fg,
                        size: t.iconSm,
                      )
                    : Text(
                        '${index + 1}',
                        style: context.text.labelMedium?.copyWith(color: fg),
                      ),
              ),
            ),
            const TTGap.xs(),
            Text(
              step.label,
              style: (active ? context.text.titleSmall : context.text.bodySmall)
                  ?.copyWith(
                color: active ? c.onSurface : c.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (step.caption != null)
              Text(
                step.caption!,
                style: context.text.bodySmall?.copyWith(
                  color: c.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      ),
    );
  }
}
