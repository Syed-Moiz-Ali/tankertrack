import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// R3 profile sheet (role, language, theme, demo tools demo-only, About).
/// The shared [TTProfileMenuButton] carries no About/demo-reset rows, so the
/// shell owns this sheet; every string arrives via params (l10n-only).
Future<void> showTTProfileSheet({
  required BuildContext context,
  required String sheetTitle,
  required String profileLabel,
  required ThemeMode themeMode,
  required ValueChanged<ThemeMode> onTheme,
  required String lightLabel,
  required String darkLabel,
  required String systemLabel,
  required Locale locale,
  required ValueChanged<Locale> onLocale,
  required String englishLabel,
  required String arabicLabel,
  required List<TTMenuRole> roleEntries,
  required String currentRole,
  required ValueChanged<String> onRole,
  required String demoRoleLabel,
  required String signOutLabel,
  required VoidCallback onSignOut,
  required String aboutLabel,
  required VoidCallback onAbout,
  String? demoResetLabel,
  VoidCallback? onDemoReset,
}) {
  return showTTGrabberSheet<void>(
    context,
    SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(sheetTitle, style: context.text.titleLarge),
          const TTGap.xs(),
          Text(profileLabel, style: context.text.bodySmall),
          const TTGap.md(),
          TTThemeSwitch(
            mode: themeMode,
            onChanged: onTheme,
            lightLabel: lightLabel,
            darkLabel: darkLabel,
            systemLabel: systemLabel,
          ),
          const TTGap.md(),
          TTLanguageSwitch(
            current: locale,
            onChanged: onLocale,
            englishLabel: englishLabel,
            arabicLabel: arabicLabel,
          ),
          if (roleEntries.isNotEmpty) ...[
            const TTGap.md(),
            Text(demoRoleLabel, style: context.text.titleSmall),
            const TTGap.sm(),
            Wrap(
              spacing: context.tokens.spaceSm,
              runSpacing: context.tokens.spaceSm,
              children: [
                for (final TTMenuRole entry in roleEntries)
                  FilterChip(
                    label: Text(entry.label),
                    selected: entry.value == currentRole,
                    onSelected: (_) => onRole(entry.value),
                  ),
              ],
            ),
          ],
          if (demoResetLabel != null) ...[
            const TTGap.md(),
            TTListTile(
              leading: Icon(AppIcons.iconFor(AppIcons.refresh, context)),
              title: demoResetLabel,
              onTap: () {
                Navigator.of(context).pop();
                onDemoReset?.call();
              },
            ),
          ],
          const TTGap.sm(),
          TTListTile(
            leading: Icon(AppIcons.iconFor(AppIcons.info, context)),
            title: aboutLabel,
            onTap: () {
              Navigator.of(context).pop();
              onAbout();
            },
          ),
          const TTGap.sm(),
          TTListTile(
            leading: Icon(AppIcons.iconFor(AppIcons.logout, context)),
            title: signOutLabel,
            onTap: () {
              Navigator.of(context).pop();
              onSignOut();
            },
          ),
          const TTGap.md(),
        ],
      ),
    ),
  );
}
