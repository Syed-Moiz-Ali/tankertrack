import 'package:back_office_web/src/app.dart';
import 'package:back_office_web/src/features/auth/mfa_screen.dart';
import 'package:back_office_web/src/features/tower/tower_screen.dart';
import 'package:back_office_web/src/features/vehicles/vehicle_screens.dart';
import 'package:back_office_web/src/providers.dart';
import 'package:back_office_web/src/router.dart';
import 'package:back_office_web/src/shell/nav_targets.dart';
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
      today: 'today',
      fleet: 'fleet',
      menu: 'menu',
      profile: 'profile',
      theme: 'theme',
      language: 'language',
      demoRole: 'demo role',
      searchHintDrivers: 'drivers',
      searchHintVehicles: 'vehicles',
      searchHintCustomers: 'customers',
      allLabel: 'all',
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

  testWidgets('top nav shows Today/Fleet/Customers/Menu tabs', (tester) async {
    // NOTE: the Fleet tab renders nav_vehicles ("Vehicles") — no tab_fleet
    // ARB key was delivered (see return notes); navigation target is the
    // vehicles route either way.
    await _loginAs(tester, 'dispatch@demo.sa');
    expect(find.text('Today'), findsWidgets);
    expect(find.text('Vehicles'), findsWidgets);
    expect(find.text('Customers'), findsWidgets);
    expect(find.text('Menu'), findsWidgets);
    expect(find.byType(NavigationRail), findsNothing);
  });

  testWidgets('wide list page shows centered search pill', (tester) async {
    await _setWide(tester);
    await _loginAs(tester, 'dispatch@demo.sa');
    expect(find.text('Driver'), findsOneWidget);
    expect(find.text('Vehicle'), findsOneWidget);
    expect(find.text('Customer'), findsOneWidget);
    await tester.tap(find.text('Vehicle'));
    await tester.pumpAndSettle();
    // Full-app tests have no seed bundle override (rootBundle seeds are a
    // main-session concern); assert navigation, not seed-driven cards.
    expect(find.byType(VehicleListScreen), findsWidgets);
  });

  testWidgets('dispatcher menu opens control tower', (tester) async {
    await _loginAs(tester, 'dispatch@demo.sa');
    await tester.tap(find.text('Menu'));
    await tester.pumpAndSettle();
    expect(find.text('Control Tower'), findsWidgets);
    await tester.tap(find.text('Control Tower').first);
    await tester.pumpAndSettle();
    expect(find.byType(ControlTowerScreen), findsOneWidget);
  });

  testWidgets('sales menu hides control tower', (tester) async {
    await _loginAs(tester, 'sales@demo.sa');
    expect(find.text('Vehicles'), findsNothing);
    await tester.tap(find.text('Menu'));
    await tester.pumpAndSettle();
    expect(find.text('Control Tower'), findsNothing);
    expect(find.text('UI catalogue'), findsOneWidget);
  });

  testWidgets('disallowed deep link redirects to 403', (tester) async {
    await _loginAs(tester, 'sales@demo.sa');
    final context = tester.element(find.text('Today').first);
    GoRouter.of(context).go(AppRoutes.drivers);
    await tester.pumpAndSettle();
    expect(find.text('Access denied'), findsWidgets);
    await tester.tap(find.text('Back to home'));
    await tester.pumpAndSettle();
    expect(find.text('Today'), findsWidgets);
  });

  testWidgets('unknown route shows 404 with attempted path', (tester) async {
    await _loginAs(tester, 'dispatch@demo.sa');
    final context = tester.element(find.text('Today').first);
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
    expect(find.text('Today'), findsWidgets);
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

  testWidgets('globe button flips locale and direction', (tester) async {
    // Wide viewport: TTTopNav tabs overflow at 800px in AR (components-slice
    // bug, reported); 1280px fits both locales.
    await _setWide(tester);
    await _loginAs(tester, 'dispatch@demo.sa');
    expect(find.text('Today'), findsWidgets);
    await tester.tap(find.byTooltip('العربية'));
    await tester.pumpAndSettle();
    expect(find.text(AppLocalizationsAr().tab_today), findsWidgets);
    expect(find.text('Today'), findsNothing);
    final directionality = tester
        .element(find.byType(Scaffold).first)
        .getElementForInheritedWidgetOfExactType<Directionality>()
        ?.widget as Directionality?;
    expect(directionality?.textDirection, TextDirection.rtl);
  });

  testWidgets('profile menu demo role switcher changes role', (tester) async {
    await _loginAs(tester, 'dispatch@demo.sa');
    expect(find.text('Vehicles'), findsWidgets);
    await tester.tap(find.byType(TTAvatar).first);
    await tester.pumpAndSettle();
    expect(find.text('Sales'), findsWidgets);
    await tester.tap(find.text('Sales').last);
    await tester.pumpAndSettle();
    expect(find.text('Vehicles'), findsNothing);
    expect(find.text('Customers'), findsWidgets);
  });
}
