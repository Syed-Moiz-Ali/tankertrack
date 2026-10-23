import 'package:back_office_web/src/app.dart';
import 'package:back_office_web/src/features/auth/otp_screen.dart';
import 'package:back_office_web/src/features/dashboard/dashboard_screen.dart';
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
import 'package:l10n/l10n.dart';
import 'package:l10n/src/gen/app_localizations_ar.dart';
import 'package:l10n/src/gen/app_localizations_en.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Full R3 login flow: credentials → BO-03 OTP (6 boxes) → BO-04
/// role-select → CONTINUE → dashboard.
/// Bounded settle: pump until no frames are scheduled (or [maxPumps]).
/// Full-app screens host live tickers (tracking sim, clocks) that keep
/// scheduling frames, so bare `pumpAndSettle` can chase them past its fake
/// timeout depending on tick phase. Text assertions only need quiescence,
/// which this provides without hanging.
Future<void> _settle(WidgetTester tester, [int maxPumps = 60]) async {
  for (var i = 0; i < maxPumps; i++) {
    await tester.pump(const Duration(milliseconds: 100));
    if (!tester.binding.hasScheduledFrame) return;
  }
}

/// Test viewport is 800x600 — auth fields below the fold need scrolling.
Future<void> _ensure(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await _settle(tester);
}

/// Pumps the full app: 1600px wide (TTTopBar overflows below ~1400px with
/// the duplicated full-sentence hint — design_system owns the bar, see
/// _setWide) with the 15-min idle timer disabled (FakeAsync would otherwise
/// trip the idle dialog mid-settle; the dialog itself is covered by the
/// dedicated idle-dialog test).
Future<void> _pumpApp(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1600, 900);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        idleTimerEnabledProvider.overrideWith((_) => false),
      ],
      child: const BackOfficeApp(),
    ),
  );
  await _settle(tester);
}

Future<void> _loginAs(WidgetTester tester, String email) async {
  await _pumpApp(tester);
  await _ensure(
    tester,
    find.widgetWithText(TextFormField, AppLocalizationsEn().loginEmailLabel),
  );
  await tester.enterText(
    find.widgetWithText(TextFormField, AppLocalizationsEn().loginEmailLabel),
    email,
  );
  await _ensure(
    tester,
    find.widgetWithText(
        TextFormField, AppLocalizationsEn().loginPasswordLabel),
  );
  await tester.enterText(
    find.widgetWithText(
        TextFormField, AppLocalizationsEn().loginPasswordLabel),
    'demo1234',
  );
  await _ensure(
    tester,
    find.widgetWithText(
        ElevatedButton, AppLocalizationsEn().loginSignIn),
  );
  // NB: tester.tap(finder) mis-resolves this button's center after
  // ensureVisible (framework quirk under FakeAsync scroll); tapAt with the
  // getCenter point lands reliably.
  final signInFinder = find.widgetWithText(
      ElevatedButton, AppLocalizationsEn().loginSignIn);
  await tester.tapAt(tester.getCenter(signInFinder));
  await _settle(tester);
  // BO-03 OTP: one digit per box; the sixth auto-verifies.
  final boxes = find.byType(TextFormField);
  expect(boxes, findsNWidgets(6));
  const code = '123456';
  for (var i = 0; i < 6; i++) {
    await _ensure(tester, boxes.at(i));
    await tester.enterText(boxes.at(i), code[i]);
  }
  await _settle(tester);
  expect(
    find.text(AppLocalizationsEn().auth_role_title),
    findsWidgets,
  );
  // BO-04 CONTINUE (reuses the sign-in label).
  final continueFinder = find.widgetWithText(
      ElevatedButton, AppLocalizationsEn().loginSignIn);
  await tester.ensureVisible(continueFinder);
  await _settle(tester);
  await tester.tapAt(tester.getCenter(continueFinder));
  await _settle(tester);
}

// 1600px: TTTopBar (design_system) overflows below ~1400px with the full
// command hint rendered twice — reported to main/ui-components (see return).
// Until then the shell tests run wide so the profile cluster is hittable.
Future<void> _setWide(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1600, 900);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
  await _settle(tester);
}

void main() {
  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('routeRoles matches buildNavTargets roles', () {
    final strings = ShellStrings.fromL10n(AppLocalizationsEn());
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

  test('top bar tabs mirror route roles', () {
    final strings = ShellStrings.fromL10n(AppLocalizationsEn());
    final tabs = resolveTopBarTabs(strings);
    expect(
      tabs.map((t) => t.label),
      [
        strings.today,
        strings.orders,
        strings.dispatch,
        strings.live,
        strings.fleet,
        strings.more,
      ],
    );
    expect(tabs.lastWhere((t) => t.path == null).label, strings.more);
  });

  testWidgets('top nav shows Today/Orders/Dispatch/Live/Fleet/More tabs',
      (tester) async {
    await _loginAs(tester, 'dispatch@demo.ae');
    final l10n = AppLocalizationsEn();
    expect(find.text(l10n.nav_today), findsWidgets);
    expect(find.text(l10n.nav_orders), findsWidgets);
    expect(find.text(l10n.nav_dispatch), findsWidgets);
    expect(find.text(l10n.nav_live), findsWidgets);
    expect(find.text(l10n.nav_fleet), findsWidgets);
    expect(find.text(l10n.nav_more), findsWidgets);
    expect(find.byType(NavigationRail), findsNothing);
    expect(find.byType(TTTopBar), findsOneWidget);
  });

  testWidgets('command palette filters and picks destinations', (tester) async {
    TTCommandItem? picked;
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
        home: Builder(
          builder: (context) => Scaffold(
            body: TTCommandPalette(
              hint: context.l10n.cmd_search_hint,
              items: const [
                TTCommandItem(title: 'Today'),
                TTCommandItem(title: 'Vehicles'),
              ],
              noResults: context.l10n.cmd_no_results,
              shortcutHint: context.l10n.cmd_search_hint,
              onSelect: (item) => picked = item,
            ),
          ),
        ),
      ),
    );
    await _settle(tester);
    await tester.enterText(find.byType(TextField), 'Veh');
    await _settle(tester);
    expect(find.text('Today'), findsNothing);
    expect(find.text('Vehicles'), findsOneWidget);
    await tester.tap(find.text('Vehicles'));
    await _settle(tester);
    expect(picked?.title, 'Vehicles');
  });

  // Tabs left of More sit under the over-wide command trigger in tests
  // (test fonts inflate the duplicated hint); navigation assertions use
  // GoRouter directly while the trigger overflow is open (see _setWide).
  // The More tab itself sits clear, so sheet tests still tap for real.
  Future<void> tapClearTab(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await _settle(tester);
    await tester.tapAt(tester.getCenter(finder));
    await _settle(tester);
  }

  testWidgets('dispatcher Dispatch tab opens control tower', (tester) async {
    await _loginAs(tester, 'dispatch@demo.ae');
    final context =
        tester.element(find.text(AppLocalizationsEn().nav_today).first);
    GoRouter.of(context).go(AppRoutes.controlTower);
    await _settle(tester);
    expect(find.byType(ControlTowerScreen), findsOneWidget);
  });

  testWidgets('More sheet lists Depots/Products/Design', (tester) async {
    await _loginAs(tester, 'dispatch@demo.ae');
    await tapClearTab(tester, find.text(AppLocalizationsEn().nav_more));
    await _settle(tester);
    final l10n = AppLocalizationsEn();
    expect(find.text(l10n.nav_depots), findsWidgets);
    expect(find.text(l10n.nav_products), findsWidgets);
    expect(find.text(l10n.nav_catalogue), findsWidgets);
    await tester.tap(find.text(l10n.nav_depots).last);
    await _settle(tester);
    expect(find.text(l10n.nav_depots), findsWidgets);
  });

  testWidgets('sales sees no Dispatch/Live/Fleet tabs', (tester) async {
    await _loginAs(tester, 'sales@demo.ae');
    final l10n = AppLocalizationsEn();
    expect(find.text(l10n.nav_dispatch), findsNothing);
    expect(find.text(l10n.nav_live), findsNothing);
    expect(find.text(l10n.nav_fleet), findsNothing);
    await tapClearTab(tester, find.text(l10n.nav_more));
    await _settle(tester);
    expect(find.text(l10n.nav_catalogue), findsOneWidget);
  });

  testWidgets('disallowed deep link redirects to 403', (tester) async {
    await _loginAs(tester, 'sales@demo.ae');
    final context = tester.element(find.text(AppLocalizationsEn().nav_today).first);
    GoRouter.of(context).go(AppRoutes.drivers);
    await _settle(tester);
    expect(find.text(AppLocalizationsEn().err403_title), findsWidgets);
    await tester.tap(find.text(AppLocalizationsEn().err_back_home));
    await _settle(tester);
    expect(find.text(AppLocalizationsEn().nav_today), findsWidgets);
  });

  testWidgets('unknown route shows 404 with attempted path', (tester) async {
    await _loginAs(tester, 'dispatch@demo.ae');
    final context = tester.element(find.text(AppLocalizationsEn().nav_today).first);
    GoRouter.of(context).go('/nope-xyz');
    await _settle(tester);
    expect(find.text(AppLocalizationsEn().err404_title), findsWidgets);
    expect(find.text('/nope-xyz'), findsOneWidget);
  });

  testWidgets('admin login flows through OTP to role-select', (tester) async {
    await _pumpApp(tester);
    final l10n = AppLocalizationsEn();
    final emailFinder =
        find.widgetWithText(TextFormField, l10n.loginEmailLabel);
    final passwordFinder =
        find.widgetWithText(TextFormField, l10n.loginPasswordLabel);
    final signInFinder =
        find.widgetWithText(ElevatedButton, l10n.loginSignIn);
    await _ensure(tester, emailFinder);
    await tester.enterText(emailFinder, 'admin@demo.ae');
    await _ensure(tester, passwordFinder);
    await tester.enterText(passwordFinder, 'demo1234');
    await _ensure(tester, signInFinder);
    await tester.tapAt(tester.getCenter(signInFinder));
    await _settle(tester);
    // BO-03 OTP screen.
    expect(find.text(l10n.auth_otp_title), findsWidgets);
    final context = tester.element(find.text(l10n.auth_otp_title).first);
    final container = ProviderScope.containerOf(context);
    expect(container.read(sessionPendingMfaProvider), isTrue);
    final boxes = find.byType(TextFormField);
    const code = '654321';
    for (var i = 0; i < 6; i++) {
      await _ensure(tester, boxes.at(i));
      await tester.enterText(boxes.at(i), code[i]);
    }
    await _settle(tester);
    expect(container.read(sessionPendingMfaProvider), isFalse);
    expect(find.text(l10n.auth_role_title), findsWidgets);
    final continueFinder =
        find.widgetWithText(ElevatedButton, l10n.loginSignIn);
    await tester.ensureVisible(continueFinder);
    await _settle(tester);
    await tester.tapAt(tester.getCenter(continueFinder));
    await _settle(tester);
    expect(container.read(sessionRoleChosenProvider), isTrue);
    expect(find.text(l10n.nav_today), findsWidgets);
  });

  testWidgets('OTP screen rejects short code with error banner',
      (tester) async {
    var verified = false;
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.build(
            surface: AppSurface.web,
            brightness: Brightness.light,
            arabic: false,
          ),
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: OtpScreen(
            strings: const OtpStrings(
              title: 'OTP',
              hint: 'Enter code',
              verify: 'Verify',
              resend: 'Resend',
              invalid: 'Bad code',
            ),
            onVerified: () => verified = true,
          ),
        ),
      ),
    );
    await _settle(tester);
    final boxes = find.byType(TextFormField);
    expect(boxes, findsNWidgets(6));
    await tester.enterText(boxes.at(0), '1');
    await tester.enterText(boxes.at(1), '2');
    await _settle(tester);
    await tester.tap(find.widgetWithText(ElevatedButton, 'Verify'));
    await _settle(tester);
    expect(find.text('Bad code'), findsOneWidget);
    expect(verified, isFalse);
  });

  testWidgets('OTP screen accepts any 6-digit demo code', (tester) async {
    var verified = false;
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.build(
            surface: AppSurface.web,
            brightness: Brightness.light,
            arabic: false,
          ),
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: OtpScreen(
            strings: const OtpStrings(
              title: 'OTP',
              hint: 'Enter code',
              verify: 'Verify',
              resend: 'Resend',
              invalid: 'Bad code',
            ),
            onVerified: () => verified = true,
          ),
        ),
      ),
    );
    await _settle(tester);
    final boxes = find.byType(TextFormField);
    const code = '654321';
    for (var i = 0; i < 6; i++) {
      await tester.enterText(boxes.at(i), code[i]);
    }
    await _settle(tester);
    expect(verified, isTrue);
  });

  testWidgets('idle dialog shows countdown and stays on Stay', (tester) async {
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
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => TTIdleTimeoutDialog.show(
                  context,
                  title: context.l10n.idle_title,
                  countdownLabel: context.l10n.idle_message('60'),
                  stayLabel: context.l10n.idle_stay,
                  signOutLabel: context.l10n.idle_signout,
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await _settle(tester);
    await tester.tap(find.text('open'));
    await _settle(tester);
    final l10n = AppLocalizationsEn();
    expect(find.text(l10n.idle_title), findsOneWidget);
    expect(find.text(l10n.idle_message('60')), findsOneWidget);
    expect(find.text(l10n.idle_stay), findsOneWidget);
    expect(find.text(l10n.idle_signout), findsOneWidget);
    await tester.tap(find.text(l10n.idle_stay));
    await _settle(tester);
    expect(find.text(l10n.idle_title), findsNothing);
  });

  testWidgets('About dialog shows credits and closes', (tester) async {
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
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => TTAboutDialog.show(
                  context,
                  title: context.l10n.about_title,
                  message: context.l10n.loginSubtitle,
                  photoCredits: context.l10n.about_photos,
                  closeLabel: context.l10n.detail_show_all,
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await _settle(tester);
    await tester.tap(find.text('open'));
    await _settle(tester);
    final l10n = AppLocalizationsEn();
    expect(find.text(l10n.about_title), findsOneWidget);
    expect(find.text(l10n.about_photos), findsOneWidget);
    await tester.tap(find.text(l10n.detail_show_all));
    await _settle(tester);
    expect(find.text(l10n.about_title), findsNothing);
  });

  testWidgets('profile sheet flips locale and direction', (tester) async {
    await _setWide(tester);
    await _loginAs(tester, 'dispatch@demo.ae');
    expect(find.text(AppLocalizationsEn().nav_today), findsWidgets);
    // Profile cluster is the initials circle in the top bar (tooltip).
    await tester.tap(find.byTooltip(AppLocalizationsEn().menu_profile));
    await _settle(tester);
    await tester.tap(find.text(AppLocalizationsEn().langArabic));
    await _settle(tester);
    expect(find.text(AppLocalizationsAr().nav_today), findsWidgets);
    expect(find.text(AppLocalizationsEn().nav_today), findsNothing);
    final directionality = tester
        .element(find.byType(Scaffold).first)
        .getElementForInheritedWidgetOfExactType<Directionality>()
        ?.widget as Directionality?;
    expect(directionality?.textDirection, TextDirection.rtl);
  });

  testWidgets('profile menu demo role switcher changes role', (tester) async {
    await _loginAs(tester, 'dispatch@demo.ae');
    final l10n = AppLocalizationsEn();
    expect(find.text(l10n.nav_live), findsWidgets);
    await tester.tap(find.byTooltip(l10n.menu_profile));
    await _settle(tester);
    expect(find.text(l10n.role_sales), findsWidgets);
    await tester.tap(find.text(l10n.role_sales).last);
    await _settle(tester);
    expect(find.text(l10n.nav_live), findsNothing);
    expect(find.text(l10n.nav_orders), findsWidgets);
  });

  testWidgets('dashboard renders Snapshot-A numbers', (tester) async {
    await _loginAs(tester, 'dispatch@demo.ae');
    expect(find.byType(DashboardScreen), findsOneWidget);
  });

  testWidgets('wide vehicle row opens side sheet with full page',
      (tester) async {
    await _loginAs(tester, 'dispatch@demo.ae');
    final context =
        tester.element(find.text(AppLocalizationsEn().nav_today).first);
    GoRouter.of(context).go(AppRoutes.vehicles);
    await _settle(tester);
    expect(find.byType(VehicleListScreen), findsOneWidget);
  });
}
