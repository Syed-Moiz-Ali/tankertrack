import 'package:back_office_web/src/app.dart';
import 'package:back_office_web/src/features/auth/otp_screen.dart';
import 'package:back_office_web/src/features/design/design_screen.dart';
import 'package:back_office_web/src/providers.dart';
import 'package:design_system/design_system.dart';
import 'package:fleet_ui/fleet_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:l10n/l10n.dart';
import 'package:l10n/src/gen/app_localizations_en.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget _app({Locale locale = const Locale('en')}) {
  SharedPreferences.setMockInitialValues({});
  return ProviderScope(
    overrides: [
      localeProvider.overrideWith((_) => locale),
      // The 15-min idle one-shot trips FakeAsync pumpAndSettle; the dialog
      // itself is covered by shell_test's idle-dialog test.
      idleTimerEnabledProvider.overrideWith((_) => false),
    ],
    child: const BackOfficeApp(),
  );
}

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

/// Drives the R3 flow: credentials → BO-03 OTP → BO-04 role-select →
/// dashboard.
Future<void> _fullLogin(
  WidgetTester tester,
  String email,
  AppLocalizations l10n,
) async {
  await _enter(
    tester,
    find.widgetWithText(TextFormField, l10n.loginEmailLabel),
    email,
  );
  await _enter(
    tester,
    find.widgetWithText(TextFormField, l10n.loginPasswordLabel),
    'demo1234',
  );
  await _tapButton(tester, l10n.loginSignIn);
  await tester.pumpAndSettle();
  final boxes = find.byType(TextFormField);
  const code = '123456';
  for (var i = 0; i < 6; i++) {
    await tester.enterText(boxes.at(i), code[i]);
  }
  await tester.pumpAndSettle();
  await _tapButton(tester, l10n.loginSignIn);
  await tester.pumpAndSettle();
}

void main() {
  final l10n = AppLocalizationsEn();

  testWidgets('login renders EN; bad creds show error', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();
    expect(find.widgetWithText(ElevatedButton, l10n.loginSignIn),
        findsOneWidget);
    expect(find.text(l10n.login_welcome), findsOneWidget);
    expect(find.byType(TTLogoMark), findsWidgets);
    await _enter(
        tester, find.widgetWithText(TextFormField, l10n.loginEmailLabel), 'dispatch@demo.ae');
    await _enter(
        tester, find.widgetWithText(TextFormField, l10n.loginPasswordLabel), 'wrong');
    await _tapButton(tester, l10n.loginSignIn);
    await tester.pumpAndSettle();
    expect(find.text(l10n.loginFailed), findsOneWidget);
  });

  testWidgets('demo dispatcher login reaches Today', (tester) async {
    // Wide viewport: TTTopBar overflows below ~1400px with the full
    // command hint rendered twice (design_system owns the bar; see return).
    tester.view.physicalSize = const Size(1600, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();
    await _fullLogin(tester, 'dispatch@demo.ae', l10n);
    expect(find.text(l10n.nav_today), findsWidgets);
    expect(find.text(l10n.nav_orders), findsWidgets);
    expect(find.text(l10n.nav_dispatch), findsWidgets);
    expect(find.text(l10n.nav_live), findsWidgets);
    expect(find.text(l10n.nav_fleet), findsWidgets);
    expect(find.text(l10n.nav_more), findsWidgets);
    // Signed-in identity surfaces in the profile menu (seed-driven content
    // stays in skeleton without a bundle override in full-app tests).
    // The top-bar profile cluster is an initials circle (tooltip).
    await tester.tap(find.byTooltip(l10n.menu_profile));
    await tester.pumpAndSettle();
    expect(find.textContaining('Mariam Hassan'), findsWidgets);
  });

  testWidgets('driver creds rejected on office login', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();
    await _enter(
        tester, find.widgetWithText(TextFormField, l10n.loginEmailLabel), 'DRV-001');
    await _enter(
        tester, find.widgetWithText(TextFormField, l10n.loginPasswordLabel), '1234');
    await _tapButton(tester, l10n.loginSignIn);
    await tester.pumpAndSettle();
    expect(find.text(l10n.loginFailed), findsOneWidget);
  });

  testWidgets('forgot password sends reset link', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text(l10n.auth_forgot_title));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.auth_forgot_title));
    await tester.pumpAndSettle();
    expect(find.text(l10n.auth_forgot_title), findsWidgets);
    await _enter(
      tester,
      find.widgetWithText(TextFormField, l10n.loginEmailLabel),
      'dispatch@demo.ae',
    );
    await _tapButton(tester, l10n.auth_forgot_send);
    await tester.pumpAndSettle();
    expect(find.text(l10n.auth_forgot_sent), findsOneWidget);
  });

  testWidgets('OTP boxes auto-verify on sixth digit', (tester) async {
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
          strings: OtpStrings(
            title: l10n.auth_otp_title,
            hint: l10n.auth_otp_hint,
            verify: l10n.auth_otp_verify,
            resend: l10n.auth_otp_resend,
            invalid: l10n.auth_otp_invalid,
          ),
          onVerified: () => verified = true,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final boxes = find.byType(TextFormField);
    expect(boxes, findsNWidgets(6));
    const code = '482619';
    for (var i = 0; i < 6; i++) {
      await tester.enterText(boxes.at(i), code[i]);
    }
    await tester.pumpAndSettle();
    expect(verified, isTrue);
  });

  testWidgets('login renders AR RTL', (tester) async {
    await tester.pumpWidget(_app(locale: const Locale('ar')));
    await tester.pumpAndSettle();
    final ar = await AppLocalizations.delegate.load(const Locale('ar'));
    expect(find.text(ar.login_welcome), findsWidgets);
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
