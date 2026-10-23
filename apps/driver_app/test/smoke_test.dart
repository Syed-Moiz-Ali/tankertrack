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

/// R3 gate 1 (DR-02): any 6-digit code verifies.
Future<void> _verifyAccount(WidgetTester tester) async {
  expect(find.text('Verify your account'), findsOneWidget);
  await _enter(
      tester, find.widgetWithText(TextFormField, 'Verification code'), '482619');
  await _tapButton(tester, 'Verify');
  await tester.pumpAndSettle();
}

/// R3 gate 2 (DR-03): non-decreasing odometer + location consent starts shift.
Future<void> _startShift(WidgetTester tester) async {
  expect(find.text('Confirm vehicle & start shift'), findsOneWidget);
  await _enter(
      tester, find.widgetWithText(TextFormField, 'Odometer reading'), '128420');
  await tester.pumpAndSettle();
  await tester.tap(find.byType(CheckboxListTile));
  await tester.pumpAndSettle();
  await _tapButton(tester, 'Confirm vehicle & start shift');
  await tester.pumpAndSettle();
}

/// Full happy path: login → DR-02 → DR-03 → tab shell.
Future<void> _loginVerifyAndStart(WidgetTester tester) async {
  await _loginDemoDriver(tester);
  await _verifyAccount(tester);
  await _startShift(tester);
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

  testWidgets('short code stays on DR-02 with error', (tester) async {
    await _loginDemoDriver(tester);
    await _enter(
        tester, find.widgetWithText(TextFormField, 'Verification code'), '12');
    await _tapButton(tester, 'Verify');
    await tester.pumpAndSettle();
    expect(find.text('Wrong code. Try again.'), findsOneWidget);
    expect(find.text('Verify your account'), findsOneWidget);
  });

  testWidgets('login → verify → start shift reaches tab shell', (tester) async {
    await _loginVerifyAndStart(tester);
    expect(find.textContaining('Khalid'), findsOneWidget);
    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Tasks'), findsOneWidget);
    expect(find.text('Messages'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Next up'), findsOneWidget);
    // Same-visual-language sync indicator on the home tab.
    expect(find.text('Synced'), findsOneWidget);
  });

  testWidgets('bottom tabs navigate; profile signs out to login',
      (tester) async {
    await _loginVerifyAndStart(tester);

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

  testWidgets('sign out resets gates: next login lands on DR-02',
      (tester) async {
    await _loginVerifyAndStart(tester);
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    final signOut = find.text('Sign out');
    await tester.scrollUntilVisible(
      signOut,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(signOut);
    await tester.pumpAndSettle();
    // Sign back in: verify gate must hold again (not straight to home).
    await _enter(
        tester, find.widgetWithText(TextFormField, 'Driver ID'), 'DRV-001');
    await _enter(
        tester, find.widgetWithText(TextFormField, 'Driver PIN'), '1234');
    await _tapButton(tester, 'Sign in');
    await tester.pumpAndSettle();
    expect(find.text('Verify your account'), findsOneWidget);
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

  testWidgets('full R3 flow renders AR with RTL tabs', (tester) async {
    await tester.pumpWidget(_app(locale: const Locale('ar')));
    await tester.pumpAndSettle();
    await _enter(
        tester, find.widgetWithText(TextFormField, 'رقم السائق'), 'DRV-001');
    await _enter(
        tester, find.widgetWithText(TextFormField, 'الرقم السري للسائق'), '1234');
    await tester.tap(find.widgetWithText(ElevatedButton, 'دخول'));
    await tester.pumpAndSettle();
    // DR-02 in Arabic.
    expect(find.text('تحقق من حسابك'), findsOneWidget);
    await _enter(
        tester, find.widgetWithText(TextFormField, 'رمز التحقق'), '482619');
    await tester.tap(find.widgetWithText(ElevatedButton, 'تحقق'));
    await tester.pumpAndSettle();
    // DR-03 in Arabic: consent + odometer then confirm.
    expect(find.text('تأكيد المركبة وبدء الوردية'), findsOneWidget);
    await _enter(
        tester, find.widgetWithText(TextFormField, 'قراءة العداد'), '128420');
    await tester.pumpAndSettle();
    await tester.tap(find.byType(CheckboxListTile));
    await tester.pumpAndSettle();
    await tester.tap(
        find.widgetWithText(ElevatedButton, 'تأكيد المركبة وبدء الوردية'));
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
