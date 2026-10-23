import 'package:flutter/material.dart';

import '../context_ext.dart';
import '../icons.dart';
import 'tt_button.dart';
import 'tt_empty_state.dart';
import 'tt_error_state.dart';
import 'tt_gap.dart';

/// Grabber sheet content wrapper: top grabber handle + [child].
/// Sheet chrome (background, drag handle) comes from the BottomSheetTheme.
class TTGrabberSheet extends StatelessWidget {
  const TTGrabberSheet({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(t.spaceLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Container(
                width: t.spaceXxxl,
                height: t.spaceXs,
                decoration: BoxDecoration(
                  color: context.colors.outline,
                  borderRadius: BorderRadius.circular(t.radiusPill),
                ),
              ),
            ),
            const TTGap.md(),
            child,
          ],
        ),
      ),
    );
  }
}

/// Shows [child] in a themed modal grabber sheet (scroll-controlled so the
/// sheet sizes to tall content like the profile menu).
Future<T?> showTTGrabberSheet<T>(BuildContext context, Widget child) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    builder: (_) => SingleChildScrollView(
      child: TTGrabberSheet(child: child),
    ),
  );
}

/// Detail side sheet (R3 §6): header + scrollable content + optional
/// "Open full page" action. Presented at the inline end (auto-mirrors in
/// RTL) via [showTTSideSheet]; the shell wires the full-page route.
class TTSideSheet extends StatelessWidget {
  const TTSideSheet({
    super.key,
    required this.title,
    required this.child,
    this.openFullPageLabel,
    this.onOpenFullPage,
    this.onClose,
  });

  final String title;
  final Widget child;
  final String? openFullPageLabel;
  final VoidCallback? onOpenFullPage;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final c = context.colors;
    return Container(
      width: t.contentNarrow,
      decoration: BoxDecoration(
        color: c.surface,
        border: BorderDirectional(
          start: BorderSide(color: c.outlineVariant),
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(t.spaceLg),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(title, style: context.text.titleLarge),
                  ),
                  TTIconButton(
                    icon: Icon(AppIcons.iconFor(AppIcons.close, context)),
                    onPressed: onClose ?? () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(t.spaceLg),
                child: child,
              ),
            ),
            if (openFullPageLabel != null) ...<Widget>[
              const Divider(),
              Padding(
                padding: EdgeInsets.all(t.spaceLg),
                child: TTButton(
                  label: openFullPageLabel!,
                  variant: TTButtonVariant.tertiary,
                  onPressed: onOpenFullPage,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Presents a [TTSideSheet] sliding in from the inline end (mirrors in RTL).
Future<T?> showTTSideSheet<T>(
  BuildContext context, {
  required String title,
  required Widget child,
  String? openFullPageLabel,
  VoidCallback? onOpenFullPage,
}) {
  final rtl = Directionality.of(context) == TextDirection.rtl;
  final duration = context.tokens.motionStandard;
  final curve = context.tokens.curve;
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: true,
    barrierLabel: title,
    transitionDuration: duration,
    pageBuilder: (dialogContext, _, __) => Align(
      alignment: AlignmentDirectional.centerEnd,
      child: TTSideSheet(
        title: title,
        openFullPageLabel: openFullPageLabel,
        onOpenFullPage: onOpenFullPage,
        onClose: () => Navigator.of(dialogContext).pop(),
        child: child,
      ),
    ),
    transitionBuilder: (context, animation, _, child) {
      final slide = Tween<Offset>(
        begin: Offset(rtl ? -1 : 1, 0),
        end: Offset.zero,
      ).chain(CurveTween(curve: curve)).animate(animation);
      return SlideTransition(position: slide, child: child);
    },
  );
}

/// List + detail split pane (R3 §6): side-by-side on wide screens
/// (list 5 / detail 7), single pane below [AppTokens.breakpointTablet].
///
/// On narrow screens [detailPane] wins when [showDetail] is true, otherwise
/// [listPane] renders (back navigation is the shell's job).
class TTSplitView extends StatelessWidget {
  const TTSplitView({
    super.key,
    required this.listPane,
    this.detailPane,
    this.showDetail = true,
  });

  final Widget listPane;
  final Widget? detailPane;
  final bool showDetail;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= context.tokens.breakpointTablet;
        if (wide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(flex: 5, child: listPane),
              const VerticalDivider(width: 1),
              Expanded(flex: 7, child: detailPane ?? const SizedBox.shrink()),
            ],
          );
        }
        if (showDetail && detailPane != null) return detailPane!;
        return listPane;
      },
    );
  }
}

/// Companion state of a screen: empty / loading / error / success.
///
/// The shell owns *when* each state shows; this host only renders them.
/// Pass [demoLabels] + [onDemoSelect] to render the demo state switcher
/// (demo tooling only — never in production flows).
enum ScreenStateKind { empty, loading, error, success }

class ScreenStateHost extends StatelessWidget {
  const ScreenStateHost({
    super.key,
    required this.state,
    required this.emptyTitle,
    required this.emptyMessage,
    this.emptyActionLabel,
    this.onEmptyAction,
    required this.loadingLabel,
    required this.errorTitle,
    required this.errorMessage,
    required this.retryLabel,
    this.onRetry,
    required this.child,
    this.demoTitle,
    this.demoLabels,
    this.onDemoSelect,
  });

  final ScreenStateKind state;
  final String emptyTitle;
  final String emptyMessage;
  final String? emptyActionLabel;
  final VoidCallback? onEmptyAction;
  final String loadingLabel;
  final String errorTitle;
  final String errorMessage;
  final String retryLabel;

  /// Display-only usages (catalogue, RTL smoke) omit [onRetry].
  final VoidCallback? onRetry;
  final Widget child;
  final String? demoTitle;
  final Map<ScreenStateKind, String>? demoLabels;
  final ValueChanged<ScreenStateKind>? onDemoSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(child: _body(context)),
        if (demoLabels != null && onDemoSelect != null)
          _TTDemoSwitcher(
            title: demoTitle,
            labels: demoLabels!,
            current: state,
            onSelect: onDemoSelect!,
          ),
      ],
    );
  }

  Widget _body(BuildContext context) {
    return switch (state) {
      ScreenStateKind.empty => TTEmptyState(
          title: emptyTitle,
          message: emptyMessage,
          actionLabel: emptyActionLabel,
          onAction: onEmptyAction,
        ),
      ScreenStateKind.loading => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const CircularProgressIndicator(),
              const TTGap.md(),
              Text(loadingLabel, style: context.text.bodyMedium),
            ],
          ),
        ),
      ScreenStateKind.error => TTErrorState(
          title: errorTitle,
          message: errorMessage,
          retryLabel: retryLabel,
          onRetry: onRetry,
        ),
      ScreenStateKind.success => child,
    };
  }
}

class _TTDemoSwitcher extends StatelessWidget {
  const _TTDemoSwitcher({
    required this.title,
    required this.labels,
    required this.current,
    required this.onSelect,
  });

  final String? title;
  final Map<ScreenStateKind, String> labels;
  final ScreenStateKind current;
  final ValueChanged<ScreenStateKind> onSelect;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border(top: BorderSide(color: context.colors.outlineVariant)),
      ),
      padding: EdgeInsets.all(t.spaceMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (title != null) Text(title!, style: context.text.labelMedium),
          if (title != null) const TTGap.sm(),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                for (final entry in labels.entries) ...<Widget>[
                  ChoiceChip(
                    label: Text(entry.value),
                    selected: current == entry.key,
                    onSelected: (_) => onSelect(entry.key),
                  ),
                  const TTGap.sm(axis: Axis.horizontal),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Idle-timeout dialog: countdown message + "Stay signed in" + sign out.
///
/// The shell owns the 15-minute timer and ticks [countdownLabel]; this
/// dialog only renders it. Returns true = stay, false = sign out.
class TTIdleTimeoutDialog extends StatelessWidget {
  const TTIdleTimeoutDialog({
    super.key,
    required this.title,
    required this.countdownLabel,
    required this.stayLabel,
    required this.signOutLabel,
    this.onStay,
    this.onSignOut,
  });

  final String title;
  final String countdownLabel;
  final String stayLabel;
  final String signOutLabel;

  /// Display-only usages (catalogue, RTL smoke) omit both callbacks.
  final VoidCallback? onStay;
  final VoidCallback? onSignOut;

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String countdownLabel,
    required String stayLabel,
    required String signOutLabel,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        content: TTIdleTimeoutDialog(
          title: title,
          countdownLabel: countdownLabel,
          stayLabel: stayLabel,
          signOutLabel: signOutLabel,
          onStay: () => Navigator.of(dialogContext).pop(true),
          onSignOut: () => Navigator.of(dialogContext).pop(false),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Icon(
          AppIcons.iconFor(AppIcons.clock, context),
          size: context.tokens.iconLg,
          color: context.status.waiting,
        ),
        const TTGap.md(),
        Text(title, style: context.text.titleLarge, textAlign: TextAlign.center),
        const TTGap.sm(),
        Text(
          countdownLabel,
          style: context.text.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const TTGap.lg(),
        TTButton(label: stayLabel, onPressed: onStay),
        const TTGap.sm(),
        TTButton(
          label: signOutLabel,
          variant: TTButtonVariant.tertiary,
          onPressed: onSignOut,
        ),
      ],
    );
  }
}

/// About dialog: product message + licensed photo credits.
///
/// [photoCredits] names the licensed photo sources (R3 §8: photos only
/// licensed + credited). Rendered as secondary caption text.
class TTAboutDialog extends StatelessWidget {
  const TTAboutDialog({
    super.key,
    required this.title,
    required this.message,
    required this.photoCredits,
    required this.closeLabel,
    this.onClose,
  });

  final String title;
  final String message;
  final String photoCredits;
  final String closeLabel;
  final VoidCallback? onClose;

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    required String photoCredits,
    required String closeLabel,
  }) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        content: TTAboutDialog(
          title: title,
          message: message,
          photoCredits: photoCredits,
          closeLabel: closeLabel,
          onClose: () => Navigator.of(dialogContext).pop(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(title, style: context.text.titleLarge),
        const TTGap.sm(),
        Text(message, style: context.text.bodyMedium),
        const TTGap.md(),
        Text(
          photoCredits,
          style: context.text.bodySmall?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
        const TTGap.lg(),
        TTButton(
          label: closeLabel,
          variant: TTButtonVariant.secondary,
          onPressed: onClose ?? () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
