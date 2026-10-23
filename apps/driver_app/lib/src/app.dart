import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l10n/l10n.dart';

import 'providers.dart';
import 'router.dart';

/// Driver app root: driver surface theme, locale + theme-mode providers,
/// role-guarded router (08 §3.6).
class DriverApp extends ConsumerWidget {
  const DriverApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final arabic = locale.languageCode == 'ar';
    final router = buildRouter(ref);
    return MaterialApp.router(
      theme: AppTheme.build(
        surface: AppSurface.driver,
        brightness: Brightness.light,
        arabic: arabic,
      ),
      darkTheme: AppTheme.build(
        surface: AppSurface.driver,
        brightness: Brightness.dark,
        arabic: arabic,
      ),
      themeMode: mode,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    );
  }
}
