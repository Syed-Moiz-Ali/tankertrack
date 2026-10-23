import 'package:core/core.dart';
import 'package:data/data.dart';
import 'package:fleet_ui/fleet_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../prefs.dart';
import '../providers.dart';
import 'nav_targets.dart';

/// Responsive back-office shell (P1 contracts §1): [NavigationRail] on wide
/// screens (token tablet breakpoint), [Drawer] below it; TopBar with a
/// decorative search bar, notification bell with badge, language/theme
/// switches, role chip and (demo builds only) a role switcher; breadcrumbs
/// as a [TTChip] row; banner slot; content child.
///
/// Styling ONLY via context.colors/text/status/tokens + TT* components.
class AppShell extends ConsumerWidget {
  const AppShell({
    super.key,
    required this.child,
    this.banner,
    this.notificationCount = 0,
  });

  final Widget child;
  final Widget? banner;
  final int notificationCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    final strings = ShellStrings.fromL10n(context.l10n);
    final role = session?.role;
    final visible = buildNavTargets(strings)
        .where((target) => role == null || target.roles.contains(role))
        .toList();
    final location = GoRouterState.of(context).uri.path;
    var selected = 0;
    final labelsByPath = <String, String>{
      for (final target in visible) target.path: target.label,
    };
    for (var i = 0; i < visible.length; i++) {
      final path = visible[i].path;
      if (location == path || location.startsWith('$path/')) {
        selected = i;
      }
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide =
            constraints.maxWidth >= context.tokens.breakpointTablet;
        final content = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TopBar(
              strings: strings,
              session: session,
              wide: wide,
              notificationCount: notificationCount,
            ),
            _Breadcrumbs(location: location, labelsByPath: labelsByPath),
            if (banner != null) banner!,
            Expanded(child: child),
          ],
        );
        if (wide) {
          return Scaffold(
            body: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                NavigationRail(
                  selectedIndex: selected,
                  onDestinationSelected: (index) =>
                      context.go(visible[index].path),
                  labelType: NavigationRailLabelType.all,
                  destinations: [
                    for (final target in visible)
                      NavigationRailDestination(
                        icon: Icon(AppIcons.iconFor(target.icon, context)),
                        label: Text(target.label),
                      ),
                  ],
                ),
                Expanded(child: content),
              ],
            ),
          );
        }
        return Scaffold(
          drawer: Drawer(
            child: _DrawerContents(
              visible: visible,
              selected: selected,
              strings: strings,
              onNavigate: (path) => context.go(path),
              onSignOut: () => _signOut(ref),
            ),
          ),
          body: content,
        );
      },
    );
  }
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

class _TopBar extends ConsumerWidget {
  const _TopBar({
    required this.strings,
    required this.session,
    required this.wide,
    required this.notificationCount,
  });

  final ShellStrings strings;
  final Session? session;
  final bool wide;
  final int notificationCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final current = session;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.tokens.spaceLg,
        vertical: context.tokens.spaceSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              if (!wide) const DrawerButton(),
              Expanded(child: TTSearchBar(hint: strings.searchHint)),
              const TTGap.lg(axis: Axis.horizontal),
              Badge(
                isLabelVisible: notificationCount > 0,
                label: Text(notificationCount.toString()),
                child: TTIconButton(
                  icon: Icon(AppIcons.iconFor(AppIcons.bell, context)),
                  tooltip: l10n.shell_notifications,
                  onPressed: null,
                ),
              ),
              const TTGap.sm(axis: Axis.horizontal),
              TTIconButton(
                icon: Icon(AppIcons.iconFor(AppIcons.logout, context)),
                tooltip: strings.signOut,
                onPressed: () => _signOut(ref),
              ),
            ],
          ),
          const TTGap.sm(),
          Wrap(
            spacing: context.tokens.spaceSm,
            runSpacing: context.tokens.spaceSm,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              TTLanguageSwitch(
                current: ref.watch(localeProvider),
                englishLabel: l10n.langEnglish,
                arabicLabel: l10n.langArabic,
                compact: true,
                onChanged: (locale) => _setLocale(ref, locale),
              ),
              TTThemeSwitch(
                mode: ref.watch(themeModeProvider),
                lightLabel: l10n.themeLight,
                darkLabel: l10n.themeDark,
                systemLabel: l10n.themeSystem,
                onChanged: (mode) => _setTheme(ref, mode),
              ),
              if (current != null)
                StatusChip(
                  style: StatusStyle.active,
                  label: roleLabel(current.role, l10n),
                ),
              if (AppFlags.isDemoBuild && current != null)
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: context.tokens.contentNarrow,
                  ),
                  child: TTDropdown<Role>(
                    label: l10n.shell_demo_role,
                    value: current.role,
                    items: [
                      for (final r in Role.values)
                        TTDropdownItem(
                            value: r, label: roleLabel(r, l10n)),
                    ],
                    onChanged: (role) => _switchRole(ref, role),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Breadcrumbs extends StatelessWidget {
  const _Breadcrumbs({required this.location, required this.labelsByPath});

  final String location;
  final Map<String, String> labelsByPath;

  @override
  Widget build(BuildContext context) {
    final segments =
        location.split('/').where((s) => s.isNotEmpty).toList();
    if (segments.isEmpty) return const SizedBox.shrink();
    final crumbs = <String>[];
    var prefix = '';
    for (final s in segments) {
      prefix = '$prefix/$s';
      crumbs.add(labelsByPath[prefix] ?? s);
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.tokens.spaceLg),
      child: Wrap(
        spacing: context.tokens.spaceSm,
        runSpacing: context.tokens.spaceSm,
        children: [for (final c in crumbs) TTChip(label: c)],
      ),
    );
  }
}

class _DrawerContents extends StatelessWidget {
  const _DrawerContents({
    required this.visible,
    required this.selected,
    required this.strings,
    required this.onNavigate,
    required this.onSignOut,
  });

  final List<NavTarget> visible;
  final int selected;
  final ShellStrings strings;
  final void Function(String path) onNavigate;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (var i = 0; i < visible.length; i++)
          TTListTile(
            leading: Icon(AppIcons.iconFor(visible[i].icon, context)),
            title: visible[i].label,
            trailing: i == selected
                ? Icon(AppIcons.iconFor(AppIcons.check, context))
                : null,
            onTap: () {
              Navigator.of(context).pop();
              onNavigate(visible[i].path);
            },
          ),
        TTListTile(
          leading: Icon(AppIcons.iconFor(AppIcons.logout, context)),
          title: strings.signOut,
          onTap: () {
            Navigator.of(context).pop();
            onSignOut();
          },
        ),
      ],
    );
  }
}
