import 'package:fleet_ui/fleet_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n/l10n.dart';

import '../../providers.dart';
import '../../router.dart';

/// P0 post-login landing (complete screen): identity + role + links.
/// P3 replaces the body with the Today dashboard.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final session = ref.watch(sessionProvider);
    final name = session?.displayName ?? '';
    return SignedInScreen(
      greeting: l10n.loginSignedInAs(name),
      initials: _initials(name),
      roleLabel: session?.role.name ?? '',
      roleStyle: StatusStyle.active,
      catalogueLabel: l10n.loginOpenCatalogue,
      signOutLabel: l10n.loginSignOut,
      onOpenCatalogue: () => context.go(AppRoutes.design),
      onSignOut: () {
        ref.read(sessionProvider.notifier).state = null;
      },
    );
  }

  static String _initials(String name) {
    final parts = name.split(' ').where((w) => w.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    return parts.take(2).map((w) => w.substring(0, 1)).join();
  }
}
