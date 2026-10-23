import 'package:flutter/material.dart';

import '../context_ext.dart';
import 'tt_button.dart';
import 'tt_gap.dart';

/// Show a themed dialog (shape/type from DialogTheme; callers pass content).
Future<T?> showTTDialog<T>({
  required BuildContext context,
  required String title,
  required Widget content,
  List<Widget>? actions,
}) {
  return showDialog<T>(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(title),
      content: content,
      actions: actions,
    ),
  );
}

/// Show a themed bottom sheet (mobile-first; drag handle from theme).
Future<T?> showTTSheet<T>({
  required BuildContext context,
  required Widget child,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    builder: (_) => SafeArea(child: child),
  );
}

/// Reason-code picker. Every override / reassign / adjustment opens this
/// (FRS §23). Options are bilingual labels supplied by the caller
/// (domain ReasonCode list, already localized).
class ReasonDialog extends StatefulWidget {
  const ReasonDialog({
    super.key,
    required this.title,
    required this.options,
    required this.noteHint,
    required this.confirmLabel,
  });

  final String title;
  final List<String> options;
  final String noteHint;
  final String confirmLabel;

  static Future<ReasonResult?> show(
    BuildContext context, {
    required String title,
    required List<String> options,
    required String noteHint,
    required String confirmLabel,
  }) {
    return showTTDialog<ReasonResult>(
      context: context,
      title: title,
      content: ReasonDialog(
        title: title,
        options: options,
        noteHint: noteHint,
        confirmLabel: confirmLabel,
      ),
    );
  }

  @override
  State<ReasonDialog> createState() => _ReasonDialogState();
}

class ReasonResult {
  ReasonResult({required this.reason, this.note});
  final String reason;
  final String? note;
}

class _ReasonDialogState extends State<ReasonDialog> {
  String? _selected;
  final _note = TextEditingController();

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RadioGroup<String>(
          groupValue: _selected,
          onChanged: (v) => setState(() => _selected = v),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final o in widget.options)
                RadioListTile<String>(value: o, title: Text(o)),
            ],
          ),
        ),
        const TTGap.md(),
        TextField(
          controller: _note,
          maxLines: 2,
          decoration: InputDecoration(hintText: widget.noteHint),
        ),
        const TTGap.md(),
        TTButton(
          label: widget.confirmLabel,
          onPressed: _selected == null
              ? null
              : () => Navigator.of(context).pop(
                    ReasonResult(reason: _selected!, note: _note.text),
                  ),
        ),
      ],
    );
  }
}

/// Conflict resolution sheet (offline sync reject — theirs/yours).
/// Never silently overwrites; the resolution itself is audited.
class ConflictSheet extends StatelessWidget {
  const ConflictSheet({
    super.key,
    required this.title,
    required this.serverTitle,
    required this.serverDescription,
    required this.localTitle,
    required this.localDescription,
    required this.keepServerLabel,
    required this.keepLocalLabel,
  });

  final String title;
  final String serverTitle;
  final String serverDescription;
  final String localTitle;
  final String localDescription;
  final String keepServerLabel;
  final String keepLocalLabel;

  /// Returns true = keep server, false = keep local, null = dismissed.
  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String serverTitle,
    required String serverDescription,
    required String localTitle,
    required String localDescription,
    required String keepServerLabel,
    required String keepLocalLabel,
  }) {
    return showTTSheet<bool>(
      context: context,
      child: ConflictSheet(
        title: title,
        serverTitle: serverTitle,
        serverDescription: serverDescription,
        localTitle: localTitle,
        localDescription: localDescription,
        keepServerLabel: keepServerLabel,
        keepLocalLabel: keepLocalLabel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Padding(
      padding: EdgeInsets.all(t.spaceLg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: context.text.titleLarge),
          const TTGap.md(),
          Text(serverTitle, style: context.text.titleSmall),
          Text(serverDescription, style: context.text.bodyMedium),
          const TTGap.md(),
          Text(localTitle, style: context.text.titleSmall),
          Text(localDescription, style: context.text.bodyMedium),
          const TTGap.lg(),
          TTButton(
            label: keepServerLabel,
            variant: TTButtonVariant.secondary,
            onPressed: () => Navigator.of(context).pop(true),
          ),
          const TTGap.sm(),
          TTButton(
            label: keepLocalLabel,
            onPressed: () => Navigator.of(context).pop(false),
          ),
        ],
      ),
    );
  }
}
