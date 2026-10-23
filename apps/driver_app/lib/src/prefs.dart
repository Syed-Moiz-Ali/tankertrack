import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persisted shell settings: theme mode + locale (login screen + settings).
class AppPrefs {
  AppPrefs(this._prefs);

  final SharedPreferences _prefs;

  static const _themeKey = 'tt_theme_mode';
  static const _localeKey = 'tt_locale';

  static Future<AppPrefs> load() async =>
      AppPrefs(await SharedPreferences.getInstance());

  @visibleForTesting
  static AppPrefs test(SharedPreferences prefs) => AppPrefs(prefs);

  ThemeMode get themeMode => switch (_prefs.getString(_themeKey)) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };

  Locale get locale {
    final code = _prefs.getString(_localeKey);
    return Locale(code == 'ar' ? 'ar' : 'en');
  }

  Future<void> saveTheme(ThemeMode mode) =>
      _prefs.setString(_themeKey, mode.name);

  Future<void> saveLocale(Locale locale) =>
      _prefs.setString(_localeKey, locale.languageCode);
}
