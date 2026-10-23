import 'package:flutter/material.dart';

import '../context_ext.dart';
import '../icons.dart';
import 'tt_button.dart';
import 'tt_card.dart';
import 'tt_gap.dart';
import 'tt_sheets.dart';

/// One demo-role entry in the profile sheet: stable [value] + localized [label].
@immutable
class TTMenuRole {
  const TTMenuRole({required this.value, required this.label});

  final String value;
  final String label;
}

/// Avatar + chevron button (R1 right cluster) opening a grabber sheet with
/// theme / language / demo-role / sign-out rows.
///
/// Every user-visible string arrives via params. [themeMode]/[onTheme] use
/// [ThemeMode]; [locale]/[onLocale] use [Locale]; [currentRole]/[onRole]
/// carry the selected [TTMenuRole.value].
class TTProfileMenuButton extends StatelessWidget {
  const TTProfileMenuButton({
    super.key,
    required this.avatarLabel,
    required this.sheetTitle,
    required this.themeMode,
    required this.onTheme,
    required this.lightLabel,
    required this.darkLabel,
    required this.systemLabel,
    required this.locale,
    required this.onLocale,
    required this.englishLabel,
    required this.arabicLabel,
    required this.roleEntries,
    required this.currentRole,
    required this.onRole,
    required this.demoRoleLabel,
    required this.signOutLabel,
    required this.onSignOut,
    required this.profileLabel,
  });

  final String avatarLabel;
  final String sheetTitle;
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onTheme;
  final String lightLabel;
  final String darkLabel;
  final String systemLabel;
  final Locale locale;
  final ValueChanged<Locale> onLocale;
  final String englishLabel;
  final String arabicLabel;
  final List<TTMenuRole> roleEntries;
  final String currentRole;
  final ValueChanged<String> onRole;
  final String demoRoleLabel;
  final String signOutLabel;
  final VoidCallback onSignOut;
  final String profileLabel;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final c = context.colors;
    return InkWell(
      borderRadius: BorderRadius.circular(t.radiusPill),
      onTap: () => _openSheet(context),
      child: Container(
        padding: EdgeInsets.all(t.spaceSm),
        decoration: BoxDecoration(
          border: Border.all(color: c.outlineVariant),
          borderRadius: BorderRadius.circular(t.radiusPill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TTAvatar(initials: avatarLabel, small: true),
            const TTGap.sm(axis: Axis.horizontal),
            Icon(
              AppIcons.iconFor(AppIcons.chevronDown, context),
              color: c.onSurfaceVariant,
              size: t.iconMd,
            ),
          ],
        ),
      ),
    );
  }

  void _openSheet(BuildContext context) {
    showTTGrabberSheet<void>(
      context,
      _TTProfileSheet(
        sheetTitle: sheetTitle,
        themeMode: themeMode,
        onTheme: onTheme,
        lightLabel: lightLabel,
        darkLabel: darkLabel,
        systemLabel: systemLabel,
        locale: locale,
        onLocale: onLocale,
        englishLabel: englishLabel,
        arabicLabel: arabicLabel,
        roleEntries: roleEntries,
        currentRole: currentRole,
        onRole: onRole,
        demoRoleLabel: demoRoleLabel,
        signOutLabel: signOutLabel,
        onSignOut: onSignOut,
        profileLabel: profileLabel,
        avatarLabel: avatarLabel,
      ),
    );
  }
}

class _TTProfileSheet extends StatelessWidget {
  const _TTProfileSheet({
    required this.sheetTitle,
    required this.themeMode,
    required this.onTheme,
    required this.lightLabel,
    required this.darkLabel,
    required this.systemLabel,
    required this.locale,
    required this.onLocale,
    required this.englishLabel,
    required this.arabicLabel,
    required this.roleEntries,
    required this.currentRole,
    required this.onRole,
    required this.demoRoleLabel,
    required this.signOutLabel,
    required this.onSignOut,
    required this.profileLabel,
    required this.avatarLabel,
  });

  final String sheetTitle;
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onTheme;
  final String lightLabel;
  final String darkLabel;
  final String systemLabel;
  final Locale locale;
  final ValueChanged<Locale> onLocale;
  final String englishLabel;
  final String arabicLabel;
  final List<TTMenuRole> roleEntries;
  final String currentRole;
  final ValueChanged<String> onRole;
  final String demoRoleLabel;
  final String signOutLabel;
  final VoidCallback onSignOut;
  final String profileLabel;
  final String avatarLabel;

  String get _roleLabel {
    for (final entry in roleEntries) {
      if (entry.value == currentRole) return entry.label;
    }
    return demoRoleLabel;
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          children: <Widget>[
            TTAvatar(initials: avatarLabel),
            const TTGap.md(axis: Axis.horizontal),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(sheetTitle, style: context.text.titleLarge),
                  Text(
                    '$profileLabel · $_roleLabel',
                    style: context.text.bodySmall?.copyWith(
                      color: c.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const TTGap.lg(),
        const Divider(),
        _sheetRow(
          context,
          label: lightLabel,
          active: themeMode == ThemeMode.light,
          onTap: () {
            Navigator.of(context).pop();
            onTheme(ThemeMode.light);
          },
        ),
        _sheetRow(
          context,
          label: darkLabel,
          active: themeMode == ThemeMode.dark,
          onTap: () {
            Navigator.of(context).pop();
            onTheme(ThemeMode.dark);
          },
        ),
        _sheetRow(
          context,
          label: systemLabel,
          active: themeMode == ThemeMode.system,
          onTap: () {
            Navigator.of(context).pop();
            onTheme(ThemeMode.system);
          },
        ),
        const Divider(),
        _sheetRow(
          context,
          label: englishLabel,
          active: locale.languageCode == 'en',
          onTap: () {
            Navigator.of(context).pop();
            onLocale(const Locale('en'));
          },
        ),
        _sheetRow(
          context,
          label: arabicLabel,
          active: locale.languageCode == 'ar',
          onTap: () {
            Navigator.of(context).pop();
            onLocale(const Locale('ar'));
          },
        ),
        const Divider(),
        if (roleEntries.isNotEmpty)
          Text(
            demoRoleLabel,
            style: context.text.bodySmall?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        if (roleEntries.isNotEmpty) const TTGap.sm(),
        for (final entry in roleEntries)
          _sheetRow(
            context,
            label: entry.label,
            active: entry.value == currentRole,
            onTap: () {
              Navigator.of(context).pop();
              onRole(entry.value);
            },
          ),
        if (roleEntries.isNotEmpty) const Divider(),
        if (roleEntries.isNotEmpty) const TTGap.sm(),
        TTButton(
          label: signOutLabel,
          variant: TTButtonVariant.destructive,
          onPressed: () {
            Navigator.of(context).pop();
            onSignOut();
          },
        ),
      ],
    );
  }

  Widget _sheetRow(
    BuildContext context, {
    required String label,
    required bool active,
    required VoidCallback onTap,
  }) {
    return TTListTile(
      title: label,
      trailing: active
          ? Icon(
              AppIcons.iconFor(AppIcons.check, context),
              color: context.colors.primary,
              size: context.tokens.iconMd,
            )
          : null,
      onTap: onTap,
    );
  }
}
