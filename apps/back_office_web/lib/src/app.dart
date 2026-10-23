import 'package:data/data.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n/l10n.dart';

import 'providers.dart';
import 'router.dart';

/// Back-office root: web surface theme, locale + theme-mode providers,
/// role-guarded router (08 §3.6).
///
/// The [GoRouter] instance is created once and refreshed via [RouterAuth]:
/// theme/locale rebuilds must never reset navigation state.
class BackOfficeApp extends ConsumerStatefulWidget {
  const BackOfficeApp({super.key});

  @override
  ConsumerState<BackOfficeApp> createState() => _BackOfficeAppState();
}

class _BackOfficeAppState extends ConsumerState<BackOfficeApp> {
  late final RouterAuth _auth = RouterAuth(
    session: ref.read(sessionProvider),
    pendingMfa: ref.read(sessionPendingMfaProvider),
  );
  late final GoRouter _router = buildRouter(_auth);

  @override
  Widget build(BuildContext context) {
    ref.listen<Session?>(
      sessionProvider,
      (_, next) => _auth.update(next, ref.read(sessionPendingMfaProvider)),
    );
    ref.listen<bool>(
      sessionPendingMfaProvider,
      (_, next) => _auth.update(ref.read(sessionProvider), next),
    );
    final mode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final arabic = locale.languageCode == 'ar';
    return MaterialApp.router(
      theme: AppTheme.build(
        surface: AppSurface.web,
        brightness: Brightness.light,
        arabic: arabic,
      ),
      darkTheme: AppTheme.build(
        surface: AppSurface.web,
        brightness: Brightness.dark,
        arabic: arabic,
      ),
      themeMode: mode,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: _router,
    );
  }
}
