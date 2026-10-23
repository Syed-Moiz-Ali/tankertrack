import 'package:flutter/material.dart';

import '../icons.dart';

/// Language switch (EN/AR). Labels come from l10n (caller passes them);
/// the switch itself holds zero strings.
class TTLanguageSwitch extends StatelessWidget {
  const TTLanguageSwitch({
    super.key,
    required this.current,
    required this.onChanged,
    required this.englishLabel,
    required this.arabicLabel,
    this.compact = false,
  });

  final Locale current;
  final void Function(Locale) onChanged;
  final String englishLabel;
  final String arabicLabel;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final isAr = current.languageCode == 'ar';
    if (compact) {
      return TextButton.icon(
        onPressed: () => onChanged(
          Locale(isAr ? 'en' : 'ar'),
        ),
        icon: Icon(AppIcons.iconFor(AppIcons.language, context)),
        label: Text(isAr ? englishLabel : arabicLabel),
      );
    }
    return SegmentedButton<bool>(
      segments: [
        ButtonSegment(value: false, label: Text(englishLabel)),
        ButtonSegment(value: true, label: Text(arabicLabel)),
      ],
      selected: {isAr},
      onSelectionChanged: (s) =>
          onChanged(Locale(s.first ? 'ar' : 'en')),
    );
  }
}

/// Theme switch (light/dark/system). Labels from the caller.
class TTThemeSwitch extends StatelessWidget {
  const TTThemeSwitch({
    super.key,
    required this.mode,
    required this.onChanged,
    required this.lightLabel,
    required this.darkLabel,
    required this.systemLabel,
  });

  final ThemeMode mode;
  final void Function(ThemeMode) onChanged;
  final String lightLabel;
  final String darkLabel;
  final String systemLabel;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<ThemeMode>(
      segments: [
        ButtonSegment(value: ThemeMode.light, label: Text(lightLabel)),
        ButtonSegment(value: ThemeMode.dark, label: Text(darkLabel)),
        ButtonSegment(value: ThemeMode.system, label: Text(systemLabel)),
      ],
      selected: {mode},
      onSelectionChanged: (s) => onChanged(s.first),
    );
  }
}
