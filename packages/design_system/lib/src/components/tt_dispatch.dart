import 'dart:async';

import 'package:flutter/material.dart';

import '../context_ext.dart';
import '../icons.dart';
import 'tt_button.dart';
import 'tt_gap.dart';

/// One dispatch match candidate: localized title + subtitle + optional
/// score label (e.g. distance/ETA) and note.
@immutable
class TTMatchCandidate {
  const TTMatchCandidate({required this.title, required this.subtitle, this.scoreLabel, this.note});

  final String title;
  final String subtitle;
  final String? scoreLabel;
  final String? note;
}

/// Dispatch match column (R3 §6): one column of selectable candidates with
/// a header. Selected state uses the primary border + tint (theme-only).
class TTMatchColumn extends StatelessWidget {
  const TTMatchColumn({
    super.key,
    required this.title,
    required this.candidates,
    required this.selectedIndex,
    required this.onSelect,
    this.hint,
  });

  final String title;
  final List<TTMatchCandidate> candidates;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(title, style: context.text.titleMedium),
        if (hint != null) ...<Widget>[
          const TTGap.xs(),
          Text(
            hint!,
            style: context.text.bodySmall?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ],
        const TTGap.md(),
        for (var i = 0; i < candidates.length; i++) ...<Widget>[
          if (i > 0) const TTGap.sm(),
          _TTMatchOption(
            candidate: candidates[i],
            selected: i == selectedIndex,
            onTap: () => onSelect(i),
          ),
        ],
      ],
    );
  }
}

class _TTMatchOption extends StatefulWidget {
  const _TTMatchOption({required this.candidate, required this.selected, required this.onTap});

  final TTMatchCandidate candidate;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_TTMatchOption> createState() => _TTMatchOptionState();
}

class _TTMatchOptionState extends State<_TTMatchOption> {
  bool _hover = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.tokens;
    return Semantics(
      button: true,
      selected: widget.selected,
      child: Focus(
        onFocusChange: (v) => setState(() => _focused = v),
        child: MouseRegion(
          onEnter: (_) => setState(() => _hover = true),
          onExit: (_) => setState(() => _hover = false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: widget.onTap,
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: t.motionMicro,
              curve: t.curve,
              padding: EdgeInsets.all(t.spaceLg),
              decoration: BoxDecoration(
                color: widget.selected
                    ? c.primaryContainer
                    : _hover
                        ? c.surfaceContainerHighest
                        : c.surface,
                borderRadius: BorderRadius.circular(t.radiusCard),
                border: Border.all(
                  color: _focused || widget.selected ? c.primary : c.outlineVariant,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    widget.selected
                        ? AppIcons.iconFor(AppIcons.synced, context)
                        : AppIcons.iconFor(AppIcons.truck, context),
                    color: widget.selected ? c.onPrimaryContainer : c.onSurfaceVariant,
                    size: t.iconMd,
                  ),
                  const TTGap.md(axis: Axis.horizontal),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(widget.candidate.title, style: context.text.titleSmall),
                        Text(
                          widget.candidate.subtitle,
                          style: context.text.bodySmall?.copyWith(
                            color: c.onSurfaceVariant,
                          ),
                        ),
                        if (widget.candidate.note != null)
                          Text(
                            widget.candidate.note!,
                            style: context.text.bodySmall,
                          ),
                      ],
                    ),
                  ),
                  if (widget.candidate.scoreLabel != null) ...<Widget>[
                    const TTGap.md(axis: Axis.horizontal),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: t.spaceMd,
                        vertical: t.spaceXs,
                      ),
                      decoration: BoxDecoration(
                        color: c.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(t.radiusPill),
                      ),
                      child: Text(
                        widget.candidate.scoreLabel!,
                        style: context.text.labelSmall,
                      ),
                    ),
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

/// One validation check row: localized label + optional detail + outcome.
@immutable
class TTValidationCheck {
  const TTValidationCheck({required this.label, this.detail, required this.passed});

  final String label;
  final String? detail;
  final bool passed;
}

/// Dispatch validation sheet (R3 §6): check rows animate in one by one
/// (staggered [AppTokens.motionMicro] steps, [AppTokens.motionStandard]
/// fades). Confirm enables only when every check passes.
class TTValidationSheet extends StatelessWidget {
  const TTValidationSheet({
    super.key,
    required this.title,
    required this.checks,
    this.summary,
    required this.confirmLabel,
    this.onConfirm,
    this.cancelLabel,
    this.onCancel,
  });

  final String title;
  final List<TTValidationCheck> checks;
  final String? summary;
  final String confirmLabel;

  /// Display-only usages (catalogue, RTL smoke) omit [onConfirm]; the
  /// confirm button stays enabled only when every check passes.
  final VoidCallback? onConfirm;
  final String? cancelLabel;
  final VoidCallback? onCancel;

  bool get _allPassed => checks.every((check) => check.passed);

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(title, style: context.text.titleLarge),
        if (summary != null) ...<Widget>[
          const TTGap.xs(),
          Text(
            summary!,
            style: context.text.bodyMedium?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ],
        const TTGap.md(),
        for (var i = 0; i < checks.length; i++)
          _TTAnimatedCheckRow(
            check: checks[i],
            delay: t.motionMicro * (i + 1),
          ),
        const TTGap.lg(),
        TTButton(
          label: confirmLabel,
          onPressed: _allPassed ? onConfirm : null,
        ),
        if (cancelLabel != null) ...<Widget>[
          const TTGap.sm(),
          TTButton(
            label: cancelLabel!,
            variant: TTButtonVariant.tertiary,
            onPressed: onCancel ?? () => Navigator.of(context).pop(),
          ),
        ],
      ],
    );
  }
}

class _TTAnimatedCheckRow extends StatefulWidget {
  const _TTAnimatedCheckRow({required this.check, required this.delay});

  final TTValidationCheck check;
  final Duration delay;

  @override
  State<_TTAnimatedCheckRow> createState() => _TTAnimatedCheckRowState();
}

class _TTAnimatedCheckRowState extends State<_TTAnimatedCheckRow> {
  bool _visible = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(widget.delay, () {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final s = context.status;
    final fg = widget.check.passed ? s.completed : s.critical;
    return AnimatedOpacity(
      opacity: _visible ? 1 : 0,
      duration: t.motionStandard,
      curve: t.curve,
      child: AnimatedSlide(
        offset: _visible ? Offset.zero : const Offset(0, 0.3),
        duration: t.motionStandard,
        curve: t.curve,
        child: Padding(
          padding: EdgeInsets.only(bottom: t.spaceSm),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: t.spaceLg,
              vertical: t.spaceMd,
            ),
            decoration: BoxDecoration(
              color: widget.check.passed ? s.completedBg : s.criticalBg,
              borderRadius: BorderRadius.circular(t.radiusCard),
            ),
            child: Row(
              children: <Widget>[
                Icon(
                  AppIcons.iconFor(
                    widget.check.passed ? AppIcons.check : AppIcons.close,
                    context,
                  ),
                  color: fg,
                  size: t.iconMd,
                ),
                const TTGap.md(axis: Axis.horizontal),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(widget.check.label, style: context.text.titleSmall),
                      if (widget.check.detail != null)
                        Text(widget.check.detail!, style: context.text.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Shows a [TTValidationSheet] in a themed modal grabber sheet.
Future<T?> showTTValidationSheet<T>(
  BuildContext context, {
  required String title,
  required List<TTValidationCheck> checks,
  String? summary,
  required String confirmLabel,
  required VoidCallback? onConfirm,
  String? cancelLabel,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    builder: (_) => SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(context.tokens.spaceLg),
        child: TTValidationSheet(
          title: title,
          checks: checks,
          summary: summary,
          confirmLabel: confirmLabel,
          onConfirm: onConfirm,
          cancelLabel: cancelLabel,
          onCancel: () => Navigator.of(context).pop(),
        ),
      ),
    ),
  );
}
