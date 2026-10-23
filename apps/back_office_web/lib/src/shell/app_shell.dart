import 'package:core/core.dart';
import 'package:data/data.dart';
import 'package:fleet_ui/fleet_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data_providers.dart';
import '../prefs.dart';
import '../providers.dart';
import '../router.dart' show AppRoutes, isRouteAllowed, routeRoles;
import 'nav_targets.dart';

/// True for top-level list pages (dashboard, tower, masters lists) where the
/// shell renders the centered search pill row. Detail routes, /design,
/// /login, /mfa and error pages render navigation only.
bool _isListPage(String location) => const [
      AppRoutes.dashboard,
      AppRoutes.controlTower,
      AppRoutes.customers,
      AppRoutes.depots,
      AppRoutes.products,
      AppRoutes.drivers,
      AppRoutes.vehicles,
    ].contains(location);

/// Airbnb-style back-office shell (P1b): [TTTopNav] with Today / Fleet /
/// Customers / Menu tabs (role-filtered), a centered [TTSearchPill] quick-nav
/// row on list pages, and a globe + bell + profile cluster at the row end.
/// Menu opens the profile-menu-style sheet (Control Tower / Depots /
/// Products / Drivers / Design). Demo controls (role switcher) live ONLY
/// inside the profile menu (demo builds).
///
/// No NavigationRail, no breadcrumbs; detail screens render their own back
/// arrow + H1. Styling ONLY via context.colors/text/status/tokens/shadows.
class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    final strings = ShellStrings.fromL10n(context.l10n);
    final role = session?.role;
    final tabs = buildTopTabs(strings)
        .where((t) => role == null || t.roles.contains(role))
        .toList();
    final entries = buildMenuEntries(strings)
        .where((e) => role == null || e.roles.contains(role))
        .toList();
    final location = GoRouterState.of(context).uri.path;
    var selected = 0;
    for (var i = 0; i < tabs.length; i++) {
      final path = tabs[i].path;
      if (path != null &&
          (location == path || location.startsWith('$path/'))) {
        selected = i;
      }
    }
    final menuIndex = tabs.indexWhere((t) => t.path == null);
    if (menuIndex >= 0) {
      for (final e in entries) {
        if (location == e.path || location.startsWith('${e.path}/')) {
          selected = menuIndex;
        }
      }
    }
    final alerts = ref.watch(kpisProvider).valueOrNull?.alerts.length ?? 0;
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide =
            constraints.maxWidth >= context.tokens.breakpointTablet;
        return Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TTTopNav(
                tabs: [
                  for (final t in tabs)
                    TTNavTabData(label: t.label, icon: t.icon),
                ],
                selectedIndex: selected,
                onSelect: (index) {
                  final path = tabs[index].path;
                  if (path != null) {
                    context.go(path);
                  } else {
                    _openMenu(context, strings, entries);
                  }
                },
                trailing: _TrailingCluster(
                  strings: strings,
                  session: session,
                  alerts: alerts,
                ),
              ),
              if (wide && _isListPage(location))
                _ShellSearchRow(strings: strings, role: role),
              Expanded(child: child),
            ],
          ),
        );
      },
    );
  }
}

void _openMenu(
  BuildContext context,
  ShellStrings strings,
  List<NavTarget> entries,
) {
  showTTGrabberSheet(
    context,
    Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(strings.menu, style: context.text.titleLarge),
        const TTGap.md(),
        for (final e in entries)
          TTListTile(
            leading: Icon(AppIcons.iconFor(e.icon, context)),
            title: e.label,
            trailing: Icon(AppIcons.iconFor(AppIcons.next, context)),
            onTap: () {
              Navigator.of(context).pop();
              context.go(e.path);
            },
          ),
        const TTGap.md(),
      ],
    ),
  );
}

/// Centered quick-nav pill row (wide list pages): Drivers / Vehicles /
/// Customers segments navigate; the accent button goes to the first.
class _ShellSearchRow extends StatelessWidget {
  const _ShellSearchRow({required this.strings, required this.role});

  final ShellStrings strings;
  final Role? role;

  @override
  Widget build(BuildContext context) {
    final segments = <TTSearchSegment>[];
    final routes = <String>[];
    void add(String label, String route) {
      if (role == null || (routeRoles[route]?.contains(role) ?? true)) {
        segments.add(
            TTSearchSegment(label: label, value: strings.allLabel));
        routes.add(route);
      }
    }

    add(strings.searchHintDrivers, AppRoutes.drivers);
    add(strings.searchHintVehicles, AppRoutes.vehicles);
    add(strings.searchHintCustomers, AppRoutes.customers);
    if (segments.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.tokens.spaceSm),
      child: TTSearchPill(
        segments: segments,
        searchLabel: strings.searchHint,
        onTapSegment: (index) => context.go(routes[index]),
        onSearch: () => context.go(routes.first),
      ),
    );
  }
}

class _TrailingCluster extends ConsumerWidget {
  const _TrailingCluster({
    required this.strings,
    required this.session,
    required this.alerts,
  });

  final ShellStrings strings;
  final Session? session;
  final int alerts;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = ref.watch(localeProvider);
    final arabic = locale.languageCode == 'ar';
    final role = session?.role;
    final canTower =
        role != null && isRouteAllowed(AppRoutes.controlTower, role);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TTIconCircleButton(
          icon: AppIcons.language,
          tooltip: arabic ? l10n.langEnglish : l10n.langArabic,
          semanticLabel: arabic ? l10n.langEnglish : l10n.langArabic,
          onPressed: () => _toggleLocale(ref, locale),
        ),
        const TTGap.sm(axis: Axis.horizontal),
        TTIconCircleButton(
          icon: AppIcons.bell,
          badgeCount: alerts,
          tooltip: l10n.shell_notifications,
          semanticLabel: l10n.shell_notifications,
          onPressed:
              canTower ? () => context.go(AppRoutes.controlTower) : null,
        ),
        const TTGap.sm(axis: Axis.horizontal),
        TTProfileMenuButton(
          avatarLabel: _initials(session?.displayName),
          sheetTitle: strings.profile,
          profileLabel: session?.displayName ?? strings.profile,
          themeMode: ref.watch(themeModeProvider),
          onTheme: (mode) => _setTheme(ref, mode),
          lightLabel: l10n.themeLight,
          darkLabel: l10n.themeDark,
          systemLabel: l10n.themeSystem,
          locale: locale,
          onLocale: (next) => _setLocale(ref, next),
          englishLabel: l10n.langEnglish,
          arabicLabel: l10n.langArabic,
          roleEntries: AppFlags.isDemoBuild
              ? [
                  for (final r in Role.values)
                    TTMenuRole(value: r.name, label: roleLabel(r, l10n)),
                ]
              : const [],
          currentRole: role?.name ?? '',
          onRole: (value) => _switchRole(ref, Role.values.byName(value)),
          demoRoleLabel: strings.demoRole,
          signOutLabel: strings.signOut,
          onSignOut: () => _signOut(ref),
        ),
        const TTGap.sm(axis: Axis.horizontal),
      ],
    );
  }
}

String _initials(String? displayName) {
  final parts = (displayName ?? '').split(' ').where((p) => p.isNotEmpty);
  return parts.take(2).map((p) => p.substring(0, 1)).join();
}

void _signOut(WidgetRef ref) {
  ref.read(sessionPendingMfaProvider.notifier).state = true;
  ref.read(sessionProvider.notifier).state = null;
}

Future<void> _setLocale(WidgetRef ref, Locale locale) async {
  ref.read(localeProvider.notifier).state = locale;
  final prefs = await SharedPreferences.getInstance();
  await AppPrefs(prefs).saveLocale(locale);
}

Future<void> _toggleLocale(WidgetRef ref, Locale current) async {
  await _setLocale(
    ref,
    current.languageCode == 'ar' ? const Locale('en') : const Locale('ar'),
  );
}

Future<void> _setTheme(WidgetRef ref, ThemeMode mode) async {
  ref.read(themeModeProvider.notifier).state = mode;
  final prefs = await SharedPreferences.getInstance();
  await AppPrefs(prefs).saveTheme(mode);
}

void _switchRole(WidgetRef ref, Role? role) {
  final current = ref.read(sessionProvider);
  if (role == null || current == null) return;
  ref.read(sessionProvider.notifier).state = Session(
    userId: current.userId,
    displayName: current.displayName,
    role: role,
    driverId: current.driverId,
  );
}
