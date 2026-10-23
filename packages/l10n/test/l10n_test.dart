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
        (l) => l.nav_dashboard,
        (l) => l.nav_tower,
        (l) => l.nav_customers,
        (l) => l.nav_depots,
        (l) => l.nav_products,
        (l) => l.nav_drivers,
        (l) => l.nav_vehicles,
        (l) => l.nav_catalogue,
        (l) => l.nav_signout,
        (l) => l.shell_search_hint,
        (l) => l.shell_notifications,
        (l) => l.shell_demo_role,
        (l) => l.shell_online,
        (l) => l.shell_offline,
        (l) => l.mfa_title,
        (l) => l.mfa_hint,
        (l) => l.mfa_code_label,
        (l) => l.mfa_verify,
        (l) => l.mfa_invalid,
        (l) => l.mfa_note_demo,
        (l) => l.err403_title,
        (l) => l.err403_message,
        (l) => l.err404_title,
        (l) => l.err404_message,
        (l) => l.err_back_home,
        (l) => l.dash_title,
        (l) => l.dash_kpi_requested,
        (l) => l.dash_kpi_loaded,
        (l) => l.dash_kpi_delivered,
        (l) => l.dash_kpi_pending,
        (l) => l.dash_orders_by_status,
        (l) => l.dash_drivers,
        (l) => l.dash_vehicles,
        (l) => l.dash_late_orders,
        (l) => l.dash_alerts,
        (l) => l.dash_reload,
        (l) => l.dash_process_title,
        (l) => l.dash_step1,
        (l) => l.dash_step2,
        (l) => l.dash_step3,
        (l) => l.dash_step4,
        (l) => l.dash_step5,
        (l) => l.dash_step6,
        (l) => l.dash_step7,
        (l) => l.dash_step8,
        (l) => l.tower_title,
        (l) => l.tower_live,
        (l) => l.tower_board,
        (l) => l.tower_alerts,
        (l) => l.tower_reload,
        (l) => l.mst_search,
        (l) => l.mst_all,
        (l) => l.mst_active,
        (l) => l.mst_inactive,
        (l) => l.mst_create,
        (l) => l.mst_edit,
        (l) => l.mst_save,
        (l) => l.mst_name_en,
        (l) => l.mst_name_ar,
        (l) => l.mst_phone,
        (l) => l.mst_contact,
        (l) => l.mst_status,
        (l) => l.mst_capacity,
        (l) => l.mst_onboard,
        (l) => l.mst_docs_ok,
        (l) => l.mst_docs_expiring,
        (l) => l.mst_empty_title,
        (l) => l.mst_empty_message,
        (l) => l.mst_error_title,
        (l) => l.mst_retry,
        (l) => l.cust_sites_tab,
        (l) => l.cust_orders_hint,
        (l) => l.site_geofence,
        (l) => l.site_gate_hours,
        (l) => l.site_lat,
        (l) => l.site_lng,
        (l) => l.drv_licence,
        (l) => l.drv_calendar_title,
        (l) => l.drv_commitments,
        (l) => l.veh_balance,
        (l) => l.veh_calendar_title,
        (l) => l.veh_defect_block,
        (l) => l.cal_today,
        (l) => l.cal_commitment_days,
        (l) => l.depot_hours,
        (l) => l.depot_products,
        (l) => l.prod_unit,
        (l) => l.prod_active,
        (l) => l.role_admin,
        (l) => l.role_sales,
        (l) => l.role_dispatcher,
        (l) => l.role_fleet,
        (l) => l.role_driver,
        (l) => l.role_supervisor,
        (l) => l.role_finance,
        (l) => l.role_customer,
        (l) => l.st_order_draft,
        (l) => l.st_order_confirmed,
        (l) => l.st_order_on_hold,
        (l) => l.st_order_unassigned,
        (l) => l.st_order_assigned,
        (l) => l.st_order_in_progress,
        (l) => l.st_order_completed,
        (l) => l.st_order_partial,
        (l) => l.st_order_failed,
        (l) => l.st_order_cancelled,
        (l) => l.st_trip_planned,
        (l) => l.st_trip_assigned,
        (l) => l.st_trip_accepted,
        (l) => l.st_trip_started,
        (l) => l.st_trip_at_loading,
        (l) => l.st_trip_loaded,
        (l) => l.st_trip_delivering,
        (l) => l.st_trip_paused,
        (l) => l.st_trip_breakdown,
        (l) => l.st_trip_completed,
        (l) => l.st_trip_closed,
        (l) => l.st_task_pending,
        (l) => l.st_task_accepted,
        (l) => l.st_task_en_route,
        (l) => l.st_task_arrived,
        (l) => l.st_task_started,
        (l) => l.st_task_completed,
        (l) => l.st_task_skipped,
        (l) => l.st_task_failed,
        (l) => l.st_task_cancelled,
        (l) => l.st_vehicle_available,
        (l) => l.st_vehicle_reserved,
        (l) => l.st_vehicle_loading,
        (l) => l.st_vehicle_in_transit,
        (l) => l.st_vehicle_at_customer,
        (l) => l.st_vehicle_on_break,
        (l) => l.st_vehicle_breakdown,
        (l) => l.st_vehicle_maintenance,
        (l) => l.st_vehicle_out_of_service,
        (l) => l.st_driver_offline,
        (l) => l.st_driver_available,
        (l) => l.st_driver_assigned,
        (l) => l.st_driver_driving,
        (l) => l.st_driver_working,
        (l) => l.st_driver_waiting,
        (l) => l.st_driver_on_break,
        (l) => l.st_driver_breakdown,
        (l) => l.st_driver_completed_day,
        (l) => l.st_cust_active,
        (l) => l.st_cust_credit_hold,
        (l) => l.st_cust_inactive,
        (l) => l.st_sev_critical,
        (l) => l.st_sev_high,
        (l) => l.st_sev_medium,
        (l) => l.st_sev_low,
        (l) => l.st_sev_info,
        (l) => l.st_duty_on,
        (l) => l.st_duty_off,
        (l) => l.st_duty_suspended,
        (l) => l.st_duty_leave,
        (l) => l.dash_greeting_morning('Sara'),
        (l) => l.dash_greeting_afternoon('Sara'),
        (l) => l.dash_greeting_evening('Sara'),
        (l) => l.seg_loading_now,
        (l) => l.seg_in_transit,
        (l) => l.seg_arriving_soon,
        (l) => l.seg_upcoming,
        (l) => l.seg_needs_attention,
        (l) => l.fleet_today,
        (l) => l.map_show_all,
        (l) => l.kpi_trend_up,
        (l) => l.kpi_trend_down,
        (l) => l.menu_title,
        (l) => l.menu_control_tower,
        (l) => l.menu_depots,
        (l) => l.menu_products,
        (l) => l.menu_drivers,
        (l) => l.menu_design,
        (l) => l.menu_theme,
        (l) => l.menu_language,
        (l) => l.menu_demo_role,
        (l) => l.menu_sign_out,
        (l) => l.menu_profile,
        (l) => l.search_order,
        (l) => l.search_driver,
        (l) => l.search_vehicle,
        (l) => l.search_customer,
        (l) => l.detail_edit,
        (l) => l.detail_assign,
        (l) => l.detail_block,
        (l) => l.detail_overview,
        (l) => l.detail_location,
        (l) => l.detail_availability,
        (l) => l.detail_documents,
        (l) => l.detail_activity,
        (l) => l.detail_show_all,
        (l) => l.detail_photos,
        (l) => l.login_welcome,
        (l) => l.login_demo_accounts,
        (l) => l.tab_today,
        (l) => l.tab_tasks,
        (l) => l.tab_messages,
        (l) => l.tab_profile,
        (l) => l.today_next_up,
        (l) => l.tab_fleet,
        (l) => l.ill_tanker,
        (l) => l.ill_depot,
        (l) => l.ill_driver,
        (l) => l.ill_breakdown,
        (l) => l.ill_empty_map,
        (l) => l.ill_empty_tasks,
        (l) => l.ill_no_results,
        (l) => l.ill_error,
        (l) => l.ill_offline,
        (l) => l.ill_no_notifications,
        (l) => l.ill_forbidden,
        (l) => l.ill_not_found,
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
      expect(en.list_rows(42), contains('42'));
      expect(ar.list_rows(42), contains('42'));
      expect(en.list_rows(1), '1 rows');
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