import 'package:back_office_web/src/app.dart';
import 'package:back_office_web/src/features/auth/mfa_screen.dart';
import 'package:back_office_web/src/providers.dart';
import 'package:back_office_web/src/router.dart';
import 'package:back_office_web/src/shell/nav_targets.dart';
import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n/src/gen/app_localizations_ar.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _loginAs(WidgetTester tester, String email) async {
  await tester.pumpWidget(const ProviderScope(child: BackOfficeApp()));
  await tester.pumpAndSettle();
  await tester.enterText(
    find.widgetWithText(TextFormField, 'Company email'),
    email,
  );
  await tester.enterText(
    find.widgetWithText(TextFormField, 'Password'),
    'demo1234',
  );
  await tester.tap(find.widgetWithText(ElevatedButton, 'Sign in'));
  await tester.pumpAndSettle();
}

Future<void> _setWide(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1280, 800);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('routeRoles matches buildNavTargets roles', () {
    const strings = ShellStrings(
      dashboard: 'dashboard',
      tower: 'tower',
      customers: 'customers',
      depots: 'depots',
      products: 'products',
      drivers: 'drivers',
      vehicles: 'vehicles',
      catalogue: 'catalogue',
      searchHint: 'search',
      signOut: 'sign out',
    );
    final targets = {
      for (final t in buildNavTargets(strings)) t.path: t.roles,
    };
    for (final entry in routeRoles.entries) {
      expect(targets[entry.key], entry.value, reason: entry.key);
    }
  });

  test('sessionPendingMfa defaults to true', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    expect(container.read(sessionPendingMfaProvider), isTrue);
  });

  testWidgets('dispatcher drawer shows control tower', (tester) async {
    await _loginAs(tester, 'dispatch@demo.sa');
    expect(find.text('Dashboard'), findsWidgets);
    await tester.tap(find.byType(DrawerButton));
    await tester.pumpAndSettle();
    expect(find.text('Control Tower'), findsOneWidget);
    expect(find.text('Customers'), findsOneWidget);
  });

  testWidgets('sales drawer hides control tower', (tester) async {
    await _loginAs(tester, 'sales@demo.sa');
    expect(find.text('Dashboard'), findsWidgets);
    await tester.tap(find.byType(DrawerButton));
    await tester.pumpAndSettle();
    expect(find.text('Control Tower'), findsNothing);
    expect(find.text('Customers'), findsOneWidget);
  });

  testWidgets('disallowed deep link redirects to 403', (tester) async {
    await _loginAs(tester, 'sales@demo.sa');
    final context = tester.element(find.text('Dashboard').first);
    GoRouter.of(context).go(AppRoutes.drivers);
    await tester.pumpAndSettle();
    expect(find.text('Access denied'), findsWidgets);
    await tester.tap(find.text('Back to home'));
    await tester.pumpAndSettle();
    expect(find.text('Dashboard'), findsWidgets);
  });

  testWidgets('unknown route shows 404 with attempted path', (tester) async {
    await _loginAs(tester, 'dispatch@demo.sa');
    final context = tester.element(find.text('Dashboard').first);
    GoRouter.of(context).go('/nope-xyz');
    await tester.pumpAndSettle();
    expect(find.text('Page not found'), findsWidgets);
    expect(find.text('/nope-xyz'), findsOneWidget);
  });

  testWidgets('admin login lands on MFA; demo code accepts', (tester) async {
    await _loginAs(tester, 'admin@demo.sa');
    expect(find.text('Two-step verification'), findsWidgets);
    final context = tester.element(find.text('Two-step verification').first);
    final container = ProviderScope.containerOf(context);
    expect(container.read(sessionPendingMfaProvider), isTrue);
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Verification code'),
      '123456',
    );
    await tester.tap(find.widgetWithText(ElevatedButton, 'Verify'));
    await tester.pumpAndSettle();
    expect(container.read(sessionPendingMfaProvider), isFalse);
    expect(find.text('Dashboard'), findsWidgets);
  });

  testWidgets('MFA screen rejects short code with error banner', (tester) async {
    var verified = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.build(
          surface: AppSurface.web,
          brightness: Brightness.light,
          arabic: false,
        ),
        home: MfaScreen(
          strings: const MfaStrings(
            title: 'MFA',
            hint: 'Enter code',
            codeLabel: 'Code',
            verify: 'Verify',
            invalid: 'Bad code',
            noteDemo: 'Demo note',
          ),
          onVerified: () => verified = true,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextFormField, 'Code'), '12');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Verify'));
    await tester.pumpAndSettle();
    expect(find.text('Bad code'), findsOneWidget);
    expect(verified, isFalse);
  });

  testWidgets('MFA screen accepts any 6-digit demo code', (tester) async {
    var verified = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.build(
          surface: AppSurface.web,
          brightness: Brightness.light,
          arabic: false,
        ),
        home: MfaScreen(
          strings: const MfaStrings(
            title: 'MFA',
            hint: 'Enter code',
            codeLabel: 'Code',
            verify: 'Verify',
            invalid: 'Bad code',
            noteDemo: 'Demo note',
          ),
          onVerified: () => verified = true,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Code'),
      '654321',
    );
    await tester.tap(find.widgetWithText(ElevatedButton, 'Verify'));
    await tester.pumpAndSettle();
    expect(verified, isTrue);
  });

  testWidgets('language switch flips title and direction', (tester) async {
    await _loginAs(tester, 'dispatch@demo.sa');
    expect(find.text('Dashboard'), findsWidgets);
    await tester.tap(find.text('العربية'));
    await tester.pumpAndSettle();
    expect(find.text(AppLocalizationsAr().dash_title), findsWidgets);
    expect(find.text('Dashboard'), findsNothing);
    final directionality = tester
        .element(find.byType(Scaffold).first)
        .getElementForInheritedWidgetOfExactType<Directionality>()
        ?.widget as Directionality?;
    expect(directionality?.textDirection, TextDirection.rtl);
  });

  testWidgets('demo role switcher changes role for review', (tester) async {
    await _setWide(tester);
    await _loginAs(tester, 'dispatch@demo.sa');
    expect(find.text('Control Tower'), findsWidgets);
    await tester.tap(
      find.byWidgetPredicate((w) => w is TTDropdown<Role>),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sales').last);
    await tester.pumpAndSettle();
    expect(find.text('Sales'), findsWidgets);
    expect(find.text('Control Tower'), findsNothing);
  });
}
