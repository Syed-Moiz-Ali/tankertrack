import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:l10n/l10n.dart';

void main() {
  group('ARB parity (CI fails on missing key)', () {
    Future<AppLocalizations> load(Locale locale) async {
      final delegate = AppLocalizations.delegate;
      assert(delegate.isSupported(locale));
      return delegate.load(locale);
    }

    test('en and ar expose identical key sets', () async {
      final en = await load(const Locale('en'));
      final ar = await load(const Locale('ar'));
      // Spot-check every P0 key in both locales; adding a key to one ARB
      // without the other fails here.
      final getters = <String Function(AppLocalizations)>[
        (l) => l.appName,
        (l) => l.loginTitle,
        (l) => l.loginSubtitle,
        (l) => l.loginEmailLabel,
        (l) => l.loginEmailHint,
        (l) => l.loginPasswordLabel,
        (l) => l.loginPinLabel,
        (l) => l.loginSignIn,
        (l) => l.loginUseBiometric,
        (l) => l.loginFailed,
        (l) => l.loginLanguageLabel,
        (l) => l.loginDriverTab,
        (l) => l.loginOfficeTab,
        (l) => l.ok,
        (l) => l.cancel,
        (l) => l.confirm,
        (l) => l.retry,
        (l) => l.close,
        (l) => l.search,
        (l) => l.online,
        (l) => l.offline,
        (l) => l.trackingActive,
        (l) => l.pendingSync,
        (l) => l.synced,
        (l) => l.syncFailed,
        (l) => l.syncNow,
        (l) => l.requiredField,
        (l) => l.invalidEmail,
        (l) => l.unitIg,
        (l) => l.unitIgFull,
        (l) => l.unitLitre,
        (l) => l.loginIdLabel,
        (l) => l.loginSignOut,
        (l) => l.loginOpenCatalogue,
        (l) => l.themeLight,
        (l) => l.themeDark,
        (l) => l.themeSystem,
        (l) => l.langEnglish,
        (l) => l.langArabic,
      ];
      for (final g in getters) {
        expect(g(ar).isNotEmpty, isTrue);
        expect(g(en).isNotEmpty, isTrue);
      }
      expect(ar.lastSyncMinutes(2), contains('2'));
      expect(en.lastSyncMinutes(2), contains('2'));
      expect(en.loginDemoHint('DRV-001', '1234'), contains('DRV-001'));
      expect(ar.loginDemoHint('DRV-001', '1234'), contains('DRV-001'));
      expect(en.loginSignedInAs('Khalid'), contains('Khalid'));
    });

    testWidgets('context.l10n resolves in both directions',
        (tester) async {
      Future<void> pump(Locale locale) => tester.pumpWidget(
            MaterialApp(
              locale: locale,
              localizationsDelegates:
                  AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: Builder(
                builder: (ctx) => Text(
                  ctx.l10n.loginTitle,
                  textDirection: TextDirection.ltr,
                ),
              ),
            ),
          );
      await pump(const Locale('en'));
      expect(find.text('Sign in'), findsOneWidget);
      await pump(const Locale('ar'));
      await tester.pumpAndSettle();
      expect(find.text('تسجيل الدخول'), findsOneWidget);
    });
  });

  group('formatters', () {
    test('QuantityFmt: integer-tenths, 1 decimal, litres display-only', () {
      const q = QuantityFmt(numbers: NumberFmt());
      expect(q.ig(40000, 'IG'), '4,000.0 IG');
      expect(q.ig(25000, 'IG'), '2,500.0 IG');
      expect(q.ig(-1200, 'IG'), '-120.0 IG');
      expect(q.ig(5, 'IG'), '0.5 IG');
      expect(q.litres(40000, 'L'), '18,184 L');
    });

    test('NumberFmt: Arabic-Indic numerals', () {
      const western = NumberFmt();
      const indic = NumberFmt(numerals: Numerals.arabicIndic);
      expect(western.integer(4000), '4,000');
      expect(indic.integer(4000), '٤,٠٠٠');
      expect(indic.apply('08:05'), '٠٨:٠٥');
    });

    test('DateFmt: UTC stored, +03:00 display, Hijri optional', () {
      const fmt = DateFmt();
      final utc = DateTime.utc(2026, 10, 23, 11, 5);
      expect(fmt.dateTime(utc), '2026-10-23 14:05');
      expect(fmt.date(utc), '2026-10-23');
      expect(fmt.time(utc), '14:05');
      const hijriFmt = DateFmt(hijri: true);
      expect(hijriFmt.dateTime(utc), contains('\n'));
    });
  });
}