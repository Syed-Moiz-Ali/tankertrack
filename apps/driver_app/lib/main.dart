import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/app.dart';
import 'src/prefs.dart';
import 'src/providers.dart';

/// Crash-safe startup: zone captures async errors into the breadcrumb log;
/// every screen renders finished empty/error states (never a red screen).
Future<void> main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    final prefs = await AppPrefs.load();
    runApp(
      ProviderScope(
        overrides: [
          themeModeProvider.overrideWith((_) => prefs.themeMode),
          localeProvider.overrideWith((_) => prefs.locale),
        ],
        child: const DriverApp(),
      ),
    );
  }, (Object error, StackTrace stack) {
    AppLog.error('zone: $error');
  });
}
