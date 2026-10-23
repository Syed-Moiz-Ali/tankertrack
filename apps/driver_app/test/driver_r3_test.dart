import 'package:core/core.dart';
import 'package:data/data.dart';
import 'package:design_system/design_system.dart';
import 'package:driver_app/src/features/common/driver_screen_state.dart';
import 'package:driver_app/src/features/home/home_screen.dart';
import 'package:driver_app/src/features/shift/start_shift_screen.dart';
import 'package:driver_app/src/features/verify/verify_screen.dart';
import 'package:driver_app/src/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:l10n/l10n.dart';

/// R3 ui-driver widget tests: odometer no-decrease, consent gating,
/// companion states, offline/sync indicators. One decision per screen,
/// all copy from ARB (tests are lint-exempt and may assert literals).
Widget _harness(
  Widget home, {
  bool online = true,
  Session? session,
}) =>
    ProviderScope(
      overrides: [
        connectionProvider.overrideWith((_) => online),
        if (session != null) sessionProvider.overrideWith((_) => session),
      ],
      child: MaterialApp(
        theme: AppTheme.build(
          surface: AppSurface.driver,
          brightness: Brightness.light,
          arabic: false,
        ),
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: home,
      ),
    );

const _driver = (
  userId: 'DRV-001',
  displayName: 'Khalid Al-Otaibi',
);

Session _session() => Session(
      userId: _driver.userId,
      displayName: _driver.displayName,
      role: Role.driver,
      driverId: _driver.userId,
    );

ElevatedButton _cta(WidgetTester tester, String label) => tester.widget(
      find.widgetWithText(ElevatedButton, label),
    );

void main() {
  group('odometer validation (DR-03 Figma rule: must not decrease)', () {
    test('parseOdometer tolerates grouping, rejects garbage', () {
      expect(StartShiftScreen.parseOdometer('128420'), 128420);
      expect(StartShiftScreen.parseOdometer('128,420'), 128420);
      expect(StartShiftScreen.parseOdometer('128 420'), 128420);
      expect(StartShiftScreen.parseOdometer(''), isNull);
      expect(StartShiftScreen.parseOdometer('abc'), isNull);
    });

    test('odometerDecreased: equal is allowed, lower is not', () {
      expect(StartShiftScreen.odometerDecreased(128419, 128420), isTrue);
      expect(StartShiftScreen.odometerDecreased(128420, 128420), isFalse);
      expect(StartShiftScreen.odometerDecreased(128421, 128420), isFalse);
    });

    test('canStart requires consent + valid non-decreasing reading', () {
      expect(
        StartShiftScreen.canStart(
            odometer: 128420, last: 128420, consent: true),
        isTrue,
      );
      expect(
        StartShiftScreen.canStart(
            odometer: 128420, last: 128420, consent: false),
        isFalse,
      );
      expect(
        StartShiftScreen.canStart(
            odometer: 128419, last: 128420, consent: true),
        isFalse,
      );
      expect(
        StartShiftScreen.canStart(odometer: null, last: 128420, consent: true),
        isFalse,
      );
    });
  });

  group('DR-03 consent + no-decrease enforced in UI', () {
    testWidgets('CTA disabled until valid odometer + consent', (tester) async {
      await tester.pumpWidget(_harness(const StartShiftScreen()));
      await tester.pumpAndSettle();
      const cta = 'Confirm vehicle & start shift';

      // Empty odometer: required-field hint, CTA disabled.
      expect(find.text('This field is required'), findsOneWidget);
      expect(_cta(tester, cta).onPressed, isNull);

      // Decreased reading: Figma error copy, CTA still disabled.
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Odometer reading'), '128419');
      await tester.pumpAndSettle();
      expect(find.text('Reading cannot be less than yesterday.'),
          findsOneWidget);
      expect(_cta(tester, cta).onPressed, isNull);

      // Valid reading but no consent: still disabled (consent required).
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Odometer reading'), '128,420');
      await tester.pumpAndSettle();
      expect(find.text('Reading cannot be less than yesterday.'), findsNothing);
      expect(_cta(tester, cta).onPressed, isNull);

      // Consent given: CTA enables.
      await tester.tap(find.byType(CheckboxListTile));
      await tester.pumpAndSettle();
      expect(_cta(tester, cta).onPressed, isNotNull);
    });
  });

  group('companion states (dr02_*/dr03_* keys)', () {
    testWidgets('DR-02 empty/loading/error/success render', (tester) async {
      var retried = false;
      Future<void> pump(DriverScreenStatus status) async {
        await tester.pumpWidget(_harness(DriverScreenStateHost(
          status: status,
          emptyTitle: 't',
          emptyMessage: 'TODO dr02_empty',
          errorTitle: 't',
          errorMessage: 'TODO dr02_error',
          retryLabel: 'Retry',
          onRetry: () => retried = true,
          successAnnouncement: 'TODO dr02_success',
          child: const Text('form'),
        )));
        await tester.pumpAndSettle();
      }

      await pump(DriverScreenStatus.empty);
      expect(find.text('TODO dr02_empty'), findsOneWidget);

      await pump(DriverScreenStatus.loading);
      expect(find.byType(TTSkeletonList), findsOneWidget);

      await pump(DriverScreenStatus.error);
      expect(find.text('TODO dr02_error'), findsOneWidget);
      await tester.tap(find.text('Retry'));
      expect(retried, isTrue);

      await pump(DriverScreenStatus.success);
      expect(find.text('form'), findsOneWidget);
    });

    testWidgets('DR-03 screens wire dr03_* placeholders', (tester) async {
      await tester.pumpWidget(
          _harness(const StartShiftScreen(status: DriverScreenStatus.empty)));
      await tester.pumpAndSettle();
      expect(find.text('TODO dr03_empty'), findsOneWidget);

      await tester.pumpWidget(
          _harness(const StartShiftScreen(status: DriverScreenStatus.error)));
      await tester.pumpAndSettle();
      expect(find.text('TODO dr03_error'), findsOneWidget);
    });

    testWidgets('DR-02 screens wire dr02_* placeholders', (tester) async {
      await tester.pumpWidget(
          _harness(const VerifyScreen(status: DriverScreenStatus.empty)));
      await tester.pumpAndSettle();
      expect(find.text('TODO dr02_empty'), findsOneWidget);
    });
  });

  group('offline/sync indicators (same visual language)', () {
    testWidgets('offline shell shows banner + pending badge', (tester) async {
      await tester.pumpWidget(
          _harness(const HomeScreen(), online: false, session: _session()));
      await tester.pumpAndSettle();
      expect(find.text('Offline'), findsWidgets);
      expect(find.text('Pending sync'), findsOneWidget);
    });

    testWidgets('online shell shows synced badge, no banner', (tester) async {
      await tester.pumpWidget(
          _harness(const HomeScreen(), session: _session()));
      await tester.pumpAndSettle();
      expect(find.text('Synced'), findsOneWidget);
      expect(find.text('Offline'), findsNothing);
    });
  });

  group('tabs keep existing ARB keys (mismatch note in slice return)', () {
    testWidgets('Today/Tasks/Messages/Profile labels render', (tester) async {
      await tester.pumpWidget(
          _harness(const HomeScreen(), session: _session()));
      await tester.pumpAndSettle();
      expect(find.text('Today'), findsOneWidget);
      expect(find.text('Tasks'), findsOneWidget);
      expect(find.text('Messages'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });
  });
}
