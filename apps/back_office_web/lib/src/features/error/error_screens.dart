import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// 403 screen (P1 contracts §1): thin [TTErrorState] wrapper. Strings and
/// back-home navigation arrive via params; the router wires l10n values and
/// `context.go(AppRoutes.home)`.
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
      body: TTErrorState(
        title: title,
        message: message,
        retryLabel: backHomeLabel,
        onRetry: onBackHome,
      ),
    );
  }
}

/// 404 screen (P1 contracts §1, via `errorBuilder`): same wrapper, plus the
/// attempted path shown as the report line.
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
      body: TTErrorState(
        title: title,
        message: message,
        retryLabel: backHomeLabel,
        onRetry: onBackHome,
        reportId: attemptedPath,
      ),
    );
  }
}
