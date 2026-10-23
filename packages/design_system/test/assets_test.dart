import 'dart:io';

import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

/// Every SVG parses (flutter_svg loader) and renders at 200x200
/// without throwing.
void main() {
  const uris = <String, String>{
    'logo': AppAssets.logoMark,
    'tanker': AppAssets.tanker,
    'depot': AppAssets.depot,
    'driver': AppAssets.driver,
    'emptyTasks': AppAssets.emptyTasks,
    'emptyMap': AppAssets.emptyMap,
    'breakdown': AppAssets.breakdown,
  };

  String relativePath(String uri) =>
      uri.replaceFirst('packages/design_system/', '');

  group('AppAssets', () {
    test('exposes full package URIs for all seven artworks', () {
      expect(uris, hasLength(7));
      for (final uri in uris.values) {
        expect(uri, startsWith('packages/design_system/assets/'));
        expect(uri, endsWith('.svg'));
      }
      expect(uris.values.toSet(), hasLength(7));
      for (final uri in uris.values) {
        expect(File(relativePath(uri)).existsSync(), isTrue,
            reason: 'missing file for $uri');
      }
    });

    for (final entry in uris.entries) {
      test('${entry.key} parses via flutter_svg', () async {
        final raw = File(relativePath(entry.value)).readAsStringSync();
        expect(raw, contains('<svg'));
        final compiled =
            await SvgStringLoader(raw).loadBytes(null);
        expect(compiled.lengthInBytes, greaterThan(0));
      });
    }
  });

  group('SvgPicture rendering', () {
    for (final entry in uris.entries) {
      testWidgets('${entry.key} builds at 200x200 without throwing',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.build(
              surface: AppSurface.web,
              brightness: Brightness.light,
              arabic: false,
            ),
            home: Scaffold(
              body: Center(
                child: SvgPicture.asset(
                  entry.value,
                  width: 200,
                  height: 200,
                ),
              ),
            ),
          ),
        );
        await tester.pump();
        expect(find.byType(SvgPicture), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('TTLogoMark renders with default + explicit size',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.build(
            surface: AppSurface.web,
            brightness: Brightness.light,
            arabic: false,
          ),
          home: const Scaffold(
            body: Column(
              children: [
                TTLogoMark(semanticsLabel: 'TankerTrack'),
                TTLogoMark(size: 96),
              ],
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(TTLogoMark), findsNWidgets(2));
      expect(find.byType(SvgPicture), findsNWidgets(2));
      expect(tester.takeException(), isNull);
    });
  });
}
