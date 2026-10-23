import 'package:core/core.dart';
import 'package:data/data.dart';
import 'package:fleet_ui/fleet_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n/l10n.dart';

import '../../providers.dart';
import '../../routes.dart';
import 'auth_chrome.dart';

/// One workspace card: localized role label + home route after CONTINUE.
class _Workspace {
  const _Workspace({required this.role, required this.route});

  final Role role;
  final String route;
}

/// BO-04 Role Selection (Figma copy via `auth_role_*` + `role_*`):
/// workspace cards → CONTINUE sets the session role → dashboard.
///
/// Figma workspace names/descriptions ("Operations Manager — Full daily
/// operations", …) have no ARB keys — cards use the localized `role_*`
/// labels over the same four workspaces, in Figma order (return notes).
class RoleSelectScreen extends ConsumerStatefulWidget {
  const RoleSelectScreen({super.key});

  @override
  ConsumerState<RoleSelectScreen> createState() => _RoleSelectState();
}

class _RoleSelectState extends ConsumerState<RoleSelectScreen> {
  static const _options = [
    _Workspace(role: Role.dispatcher, route: AppRoutes.dashboard),
    _Workspace(role: Role.fleetController, route: AppRoutes.vehicles),
    _Workspace(role: Role.supervisor, route: AppRoutes.dashboard),
    _Workspace(role: Role.finance, route: AppRoutes.dashboard),
  ];

  late Role _selected;
  bool _touched = false;

  @override
  void initState() {
    super.initState();
    final current = ref.read(sessionProvider)?.role;
    _selected = _options.any((_Workspace o) => o.role == current)
        ? current!
        : Role.dispatcher;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final session = ref.watch(sessionProvider);
    final greeting = session == null
        ? l10n.auth_role_hint
        : l10n.loginSignedInAs(session.displayName);
    return AuthChrome(
      title: l10n.auth_role_title,
      subtitle: greeting,
      form: AuthDemoState(
        screenId: 'bo04',
        emptyTitle: l10n.bo04_empty,
        emptyMessage: l10n.mst_empty_message,
        loadingTitle: l10n.bo04_loading,
        errorTitle: l10n.bo04_error,
        retryLabel: l10n.mst_retry,
        successTitle: l10n.bo04_success,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final _Workspace option in _options) ...[
              _RoleCard(
                label: roleLabel(option.role, l10n),
                selected: _selected == option.role,
                onTap: () => setState(() {
                  _selected = option.role;
                  _touched = true;
                }),
              ),
              const TTGap.sm(),
            ],
            const TTGap.md(),
            TTButton(
              label: l10n.loginSignIn,
              onPressed: () {
                final current = ref.read(sessionProvider);
                // Keep the credential role unless the user picked a
                // different workspace card (demo role switch).
                if (_touched && current != null) {
                  ref.read(sessionProvider.notifier).state = Session(
                    userId: current.userId,
                    displayName: current.displayName,
                    role: _selected,
                    driverId: current.driverId,
                  );
                }
                ref.read(sessionRoleChosenProvider.notifier).state = true;
                final home = _options
                    .firstWhere(
                      (_Workspace o) => o.role == _selected,
                      orElse: () => _options.first,
                    )
                    .route;
                context.go(home);
              },
            ),
          ],
        ),
      ),
      footer: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [AuthLocaleRow()],
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TTCard(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            AppIcons.iconFor(
              selected ? AppIcons.check : AppIcons.user,
              context,
            ),
          ),
          const TTGap.sm(axis: Axis.horizontal),
          Expanded(
            child: Text(label, style: context.text.titleSmall),
          ),
        ],
      ),
    );
  }
}
