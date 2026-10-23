import 'package:data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Shell state: theme, locale, session. Single MaterialApp.router consumes
/// these (08 §3.6); control room forces its surface in P7.
final themeModeProvider = StateProvider<ThemeMode>((_) => ThemeMode.system);

final localeProvider = StateProvider<Locale>((_) => const Locale('en'));

final authRepositoryProvider =
    Provider<AuthRepository>((_) => MockAuthRepository());

final sessionProvider = StateProvider<Session?>((_) => null);

/// MFA gate: true until a pending-MFA session completes verification.
/// Defaults to true so freshly signed-in MFA roles (admin, supervisor,
/// finance) land on /mfa; cleared by MfaScreen.onVerified, reset on sign-out.
/// Non-MFA roles ignore the flag (P1 contracts §1).
final sessionPendingMfaProvider = StateProvider<bool>((_) => true);
