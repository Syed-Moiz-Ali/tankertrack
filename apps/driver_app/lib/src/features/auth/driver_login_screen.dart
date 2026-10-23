import 'package:core/core.dart';
import 'package:fleet_ui/fleet_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l10n/l10n.dart';

import '../../providers.dart';

/// Driver sign-in: driver ID + PIN (numeric, masked), language switch,
/// demo hint. Built ONLY from TT* components (08 §3).
class DriverLoginScreen extends ConsumerWidget {
  const DriverLoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return LoginScreen(
      strings: AuthStrings(
        welcome: l10n.login_welcome,
        title: l10n.loginTitle,
        subtitle: l10n.loginSubtitle,
        idLabel: l10n.loginIdLabel,
        idHint: 'DRV-001',
        secretLabel: l10n.loginPinLabel,
        signIn: l10n.loginSignIn,
        failed: l10n.loginFailed,
        requiredField: l10n.requiredField,
        demoHint: AppFlags.isDemoBuild
            ? l10n.loginDemoHint('DRV-001', '1234')
            : '',
        demoAccountsTitle: l10n.login_demo_accounts,
        appInitials: 'TT',
      ),
      secretKeyboard: TextInputType.number,
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
          if (session.role != Role.driver) return l10n.loginFailed;
          ref.read(sessionProvider.notifier).state = session;
          return null;
        }, (error) => l10n.loginFailed);
      },
    );
  }
}
