import 'dart:io';

import 'package:back_office_web/src/data_providers.dart';
import 'package:data/data.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:l10n/l10n.dart';

/// Loads the REAL seed bundle from disk (repo-relative, robust to the test
/// working directory).
///
/// MUST be awaited in `main()` (real async zone) — never inside a
/// `testWidgets` body, which runs in FakeAsync where dart:io never
/// completes. The returned bundle is shared read-only; each [p1TestApp]
/// builds a fresh [DemoMasterDataService] overlay, so tests stay isolated.
Future<SeedBundle> loadTestBundle() async {
  const candidates = [
    '../../packages/data/assets/seeds',
    'packages/data/assets/seeds',
  ];
  for (final c in candidates) {
    if (Directory(c).existsSync()) {
      return SeedBundle.load(Directory(c));
    }
  }
  throw StateError('seed dir not found (tried $candidates)');
}

/// Pumpable app shell: web theme + real l10n delegates + preloaded seed
/// bundle ([loadTestBundle] in `main()`). Slice-C router is bypassed
/// (single `home`); navigation between master list/detail/form screens
/// uses plain [Navigator] pushes.
Widget p1TestApp({
  required Widget home,
  required SeedBundle bundle,
  List<Override> overrides = const [],
}) =>
    ProviderScope(
      overrides: [
        seedBundleProvider.overrideWith((ref) => bundle),
        ...overrides,
      ],
      child: MaterialApp(
        theme: AppTheme.build(
          surface: AppSurface.web,
          brightness: Brightness.light,
          arabic: false,
        ),
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: home,
      ),
    );
