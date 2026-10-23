import 'package:flutter/material.dart';

import '../context_ext.dart';
import '../icons.dart';
import 'tt_button.dart';
import 'tt_gap.dart';

/// Friendly error state (never a red screen in demo).
class TTErrorState extends StatelessWidget {
  const TTErrorState({
    super.key,
    required this.title,
    required this.message,
    required this.retryLabel,
    this.onRetry,
    this.reportId,
  });

  final String title;
  final String message;
  final String retryLabel;
  final VoidCallback? onRetry;
  final String? reportId;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.tokens.spaceXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              AppIcons.iconFor(AppIcons.incident, context),
              size: context.tokens.iconLg,
              color: context.status.critical,
            ),
            const TTGap.md(),
            Text(title, style: context.text.titleMedium),
            const TTGap.sm(),
            Text(
              message,
              style: context.text.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (reportId != null) const TTGap.sm(),
            if (reportId != null)
              Text(reportId!, style: context.text.bodySmall),
            const TTGap.md(),
            TTButton(
              label: retryLabel,
              variant: TTButtonVariant.secondary,
              expanded: false,
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}

/// Toast via SnackBar (floating, themed).
void showTTToast(
  BuildContext context, {
  required String message,
  String? actionLabel,
  VoidCallback? onAction,
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        action: actionLabel == null
            ? null
            : SnackBarAction(label: actionLabel, onPressed: onAction ?? () {}),
      ),
    );
}
