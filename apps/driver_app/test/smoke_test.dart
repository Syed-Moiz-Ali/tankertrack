import 'package:design_system/design_system.dart';
import 'package:driver_app/src/app.dart';
import 'package:driver_app/src/features/design/design_screen.dart';
import 'package:driver_app/src/features/home/profile_tab.dart';
import 'package:driver_app/src/features/home/today_tab.dart';
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

Future<void> _loginDemoDriver(WidgetTester tester) async {
  await tester.pumpWidget(_app());
  await tester.pumpAndSettle();
  await _enter(
      tester, find.widgetWithText(TextFormField, 'Driver ID'), 'DRV-001');
  await _enter(
      tester, find.widgetWithText(TextFormField, 'Driver PIN'), '1234');
  await _tapButton(tester, 'Sign in');
  await tester.pumpAndSettle();
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

  testWidgets('demo driver login reaches tab shell with greeting', (tester) async {
    await _loginDemoDriver(tester);
    expect(find.textContaining('Khalid'), findsOneWidget);
    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Tasks'), findsOneWidget);
    expect(find.text('Messages'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Next up'), findsOneWidget);
  });

  testWidgets('bottom tabs navigate; profile signs out to login',
      (tester) async {
    await _loginDemoDriver(tester);

    await tester.tap(find.text('Tasks'));
    await tester.pumpAndSettle();
    expect(find.text('Nothing here yet'), findsOneWidget);
    expect(find.text('Next up'), findsNothing);

    await tester.tap(find.text('Messages'));
    await tester.pumpAndSettle();
    expect(find.text('Nothing here yet'), findsOneWidget);

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Khalid'), findsOneWidget);
    expect(find.text('Driver'), findsOneWidget);

    final signOut = find.text('Sign out');
    // Lazily built below the fold: scroll first, then tap.
    await tester.scrollUntilVisible(
      signOut,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(signOut);
    await tester.pumpAndSettle();
    expect(
        find.widgetWithText(ElevatedButton, 'Sign in'), findsOneWidget);
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

  testWidgets('shell renders AR tab labels', (tester) async {
    await tester.pumpWidget(_app(locale: const Locale('ar')));
    await tester.pumpAndSettle();
    await _enter(
        tester, find.widgetWithText(TextFormField, 'رقم السائق'), 'DRV-001');
    await _enter(
        tester, find.widgetWithText(TextFormField, 'الرقم السري للسائق'), '1234');
    await tester.tap(find.widgetWithText(ElevatedButton, 'دخول'));
    await tester.pumpAndSettle();
    expect(find.text('اليوم'), findsOneWidget);
    expect(find.text('المهام'), findsOneWidget);
    expect(find.text('الرسائل'), findsOneWidget);
    expect(find.text('الملف'), findsOneWidget);
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

  test('greeting picks morning/afternoon/evening', () {
    final l10n = lookupAppLocalizations(const Locale('en'));
    expect(
        TodayTab.greetingFor(l10n, 'Khalid', 8), 'Good morning, Khalid');
    expect(
        TodayTab.greetingFor(l10n, 'Khalid', 13), 'Good afternoon, Khalid');
    expect(TodayTab.greetingFor(l10n, 'Khalid', 20), 'Good evening, Khalid');
  });

  test('profile initials handle edge cases', () {
    expect(ProfileTab.initialsOf('Khalid Al-Otaibi'), 'KA');
    expect(ProfileTab.initialsOf('Khalid'), 'K');
    expect(ProfileTab.initialsOf(''), '?');
  });
}
