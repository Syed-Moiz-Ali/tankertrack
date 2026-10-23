import 'package:flutter/widgets.dart';

import 'gen/app_localizations.dart';

/// `context.l10n` — the ONLY string accessor in feature code.
/// (Companion to design_system's context helpers; lives here so
/// design_system stays dependency-free.)
extension L10nX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  Locale get locale => Localizations.localeOf(this);

  bool get isArabic => locale.languageCode == 'ar';
}
