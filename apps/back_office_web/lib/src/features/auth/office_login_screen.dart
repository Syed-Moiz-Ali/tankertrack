import 'package:core/core.dart';
import 'package:fleet_ui/fleet_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l10n/l10n.dart';

import '../../providers.dart';
import '../../routes.dart';

/// Back-office sign-in (R2 modal language): centered card (r16 + float
/// shadow) with [TTLogoMark], globe language button and a demo-accounts
/// helper that only exists in demo builds ([AppFlags.isDemoBuild]).
/// Thin wrapper over the shared fleet_ui [LoginScreen] — zero duplication.
class OfficeLoginScreen extends ConsumerWidget {
  const OfficeLoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return LoginScreen(
      strings: AuthStrings(
        welcome: l10n.login_welcome,
        title: l10n.loginTitle,
        subtitle: l10n.loginSubtitle,
        idLabel: l10n.loginEmailLabel,
        idHint: l10n.loginEmailHint,
        secretLabel: l10n.loginPasswordLabel,
        signIn: l10n.loginSignIn,
        failed: l10n.loginFailed,
        requiredField: l10n.requiredField,
        demoHint: AppFlags.isDemoBuild
            ? l10n.loginDemoHint('dispatch@demo.sa', 'demo1234')
            : '',
        demoAccountsTitle: l10n.login_demo_accounts,
        appInitials: 'TT',
      ),
      secretKeyboard: TextInputType.visiblePassword,
      languageSwitch: TTLanguageSwitch(
        current: ref.watch(localeProvider),
        englishLabel: l10n.langEnglish,
        arabicLabel: l10n.langArabic,
        compact: true,
        onChanged: (locale) =>
            ref.read(localeProvider.notifier).state = locale,
      ),
      onSignIn: (id, secret) async {
        final result = await ref
            .read(authRepositoryProvider)
            .login(identifier: id, secret: secret);
        return result.fold((session) {
          if (session.role == Role.driver) return l10n.loginFailed;
          if (mfaRoles.contains(session.role)) {
            ref.read(sessionPendingMfaProvider.notifier).state = true;
          } else {
            ref.read(sessionPendingMfaProvider.notifier).state = false;
          }
          ref.read(sessionProvider.notifier).state = session;
          return null;
        }, (error) => l10n.loginFailed);
      },
    );
  }
}
