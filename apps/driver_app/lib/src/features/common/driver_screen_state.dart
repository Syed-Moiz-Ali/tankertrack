import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// Companion-state status per screen (R3 contracts §3:
/// `<screen>_empty/_loading/_error/_success`).
enum DriverScreenStatus { empty, loading, error, success }

/// Local ScreenStateHost equivalent (driver slice owns it until the shared
/// ScreenStateHost lands in design_system via the ui-components slice, which
/// will replace this file's usages, not its call sites' copy).
///
/// Renders exactly one companion state: empty → [TTEmptyState], loading →
/// skeleton, error → [TTErrorState] with retry, success → [child].
/// Callers pass the screen's `<screen>_empty/_loading/_error/_success` ARB
/// copy (DR-02: `dr02_*`, DR-03: `dr03_*`).
class DriverScreenStateHost extends StatelessWidget {
  const DriverScreenStateHost({
    super.key,
    required this.status,
    required this.emptyTitle,
    required this.emptyMessage,
    required this.errorTitle,
    required this.errorMessage,
    required this.retryLabel,
    this.onRetry,
    this.successAnnouncement,
    required this.child,
  });

  final DriverScreenStatus status;
  final String emptyTitle;
  final String emptyMessage;
  final String errorTitle;
  final String errorMessage;
  final String retryLabel;
  final VoidCallback? onRetry;

  /// `<screen>_success` copy: announced to assistive tech when the content
  /// renders (never a visible literal — 08 §4).
  final String? successAnnouncement;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return switch (status) {
      DriverScreenStatus.empty => TTEmptyState(
          title: emptyTitle,
          message: emptyMessage,
        ),
      DriverScreenStatus.loading => const TTSkeletonList(),
      DriverScreenStatus.error => TTErrorState(
          title: errorTitle,
          message: errorMessage,
          retryLabel: retryLabel,
          onRetry: onRetry,
        ),
      DriverScreenStatus.success => Semantics(
          liveRegion: true,
          label: successAnnouncement,
          child: child,
        ),
    };
  }
}
