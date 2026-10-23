import 'package:back_office_web/src/app.dart';
import 'package:back_office_web/src/features/design/design_screen.dart';
import 'package:back_office_web/src/providers.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:l10n/l10n.dart';

Widget _app({Locale locale = const Locale('en')}) => ProviderScope(
      overrides: [
        localeProvider.overrideWith((_) => locale),
      ],
      child: const BackOfficeApp(),
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
    await _enter(tester,
        find.widgetWithText(TextFormField, 'Company email'), 'dispatch@demo.sa');
    await _enter(
        tester, find.widgetWithText(TextFormField, 'Password'), 'wrong');
    await _tapButton(tester, 'Sign in');
    await tester.pumpAndSettle();
    expect(find.textContaining('Check your credentials'), findsOneWidget);
  });

  testWidgets('demo dispatcher login reaches dashboard', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();
    await _enter(tester,
        find.widgetWithText(TextFormField, 'Company email'), 'dispatch@demo.sa');
    await _enter(
        tester, find.widgetWithText(TextFormField, 'Password'), 'demo1234');
    await _tapButton(tester, 'Sign in');
    await tester.pumpAndSettle();
    expect(find.text('Dashboard'), findsWidgets);
    expect(find.text('Dispatcher'), findsWidgets);
  });

  testWidgets('driver creds rejected on office login', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();
    await _enter(tester,
        find.widgetWithText(TextFormField, 'Company email'), 'DRV-001');
    await _enter(
        tester, find.widgetWithText(TextFormField, 'Password'), '1234');
    await _tapButton(tester, 'Sign in');
    await tester.pumpAndSettle();
    expect(find.textContaining('Check your credentials'), findsOneWidget);
  });

  testWidgets('login renders AR RTL', (tester) async {
    await tester.pumpWidget(_app(locale: const Locale('ar')));
    await tester.pumpAndSettle();
    expect(find.text('تسجيل الدخول'), findsWidgets);
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
          surface: AppSurface.web,
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
