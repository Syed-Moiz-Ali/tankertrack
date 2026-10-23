import 'package:fleet_ui/fleet_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l10n/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../prefs.dart';
import '../../providers.dart';

/// Profile tab: driver card (avatar, name, role chip) + persisted
/// theme/language rows + sign out.
class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final session = ref.watch(sessionProvider);
    final name = session?.displayName ?? '';
    final role = session?.role;
    return ListView(
      children: [
        const TTGap.xl(),
        TTCard(
          child: Row(
            children: [
              TTAvatar(initials: initialsOf(name)),
              const TTGap.md(axis: Axis.horizontal),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(name, style: context.text.titleLarge),
                    if (role != null) const TTGap.xs(),
                    if (role != null)
                      StatusChip(
                        style: StatusStyle.active,
                        label: roleLabel(role, l10n),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const TTGap.lg(),
        TTCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TTListTile(
                leading: Icon(
                    AppIcons.iconFor(AppIcons.user, context)),
                title: session?.driverId ?? name,
              ),
              const TTDivider(),
              TTListTile(
                leading: Icon(
                    AppIcons.iconFor(AppIcons.info, context)),
                title: session?.userId ?? '',
              ),
            ],
          ),
        ),
        const TTGap.lg(),
        TTSection(
          title: l10n.menu_theme,
          child: TTThemeSwitch(
            mode: ref.watch(themeModeProvider),
            lightLabel: l10n.themeLight,
            darkLabel: l10n.themeDark,
            systemLabel: l10n.themeSystem,
            onChanged: (mode) async {
              ref.read(themeModeProvider.notifier).state = mode;
              final prefs = await SharedPreferences.getInstance();
              await AppPrefs(prefs).saveTheme(mode);
            },
          ),
        ),
        const TTGap.lg(),
        TTSection(
          title: l10n.menu_language,
          child: TTLanguageSwitch(
            current: ref.watch(localeProvider),
            englishLabel: l10n.langEnglish,
            arabicLabel: l10n.langArabic,
            onChanged: (locale) async {
              ref.read(localeProvider.notifier).state = locale;
              final prefs = await SharedPreferences.getInstance();
              await AppPrefs(prefs).saveLocale(locale);
            },
          ),
        ),
        const TTGap.lg(),
        TTButton(
          label: l10n.loginSignOut,
          variant: TTButtonVariant.tertiary,
          onPressed: () {
            ref.read(sessionProvider.notifier).state = null;
          },
        ),
        const TTGap.xl(),
      ],
    );
  }

  /// Initials for the avatar, extracted for testability.
  @visibleForTesting
  static String initialsOf(String name) {
    final parts = name.split(' ').where((w) => w.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    return parts.take(2).map((w) => w.substring(0, 1)).join();
  }
}
