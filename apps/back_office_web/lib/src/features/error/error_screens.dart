import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// 403 screen (P1 contracts §1, P1b card language): centered card with the
/// TankerTrack mark, H1, grey message and a pill back-home action. Strings
/// and back-home navigation arrive via params; the router wires l10n values
/// and `context.go(AppRoutes.home)`.
class ForbiddenScreen extends StatelessWidget {
  const ForbiddenScreen({
    super.key,
    required this.title,
    required this.message,
    required this.backHomeLabel,
    required this.onBackHome,
  });

  final String title;
  final String message;
  final String backHomeLabel;
  final VoidCallback onBackHome;

  @override
  Widget build(BuildContext context) {
    return TTScaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: context.tokens.contentNarrow),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(child: TTLogoMark()),
              const TTGap.lg(),
              Text(
                title,
                style: context.text.displaySmall,
                textAlign: TextAlign.center,
              ),
              const TTGap.sm(),
              Text(
                message,
                style: context.text.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const TTGap.lg(),
              TTButton(label: backHomeLabel, onPressed: onBackHome),
            ],
          ),
        ),
      ),
    );
  }
}

/// 404 screen (P1 contracts §1, via `errorBuilder`): same card language,
/// plus the attempted path shown as the report line.
class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({
    super.key,
    required this.title,
    required this.message,
    required this.backHomeLabel,
    required this.onBackHome,
    this.attemptedPath,
  });

  final String title;
  final String message;
  final String backHomeLabel;
  final VoidCallback onBackHome;
  final String? attemptedPath;

  @override
  Widget build(BuildContext context) {
    return TTScaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: context.tokens.contentNarrow),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(child: TTLogoMark()),
              const TTGap.lg(),
              Text(
                title,
                style: context.text.displaySmall,
                textAlign: TextAlign.center,
              ),
              const TTGap.sm(),
              Text(
                message,
                style: context.text.bodyMedium,
                textAlign: TextAlign.center,
              ),
              if (attemptedPath != null) const TTGap.sm(),
              if (attemptedPath != null)
                Text(
                  attemptedPath!,
                  style: context.text.bodySmall,
                  textAlign: TextAlign.center,
                ),
              const TTGap.lg(),
              TTButton(label: backHomeLabel, onPressed: onBackHome),
            ],
          ),
        ),
      ),
    );
  }
}
