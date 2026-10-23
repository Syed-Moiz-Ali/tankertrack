import 'dart:io';

import 'package:core/core.dart';
import 'package:data/data.dart';
import 'package:driver_app/src/app.dart';
import 'package:driver_app/src/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// P1b driver visual record → docs/plan/screens/p1b/driver_* (390/1440 ×
/// en/ar × light/dark). Docs artifact, not a comparison gate.
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
  await addAll(FontLoader('MaterialIcons'),
      ['fonts/test/MaterialIcons-Regular.otf']);
}

const _driver = Session(
  userId: 'DRV-001',
  displayName: 'Khalid Al-Otaibi',
  role: Role.driver,
  driverId: 'DRV-001',
);

Future<void> _pumpApp(
  WidgetTester tester, {
  required Locale locale,
  required ThemeMode mode,
  required Size viewport,
  Session? session,
}) async {
  tester.view.physicalSize = viewport;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        localeProvider.overrideWith((_) => locale),
        themeModeProvider.overrideWith((_) => mode),
        if (session != null) sessionProvider.overrideWith((_) => session),
      ],
      child: const DriverApp(),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
  await tester.pump(const Duration(milliseconds: 500));
}

Future<void> _shot(WidgetTester tester, String name) async {
  await expectLater(
    find.byType(Scaffold).first,
    matchesGoldenFile('../../../../docs/plan/screens/p1b/$name.png'),
  );
}

void main() {
  setUpAll(_loadRealFonts);

  const widths = {
    '390': Size(390, 844),
    '1440': Size(1440, 900),
  };

  for (final locale in [const Locale('en'), const Locale('ar')]) {
    final tag = locale.languageCode;
    for (final mode in [ThemeMode.light, ThemeMode.dark]) {
      final m = mode.name;
      for (final entry in widths.entries) {
        testWidgets('shot driver login $tag $m ${entry.key}',
            (tester) async {
          await _pumpApp(tester,
              locale: locale, mode: mode, viewport: entry.value);
          await _shot(tester, 'driver_login_${tag}_${m}_${entry.key}');
        });
        testWidgets('shot driver home $tag $m ${entry.key}',
            (tester) async {
          await _pumpApp(tester,
              locale: locale, mode: mode, viewport: entry.value,
              session: _driver);
          await _shot(tester, 'driver_home_${tag}_${m}_${entry.key}');
        });
        testWidgets('shot driver profile $tag $m ${entry.key}',
            (tester) async {
          await _pumpApp(tester,
              locale: locale, mode: mode, viewport: entry.value,
              session: _driver);
          await tester.tap(find.text(
              tag == 'ar' ? 'الملف' : 'Profile'));
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 500));
          await _shot(tester, 'driver_profile_${tag}_${m}_${entry.key}');
        });
      }
    }
  }
}
