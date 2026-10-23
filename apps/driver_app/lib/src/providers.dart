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

/// R3 DR-02: account verification gate. Login sets the session; the verify
/// screen flips this; the router holds unauthenticated-verified users on
/// /verify until it is true.
final verifiedProvider = StateProvider<bool>((_) => false);

/// R3 DR-03: shift-start gate. The start-shift screen flips this after
/// odometer + location-consent validation; the router holds users on
/// /start-shift until it is true.
final shiftStartedProvider = StateProvider<bool>((_) => false);

/// Connectivity stand-in for offline/sync indicators (same visual language
/// everywhere via SyncBadge + TTBanner). Real connectivity lands with the
/// sync slice; tests toggle this.
final connectionProvider = StateProvider<bool>((_) => true);
