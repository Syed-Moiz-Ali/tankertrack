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
/// finance) land on /otp; cleared by OtpScreen.onVerified, reset on sign-out.
/// Non-MFA roles ignore the flag (P1 contracts §1).
final sessionPendingMfaProvider = StateProvider<bool>((_) => true);

/// Workspace-choice gate (R3 BO-04): false right after a successful login so
/// the router lands on /role-select; set true by RoleSelectScreen CONTINUE
/// (and reset on sign-out).
final sessionRoleChosenProvider = StateProvider<bool>((_) => true);

/// Test seam for the shell inactivity timer (contracts §1: 15 minutes).
/// Defaults to true. Widget tests override it to false: FakeAsync
/// fast-forwards one-shot timers, so `pumpAndSettle` would otherwise trip
/// the idle dialog (and its countdown) mid-test.
final idleTimerEnabledProvider = Provider<bool>((_) => true);
