import 'dart:async';

import 'package:core/core.dart';
import 'package:data/data.dart';
import 'package:fleet_ui/fleet_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data_providers.dart';
import '../prefs.dart';
import '../providers.dart';
import '../router.dart' show AppRoutes, isRouteAllowed;
import '../ui/profile_sheet.dart';
import 'nav_targets.dart';

/// Idle timeout before the expiry dialog (contracts §1: 15 minutes).
const idleTimeoutMinutes = 15;

/// Expiry dialog countdown before automatic sign-out.
const idleCountdownSeconds = 60;

/// Single-tick constant: keeps [Duration] args identifier-based (08 §4).
const _oneSecond = 1;

/// R3 back-office shell (13 §5): slim design_system [TTTopBar] (Today /
/// Orders / Dispatch / Live / Fleet & people / More, role-filtered) +
/// compact command palette (Ctrl/⌘+K) + bell + profile menu (role, language,
/// theme, demo tools in demo builds only, About). No NavigationRail, no
/// breadcrumbs, no search pill (replaced by the palette); detail screens
/// render their own back arrow + H1. Styling ONLY via theme.
///
/// A 15-minute inactivity timer raises [TTIdleTimeoutDialog] (countdown +
/// Stay signed in) and signs out on expiry.
class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  Timer? _idleTimer;

  @override
  void dispose() {
    _idleTimer?.cancel();
    super.dispose();
  }

  void _armIdleTimer() {
    _idleTimer?.cancel();
    if (!ref.read(idleTimerEnabledProvider)) return;
    _idleTimer = Timer(
      Duration(minutes: idleTimeoutMinutes),
      _onIdleExpired,
    );
  }

  void _onIdleExpired() {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context);
    if (l10n == null || ref.read(sessionProvider) == null) return;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => _IdleCountdown(
        title: l10n.idle_title,
        message: (String seconds) => l10n.idle_message(seconds),
        stayLabel: l10n.idle_stay,
        signOutLabel: l10n.idle_signout,
        onStay: () {
          Navigator.of(context).pop();
          _armIdleTimer();
        },
        onSignOut: () {
          Navigator.of(context).pop();
          _signOut(ref);
        },
        onExpired: () => _signOut(ref),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider);
    final strings = ShellStrings.fromL10n(context.l10n);
    final role = session?.role;
    final tabs = resolveTopBarTabs(strings)
        .where((TopBarTab t) => role == null || t.roles.contains(role))
        .toList();
    final entries = buildMenuEntries(strings)
        .where((NavTarget e) => role == null || e.roles.contains(role))
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
    final moreIndex = tabs.indexWhere((TopBarTab t) => t.path == null);
    if (moreIndex >= 0) {
      for (final NavTarget e in entries) {
        if (location == e.path || location.startsWith('${e.path}/')) {
          selected = moreIndex;
        }
      }
    }
    final alerts = ref.watch(kpisProvider).valueOrNull?.alerts.length ?? 0;
    _armIdleTimer();
    return CommandShortcut(
      onCommand: () => _openPalette(context, strings),
      child: Listener(
        onPointerDown: (_) => _armIdleTimer(),
        child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TTTopBar(
                items: [
                  for (final TopBarTab tab in tabs)
                    TTTopBarItem(label: tab.label, icon: tab.icon),
                ],
                selectedIndex: selected,
                onSelect: (int index) {
                  final path = tabs[index].path;
                  if (path != null) {
                    context.go(path);
                  } else {
                    _openMenu(context, strings, entries);
                  }
                },
                commandHint: strings.commandHint,
                shortcutHint: strings.commandShortcut,
                onCommand: () => _openPalette(context, strings),
                hasNotifications: alerts > 0,
                notificationsLabel: context.l10n.shell_notifications,
                onNotifications: role != null &&
                        isRouteAllowed(AppRoutes.controlTower, role)
                    ? () => context.go(AppRoutes.controlTower)
                    : () {},
                profileLabel: _initials(session?.displayName),
                profileTooltip: strings.profile,
                onProfile: () => _openProfile(context, strings, session),
              ),
              Expanded(child: widget.child),
            ],
          ),
        ),
      ),
    );
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
          Text(strings.more, style: context.text.titleLarge),
          const TTGap.md(),
          for (final NavTarget e in entries)
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

  Future<void> _openPalette(BuildContext context, ShellStrings strings) async {
    final role = ref.read(sessionProvider)?.role;
    final targets = buildNavTargets(strings)
        .where((NavTarget t) => role == null || t.roles.contains(role))
        .toList();
    final items = [
      for (final NavTarget t in targets)
        TTCommandItem(title: t.label, subtitle: t.path, icon: t.icon),
    ];
    final picked = await showTTCommandPalette(
      context,
      hint: strings.commandHint,
      items: items,
      noResults: strings.commandNoResults,
      shortcutHint: strings.commandShortcut,
    );
    if (picked == null || !context.mounted) return;
    final index = items.indexOf(picked);
    if (index < 0) return;
    context.go(targets[index].path);
  }

  void _openProfile(
    BuildContext context,
    ShellStrings strings,
    Session? session,
  ) {
    final l10n = context.l10n;
    final locale = ref.watch(localeProvider);
    final role = session?.role;
    showTTProfileSheet(
      context: context,
      sheetTitle: strings.profile,
      profileLabel: session?.displayName ?? strings.profile,
      themeMode: ref.watch(themeModeProvider),
      onTheme: (ThemeMode mode) => _setTheme(ref, mode),
      lightLabel: l10n.themeLight,
      darkLabel: l10n.themeDark,
      systemLabel: l10n.themeSystem,
      locale: locale,
      onLocale: (Locale next) => _setLocale(ref, next),
      englishLabel: l10n.langEnglish,
      arabicLabel: l10n.langArabic,
      roleEntries: AppFlags.isDemoBuild
          ? [
              for (final Role r in Role.values)
                TTMenuRole(value: r.name, label: roleLabel(r, l10n)),
            ]
          : const [],
      currentRole: role?.name ?? '',
      onRole: (String value) => _switchRole(ref, Role.values.byName(value)),
      demoRoleLabel: strings.demoRole,
      signOutLabel: strings.signOut,
      onSignOut: () => _signOut(ref),
      aboutLabel: strings.about,
      onAbout: () => TTAboutDialog.show(
        context,
        title: l10n.about_title,
        message: l10n.loginSubtitle,
        photoCredits:
            '${l10n.about_photos}: ${l10n.ill_tanker}, ${l10n.ill_depot}, ${l10n.ill_driver}, ${l10n.ill_breakdown}',
        closeLabel: l10n.detail_show_all,
      ),
      demoResetLabel: AppFlags.isDemoBuild ? strings.demoReset : null,
      onDemoReset: AppFlags.isDemoBuild
          ? () {
              ref.invalidate(seedBundleProvider);
              ref.invalidate(masterDataProvider);
            }
          : null,
    );
  }
}

/// Ctrl/⌘+K shortcut opening the command palette. Mount once per shell.
class CommandShortcut extends StatelessWidget {
  const CommandShortcut({
    super.key,
    required this.onCommand,
    required this.child,
  });

  final VoidCallback onCommand;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <ShortcutActivator, Intent>{
        const SingleActivator(LogicalKeyboardKey.keyK, control: true):
            _CommandIntent(),
        const SingleActivator(LogicalKeyboardKey.keyK, meta: true):
            _CommandIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          _CommandIntent: CallbackAction<_CommandIntent>(
            onInvoke: (_) {
              onCommand();
              return null;
            },
          ),
        },
        child: Focus(autofocus: true, child: child),
      ),
    );
  }
}

class _CommandIntent extends Intent {
  const _CommandIntent();
}

/// Owns the expiry countdown timer (started once in initState, cancelled on
/// stay/sign-out/dispose) and renders [TTIdleTimeoutDialog].
class _IdleCountdown extends StatefulWidget {
  const _IdleCountdown({
    required this.title,
    required this.message,
    required this.stayLabel,
    required this.signOutLabel,
    required this.onStay,
    required this.onSignOut,
    required this.onExpired,
  });

  final String title;
  final String Function(String seconds) message;
  final String stayLabel;
  final String signOutLabel;
  final VoidCallback onStay;
  final VoidCallback onSignOut;
  final VoidCallback onExpired;

  @override
  State<_IdleCountdown> createState() => _IdleCountdownState();
}

class _IdleCountdownState extends State<_IdleCountdown> {
  late int _seconds = idleCountdownSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: _oneSecond), (_) {
      if (!mounted) return;
      if (_seconds <= 1) {
        _timer?.cancel();
        widget.onExpired();
        return;
      }
      setState(() => _seconds--);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TTIdleTimeoutDialog(
      title: widget.title,
      countdownLabel: widget.message('$_seconds'),
      stayLabel: widget.stayLabel,
      signOutLabel: widget.signOutLabel,
      onStay: widget.onStay,
      onSignOut: widget.onSignOut,
    );
  }
}

String _initials(String? displayName) {
  final parts = (displayName ?? '').split(' ').where((p) => p.isNotEmpty);
  return parts.take(2).map((p) => p.substring(0, 1)).join();
}

void _signOut(WidgetRef ref) {
  ref.read(sessionPendingMfaProvider.notifier).state = true;
  ref.read(sessionRoleChosenProvider.notifier).state = true;
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
