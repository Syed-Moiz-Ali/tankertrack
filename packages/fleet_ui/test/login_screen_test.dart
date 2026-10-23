import 'package:fleet_ui/fleet_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _strings = AuthStrings(
  title: 'Sign in',
  subtitle: 'Diesel Delivery & Fleet Tracking',
  idLabel: 'Driver ID',
  idHint: 'DRV-001',
  secretLabel: 'PIN',
  signIn: 'Sign in',
  failed: 'Sign-in failed.',
  requiredField: 'Required',
  demoHint: 'Demo: DRV-001 / 1234',
  appInitials: 'TT',
);

Widget _harness({
  Future<String?> Function(String, String)? onSignIn,
}) =>
    MaterialApp(
      theme: AppTheme.build(
        surface: AppSurface.driver,
        brightness: Brightness.light,
        arabic: false,
      ),
      home: Scaffold(
        body: LoginScreen(
          strings: _strings,
          onSignIn: onSignIn ?? (_, __) async => null,
          languageSwitch: const SizedBox.shrink(),
        ),
      ),
    );

void main() {
  testWidgets('empty submit shows required validation', (tester) async {
    await tester.pumpWidget(_harness());
    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign in'));
    await tester.pump();
    expect(find.text('Required'), findsNWidgets(2));
  });

  testWidgets('failed login shows critical banner', (tester) async {
    await tester.pumpWidget(
        _harness(onSignIn: (_, __) async => 'Invalid credentials'));
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Driver ID'), 'DRV-001');
    await tester.enterText(find.widgetWithText(TextFormField, 'PIN'), '0000');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign in'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Sign-in failed.'), findsOneWidget);
  });

  testWidgets('successful login calls through (no banner)', (tester) async {
    var called = false;
    await tester.pumpWidget(_harness(onSignIn: (id, secret) async {
      called = true;
      expect(id, 'DRV-001');
      expect(secret, '1234');
      return null;
    }));
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Driver ID'), 'DRV-001');
    await tester.enterText(find.widgetWithText(TextFormField, 'PIN'), '1234');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign in'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(called, isTrue);
    expect(find.text('Sign-in failed.'), findsNothing);
  });

  testWidgets('SignedInScreen renders identity + actions', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.build(
          surface: AppSurface.driver,
          brightness: Brightness.light,
          arabic: false,
        ),
        home: Scaffold(
          body: SignedInScreen(
            greeting: 'Signed in as Khalid',
            initials: 'KA',
            roleLabel: 'Driver',
            roleStyle: StatusStyle.active,
            catalogueLabel: 'UI catalogue',
            signOutLabel: 'Sign out',
            onOpenCatalogue: () {},
            onSignOut: () {},
          ),
        ),
      ),
    );
    expect(find.text('Signed in as Khalid'), findsOneWidget);
    expect(find.text('Driver'), findsOneWidget);
    expect(find.text('UI catalogue'), findsOneWidget);
    expect(find.text('Sign out'), findsOneWidget);
  });
}
