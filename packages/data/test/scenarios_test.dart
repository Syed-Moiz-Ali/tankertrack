import 'dart:io';

import 'package:data/data.dart';
import 'package:test/test.dart';

/// R3 scenario numbers asserted to the digit (doc 12 + r3-contracts §2).
void main() {
  late SeedBundle seeds;
  late MockScenarioService scenarios;

  setUpAll(() async {
    seeds = await SeedBundle.load(Directory('assets/seeds'));
    scenarios = MockScenarioService(seeds);
  });

  group('Snapshot A (BO-05, doc 12 §1)', () {
    test('KPIs exactly', () async {
      final raw = seeds.table('snapshot_a').single;
      expect(raw['orders'], 87);
      expect(raw['deliveries'], 74);
      expect(raw['completed'], 31);
      expect(raw['active'], 28);
      expect(raw['pending'], 15);
      expect(raw['drivers_active'], 22);
      expect(raw['drivers_total'], 28);
      expect(raw['vehicles_active'], 19);
      expect(raw['vehicles_total'], 24);
      expect(raw['loaded_ig'], 78500);
      expect(raw['delivered_ig'], 46250);
      expect(raw['variance_ig'], 125);
      expect(raw['breakdowns'], 1);
      expect(raw['delayed'], 4);
      final live = raw['live']! as Map<String, Object?>;
      expect(live['loading'], 3);
      expect(live['in_transit'], 9);
      expect(live['at_customer'], 5);
      expect(live['break'], 1);
      expect(live['delayed_subset'], 4);
      expect(live['breakdown'], 1);

      final typed = await scenarios.snapshotA();
      expect(typed.orders, 87);
      expect(typed.deliveries, 74);
      expect(typed.completed, 31);
      expect(typed.active, 28);
      expect(typed.pending, 15);
      expect(typed.driversActive, 22);
      expect(typed.driversTotal, 28);
      expect(typed.vehiclesActive, 19);
      expect(typed.vehiclesTotal, 24);
      expect(typed.loadedIg, 78500);
      expect(typed.deliveredIg, 46250);
      expect(typed.varianceIg, 125);
      expect(typed.breakdowns, 1);
      expect(typed.delayed, 4);
      expect(SnapshotA.fromJson(raw).toJson()['orders'], 87);
    });

    test('hero card A: SO-260145 / Tanker 07 / Ahmed Khan', () async {
      final raw = seeds.table('snapshot_a').single;
      final hero = (raw['hero_card']! as Map).cast<String, Object?>();
      expect(hero['order_id'], 'SO-260145');
      expect(hero['vehicle_id'], 'T-07');
      expect(hero['driver_id'], 'DRV-0028');
      expect(hero['driver_name_en'], 'Ahmed Khan');
      expect(hero['telemetry_ig'], 3520);
      expect(hero['telemetry_is_ledger'], isFalse);
      expect(hero['eta_gst'], '10:42');
      expect((hero['distance_km']! as num).toDouble(), 16.4);
      final typed = await scenarios.snapshotA();
      expect(typed.heroOrderId, 'SO-260145');
      expect(typed.heroTelemetryIg, 3520);
      expect(typed.heroTelemetryIsLedger, isFalse);
      expect(typed.heroEtaGst, '10:42');
      expect(typed.heroDistanceKm, 16.4);
    });

    test('prior order SO-260118 08:45 event present in orders', () {
      final orders = seeds.table('orders_today');
      expect(orders.any((o) => o['order_id'] == 'SO-260118'), isTrue);
      final raw = seeds.table('snapshot_a').single;
      final activity = (raw['activity']! as List).cast<Map<String, Object?>>();
      expect(activity.any((e) => (e['text']! as String).contains('SO-260118')),
          isTrue);
      expect(activity.any((e) => e['at_gst'] == '08:45'), isTrue);
    });
  });

  group('Scenario B ledger (TRIP-260021, doc 12 §3)', () {
    test('chain 5000 → 1500 → 3500 → 2000 → 1500 → 1500 → 0', () async {
      final typed = await scenarios.tripB();
      expect(typed.tripId, 'TRIP-260021');
      expect(typed.loadedIg, 5000);
      expect(typed.abcIg, 1500);
      expect(typed.balanceAfterAbcIg, 3500);
      expect(typed.xyzIg, 2000);
      expect(typed.balanceAfterXyzIg, 1500);
      expect(typed.deltaIg, 1500);
      expect(typed.balanceAfterDeltaIg, 0);
      expect(typed.returnIg, 0);
      expect(typed.closingIg, 0);
      expect(typed.varianceIg, 0);
      expect(typed.distanceKm, 126);
      // Exact integer reconciliation.
      expect(
          typed.loadedIg -
              typed.abcIg -
              typed.xyzIg -
              typed.deltaIg -
              typed.returnIg,
          0);
      final raw = seeds.table('scenario_b_trip').single;
      expect(raw['distance_km'], 126);
      expect((raw['loading']! as Map)['meter_start'], 128400);
      expect((raw['loading']! as Map)['meter_end'], 133400);
      expect((raw['abc_delivery']! as Map)['meter_start'], 42100);
      expect((raw['abc_delivery']! as Map)['meter_end'], 43600);
      expect((raw['depot_return']! as Map)['qty_ig'], 0);
      expect((raw['depot_return']! as Map)['receiver'], 'Yusuf Ibrahim');
    });
  });

  group('Scenario C day (doc 12 §4)', () {
    test('06:00–17:15, 182 km, odometer +27 events', () async {
      final day = await scenarios.dayC();
      expect(day['shift_start_gst'], '06:00');
      expect(day['shift_end_gst'], '17:15');
      expect(day['distance_km'], 182);
      expect(day['main_trip_km'], 126);
      expect(day['depot_yard_km'], 56);
      expect(day['odometer_start_km'], 128420);
      expect(day['odometer_end_km'], 128602);
      expect((day['odometer_end_km']! as int) -
          (day['odometer_start_km']! as int), 182);
      expect(day['events_total'], 27);
      expect((day['events']! as List), hasLength(27));
      final close = day['close']! as Map<String, Object?>;
      expect(close['unsynced'], 0);
      expect(close['receipt'], 'SH-261023-028');
    });
  });

  group('Scenario I incident (doc 12 §5)', () {
    test('Rashid Kareem / Tanker 04 / Fuel Pump Failure', () async {
      final inc = await scenarios.incidentI();
      expect(inc['incident_id'], 'INC-260019');
      expect(inc['driver_name_en'], 'Rashid Kareem');
      expect(inc['vehicle_id'], 'T-04');
      expect(inc['failure'], 'Fuel Pump Failure');
      expect(inc['at_gst'], '10:22');
      expect(inc['acknowledged_at_gst'], '10:24');
      expect(inc['recovery_eta_gst'], '10:55');
      expect(inc['affected_order_id'], 'SO-260151');
      expect(inc['owner'], 'Mariam Hassan');
      expect((inc['lat']! as num).toDouble(), 25.1335);
      expect((inc['lng']! as num).toDouble(), 55.2342);
    });
  });

  group('R-27 exception (doc 12 §6)', () {
    test('4950 − 4700 − 200 − 0 = 50 unexplained', () async {
      final typed = await scenarios.exceptionR27();
      expect(typed.tripId, 'TRIP-260027');
      expect(typed.loadedIg, 4950);
      expect(typed.deliveredIg, 4700);
      expect(typed.returnedIg, 200);
      expect(typed.closingIg, 0);
      expect(typed.unexplainedIg, 50);
      expect(typed.computedUnexplained, 50);
      expect(typed.owner, 'Fatima Ali');
      expect(typed.approvalState, isNotEmpty);
      final raw = seeds.table('scenario_r27_exception').single;
      expect(raw['invoice_id'], 'INV-26027');
      expect(raw['reason'], contains('under investigation'));
    });
  });

  group('Reporting 16–22 Oct (doc 12 §7, separate from live)', () {
    test('aggregates exactly', () async {
      final typed = await scenarios.reportWeek();
      expect(typed.deliveredIg, 412850);
      expect(typed.onTimePct, 96.2);
      expect(typed.deliveriesTotal, 486);
      expect(typed.deliveriesOnTime, 471);
      expect(typed.varianceIg, 125);
      expect(typed.fleetUtilisationPct, 84.7);
      expect(typed.dailyBars, [51000, 58000, 62000, 55000, 68000, 57000, 62000]);
      // Rounded bars sum ≠ posted total by Figma design (doc 12 §11 #12).
      final barSum = typed.dailyBars.fold<int>(0, (a, b) => a + b);
      expect(barSum, 413000);
      expect(typed.deliveredIg, 412850);
      final raw = seeds.table('report_week').single;
      final drivers = (raw['drivers']! as List).cast<Map<String, Object?>>();
      final ahmed = drivers
          .firstWhere((d) => d['name_en'] == 'Ahmed Khan');
      expect(ahmed['on_time_pct'], 98.4);
      expect(ahmed['delivered_ig'], 36500);
      expect(ahmed['variance_ig'], 0);
    });
  });

  group('Inspection checklist v1 (Figma DR-04, 8 items)', () {
    test('exact 8 items', () async {
      final items = await scenarios.inspectionChecklist();
      expect(items, hasLength(8));
      final en = items.map((e) => e['en']! as String).toList();
      expect(en, [
        'Tyres & wheel nuts',
        'Lights & indicators',
        'Brakes & air pressure',
        'Leaks, hoses & couplings',
        'Fire extinguisher & spill kit',
        'Tank seals & compartments',
        'PPE & warning equipment',
        'Documents & permit',
      ]);
      final raw = seeds.table('inspection_checklist').single;
      expect(raw['version'], 'inspectionChecklistV1');
    });
  });

  group('model JSON round-trips', () {
    test('SnapshotA / TripB / R27 / ReportWeek', () async {
      final s = await scenarios.snapshotA();
      expect(SnapshotA.fromJson(s.toJson()), s);
      final b = await scenarios.tripB();
      expect(TripBLedger.fromJson(b.toJson()), b);
      final r = await scenarios.exceptionR27();
      expect(ExceptionR27.fromJson(r.toJson()), r);
      final w = await scenarios.reportWeek();
      expect(ReportWeek.fromJson(w.toJson()), w);
    });
  });
}
