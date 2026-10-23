import 'dart:io';

import 'package:back_office_web/src/app.dart';
import 'package:back_office_web/src/data_providers.dart';
import 'package:back_office_web/src/providers.dart';
import 'package:core/core.dart';
import 'package:data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// P1 real-font screenshots → docs/plan/screens/p1/ (key screens ×
/// en/ar × light/dark). Run: `flutter test test/shots/shot_test.dart`.
/// Golden comparison is NOT the point here (docs artifact) — the files
/// are committed as the phase's visual record.
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

  await addAll(FontLoader('Inter'), ['fonts/Inter-Variable.ttf']);
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

Future<void> _pumpApp(
  WidgetTester tester, {
  required Locale locale,
  required ThemeMode mode,
  Session? session,
}) async {
  // Desktop viewport: honest back-office framing + NavigationRail path.
  tester.view.physicalSize = const Size(1440, 900);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        localeProvider.overrideWith((_) => locale),
        themeModeProvider.overrideWith((_) => mode),
        if (session != null)
          sessionProvider.overrideWith((_) => session),
        if (_preloaded != null)
          seedBundleProvider.overrideWith((_) async => _preloaded!),
      ],
      child: const BackOfficeApp(),
    ),
  );
  // Fixed frames (no settle: the tracking simulator owns a repeating timer).
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

/// Docs artifact (not a comparison gate): files committed as the phase's
/// visual record. Paths resolve relative to this test file's directory
/// (test/shots → ../../../.. = repo root).
Future<void> _shot(WidgetTester tester, String name) async {
  await expectLater(
    find.byType(Scaffold).first,
    matchesGoldenFile('../../../../docs/plan/screens/p1/$name.png'),
  );
}

void main() {
  setUpAll(_loadRealFonts);
  setUpAll(() async {
    _preloaded = await SeedBundle.load(
      Directory('../../packages/data/assets/seeds'),
    );
  });

  for (final locale in [const Locale('en'), const Locale('ar')]) {
    final tag = locale.languageCode;
    for (final mode in [ThemeMode.light, ThemeMode.dark]) {
      final m = mode.name;
      testWidgets('shot login $tag $m', (tester) async {
        await _pumpApp(tester, locale: locale, mode: mode);
        await _shot(tester, 'login_${tag}_$m');
      });
      testWidgets('shot dashboard $tag $m', (tester) async {
        await _pumpApp(
            tester, locale: locale, mode: mode, session: _dispatcher);
        // Dashboard renders KPIs only after seeds load from assets.
        // '266' = requested total digits (Western numerals in both locales).
        await _pumpUntil(tester, find.textContaining('266'));
        await _shot(tester, 'dashboard_${tag}_$m');
      });
    }
  }
}
