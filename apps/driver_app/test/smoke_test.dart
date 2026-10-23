import 'package:design_system/design_system.dart';
import 'package:driver_app/src/app.dart';
import 'package:driver_app/src/features/design/design_screen.dart';
import 'package:driver_app/src/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:l10n/l10n.dart';

Widget _app({Locale locale = const Locale('en')}) => ProviderScope(
      overrides: [
        localeProvider.overrideWith((_) => locale),
      ],
      child: const DriverApp(),
    );

/// Test viewport is 800x600 — fields below the fold need scrolling first.
Future<void> _enter(
  WidgetTester tester,
  Finder finder,
  String value,
) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.enterText(finder, value);
}

Future<void> _tapButton(WidgetTester tester, String label) async {
  final finder = find.widgetWithText(ElevatedButton, label);
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
}

void main() {
  testWidgets('login renders EN; bad creds show error', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();
    expect(find.widgetWithText(ElevatedButton, 'Sign in'), findsOneWidget);
    await _enter(
        tester, find.widgetWithText(TextFormField, 'Driver ID'), 'DRV-001');
    await _enter(
        tester, find.widgetWithText(TextFormField, 'Driver PIN'), '0000');
    await _tapButton(tester, 'Sign in');
    await tester.pumpAndSettle();
    expect(find.textContaining('Check your credentials'), findsOneWidget);
  });

  testWidgets('demo driver login reaches home', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();
    await _enter(
        tester, find.widgetWithText(TextFormField, 'Driver ID'), 'DRV-001');
    await _enter(
        tester, find.widgetWithText(TextFormField, 'Driver PIN'), '1234');
    await _tapButton(tester, 'Sign in');
    await tester.pumpAndSettle();
    expect(find.textContaining('Khalid'), findsOneWidget);
    expect(find.text('driver'), findsOneWidget);
  });

  testWidgets('login renders AR RTL', (tester) async {
    await tester.pumpWidget(_app(locale: const Locale('ar')));
    await tester.pumpAndSettle();
    expect(find.text('تسجيل الدخول'), findsWidgets);
    expect(find.text('دخول'), findsOneWidget);
    final dir = tester
        .element(find.byType(Scaffold).first)
        .getElementForInheritedWidgetOfExactType<Directionality>()
        ?.widget as Directionality?;
    expect(dir?.textDirection, TextDirection.rtl);
  });

  testWidgets('design catalogue renders localized', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.build(
          surface: AppSurface.driver,
          brightness: Brightness.light,
          arabic: false,
        ),
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const DesignScreen(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Buttons'), findsOneWidget);
  });
}
