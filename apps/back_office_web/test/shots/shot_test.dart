import 'dart:io';

import 'package:back_office_web/src/app.dart';
import 'package:back_office_web/src/data_providers.dart';
import 'package:back_office_web/src/features/tower/tower_screen.dart';
import 'package:back_office_web/src/features/vehicles/vehicle_screens.dart';
import 'package:back_office_web/src/providers.dart';
import 'package:core/core.dart';
import 'package:data/data.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:l10n/l10n.dart';

/// P1b visual record → docs/plan/screens/p1b/ (screens × 1440/1024/390 ×
/// en/ar × light/dark). Run: `flutter test test/shots/shot_test.dart`.
/// Golden comparison is NOT the point here (docs artifact) — the files
/// are committed as the phase's visual record for ui-reviewer.
Future<void> _loadRealFonts() async {
  Future<ByteData> bytes(String path) async {
    final data = await File(path).readAsBytes();
    return ByteData.sublistView(data);
  }

  Future<void> addAll(FontLoader loader, List<String> paths) async {
    for (final p in paths) {
      loader.addFont(bytes(p));
    }
    await loader.load();
  }

  await addAll(
      FontLoader('Plus Jakarta Sans'), ['fonts/PlusJakartaSans-Variable.ttf']);
  await addAll(FontLoader('IBM Plex Sans Arabic'), [
    'fonts/IBMPlexSansArabic-Regular.ttf',
    'fonts/IBMPlexSansArabic-Medium.ttf',
    'fonts/IBMPlexSansArabic-SemiBold.ttf',
    'fonts/IBMPlexSansArabic-Bold.ttf',
  ]);
  await addAll(FontLoader('Noto Sans Arabic'),
      ['fonts/NotoSansArabic-Variable.ttf']);

  // Test-env icon font (Apache 2.0, see fonts/test/LICENSE-materialicons).
  // flutter test ships no icon glyphs — without this, screenshots show tofu.
  await addAll(FontLoader('MaterialIcons'),
      ['fonts/test/MaterialIcons-Regular.otf']);
}

const _dispatcher = Session(
  userId: 'dispatch@demo.sa',
  displayName: 'Sara Al-Qahtani',
  role: Role.dispatcher,
);

/// Preloaded in setUpAll (real async) for deterministic shots.
SeedBundle? _preloaded;

List<Override> _baseOverrides({
  required Locale locale,
  required ThemeMode mode,
  Session? session,
}) => [
      localeProvider.overrideWith((_) => locale),
      themeModeProvider.overrideWith((_) => mode),
      if (session != null) sessionProvider.overrideWith((_) => session),
      if (_preloaded != null)
        seedBundleProvider.overrideWith((_) async => _preloaded!),
    ];

Future<void> _setViewport(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

/// Full app at [route] (go_router initial location can't be set per pump,
/// so authed screens are reached through the real router: login first only
/// for the login shot; the rest pump screens directly with providers).
Future<void> _pumpApp(
  WidgetTester tester, {
  required Locale locale,
  required ThemeMode mode,
  required Size viewport,
  Session? session,
}) async {
  await _setViewport(tester, viewport);
  await tester.pumpWidget(
    ProviderScope(
      overrides: _baseOverrides(
          locale: locale, mode: mode, session: session),
      child: const BackOfficeApp(),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
  await tester.pump(const Duration(milliseconds: 500));
}

/// Single screen with theme + l10n + data (for deep routes).
Future<void> _pumpScreen(
  WidgetTester tester,
  Widget screen, {
  required Locale locale,
  required ThemeMode mode,
  required Size viewport,
}) async {
  await _setViewport(tester, viewport);
  final arabic = locale.languageCode == 'ar';
  await tester.pumpWidget(
    ProviderScope(
      overrides: _baseOverrides(locale: locale, mode: mode,
          session: _dispatcher),
      child: MaterialApp(
        theme: AppTheme.build(
            surface: AppSurface.web,
            brightness: Brightness.light,
            arabic: arabic),
        darkTheme: AppTheme.build(
            surface: AppSurface.web,
            brightness: Brightness.dark,
            arabic: arabic),
        themeMode: mode,
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: screen),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
  await tester.pump(const Duration(milliseconds: 500));
}

/// Pumps until [finder] appears (seed loading is async) or gives up.
Future<void> _pumpUntil(
  WidgetTester tester,
  Finder finder, {
  int maxFrames = 40,
}) async {
  for (var i = 0; i < maxFrames; i++) {
    await tester.pump(const Duration(milliseconds: 300));
    if (finder.evaluate().isNotEmpty) return;
  }
}

/// Docs artifact (not a comparison gate). Paths resolve relative to this
/// test file's directory (test/shots → ../../../.. = repo root).
Future<void> _shot(WidgetTester tester, String name) async {
  await expectLater(
    find.byType(Scaffold).first,
    matchesGoldenFile('../../../../docs/plan/screens/p1b/$name.png'),
  );
}

void main() {
  setUpAll(_loadRealFonts);
  setUpAll(() async {
    _preloaded = await SeedBundle.load(
      Directory('../../packages/data/assets/seeds'),
    );
  });

  const widths = {
    '1440': Size(1440, 900),
    '1024': Size(1024, 768),
    '390': Size(390, 844),
  };

  for (final locale in [const Locale('en'), const Locale('ar')]) {
    final tag = locale.languageCode;
    for (final mode in [ThemeMode.light, ThemeMode.dark]) {
      final m = mode.name;
      for (final entry in widths.entries) {
        final w = entry.key;
        final viewport = entry.value;
        testWidgets('shot login $tag $m $w', (tester) async {
          await _pumpApp(tester,
              locale: locale, mode: mode, viewport: viewport);
          await _shot(tester, 'login_${tag}_${m}_$w');
        });
        testWidgets('shot today $tag $m $w', (tester) async {
          await _pumpApp(tester,
              locale: locale, mode: mode, viewport: viewport,
              session: _dispatcher);
          await _pumpUntil(tester, find.textContaining('266'));
          await _shot(tester, 'today_${tag}_${m}_$w');
        });
      }
      testWidgets('shot tower $tag $m', (tester) async {
        await _pumpScreen(tester, const ControlTowerScreen(),
            locale: locale, mode: mode, viewport: widths['1440']!);
        await _pumpUntil(tester, find.textContaining('16'));
        await _shot(tester, 'tower_${tag}_$m');
      });
      testWidgets('shot vehicle $tag $m', (tester) async {
        await _pumpScreen(
            tester, const VehicleDetailScreen(vehicleId: 'T-214'),
            locale: locale, mode: mode, viewport: widths['1440']!);
        await _pumpUntil(tester, find.textContaining('T-214'));
        await _shot(tester, 'vehicle_${tag}_$m');
      });
    }
  }
}
