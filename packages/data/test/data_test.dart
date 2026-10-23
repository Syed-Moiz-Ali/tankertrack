import 'dart:io';

import 'package:data/data.dart';
import 'package:test/test.dart';

void main() {
  group('SeedBundle volumes (R3 Dubai)', () {
    late SeedBundle seeds;

    setUpAll(() async {
      seeds = await SeedBundle.load(Directory('assets/seeds'));
    });

    test('exact volumes: 28 drivers / 24 vehicles / 87 orders', () {
      expect(seeds.table('vehicles').length, 24);
      expect(seeds.table('drivers').length, 28);
      expect(seeds.table('orders_today').length, 87);
    });

    test('all seed files present incl. scenarios', () {
      for (final f in SeedBundle.files) {
        expect(seeds.tables.containsKey(f.replaceAll('.json', '')), isTrue,
            reason: 'missing table for $f');
      }
      expect(seeds.table('snapshot_a'), hasLength(1));
      expect(seeds.table('scenario_b_trip'), hasLength(1));
      expect(seeds.table('scenario_c_day'), hasLength(1));
      expect(seeds.table('scenario_i_incident'), hasLength(1));
      expect(seeds.table('scenario_r27_exception'), hasLength(1));
      expect(seeds.table('report_week'), hasLength(1));
      expect(seeds.table('inspection_checklist'), hasLength(1));
      expect(seeds.table('demo_meta'), hasLength(1));
    });

    test('BO-06 order chips sum to 87 (doc 12 §1)', () {
      final orders = seeds.table('orders_today');
      int count(String s) => orders.where((o) => o['status'] == s).length;
      expect(count('draft'), 5);
      expect(count('unassigned'), 10);
      expect(count('assigned'), 9);
      expect(count('inProgress'), 28);
      expect(count('completed'), 31);
      expect(count('partial'), 2);
      expect(count('failed'), 1);
      expect(count('cancelled'), 1);
      expect(orders.length, 87);
    });

    test('R3 hero cast: Ahmed Khan DRV-0028 + Tanker 07', () {
      final drivers = seeds.table('drivers');
      final hero = drivers.firstWhere((d) => d['driver_id'] == 'DRV-0028');
      expect(hero['name_en'], 'Ahmed Khan');
      final kareem = drivers.firstWhere((d) => d['driver_id'] == 'DRV-0014');
      expect(kareem['name_en'], 'Rashid Kareem');
      // Doc 12 §11 #11: near-collision names stay distinct with own mobiles.
      final ali = drivers.firstWhere((d) => d['name_en'] == 'Rashid Ali');
      expect(ali['phone'], isNot(equals(kareem['phone'])));
      final vehicles = seeds.table('vehicles');
      final t07 = vehicles.firstWhere((v) => v['vehicle_id'] == 'T-07');
      expect(t07['registration'], 'Dubai A 12345');
      expect(t07['capacity_tenths'], 50000);
    });

    test('Dubai regs + .ae auth + PROD-001 primary', () {
      for (final v in seeds.table('vehicles')) {
        expect((v['registration']! as String), startsWith('Dubai A '));
      }
      final products = seeds.table('products');
      final primary = products
          .firstWhere((p) => p['product_id'] == 'PROD-001');
      expect(primary['name_en'], 'Diesel 10ppm');
      expect(primary['active'], isTrue);
      expect(products.where((p) => p['active'] == true), hasLength(1));
    });

    test('vehicle capacities 4000-5000 IG, compartments reserved', () {
      for (final v in seeds.table('vehicles')) {
        final cap = v['capacity_tenths'] as int;
        expect(cap, inInclusiveRange(40000, 50000));
        expect(v['compartments'], isEmpty); // flag OFF for MVP
      }
    });

    test('live fleet spread: 19 active of 24', () {
      final vehicles = seeds.table('vehicles');
      int count(String s) => vehicles.where((v) => v['status'] == s).length;
      expect(count('loading'), 3);
      expect(count('inTransit'), 9);
      expect(count('atCustomer'), 5);
      expect(count('onBreak'), 1);
      expect(count('breakdown'), 1);
      final active = count('loading') +
          count('inTransit') +
          count('atCustomer') +
          count('onBreak') +
          count('breakdown');
      expect(active, 19);
    });

    test('1 trip closed (R-27 alternate locked)', () {
      final trips = seeds.table('trips_today');
      expect(trips.where((t) => t['closed'] == true).length, 1);
      expect(trips.any((t) => t['trip_id'] == 'TRIP-260021'), isTrue);
      expect(trips.any((t) => t['trip_id'] == 'TRIP-260027'), isTrue);
    });

    test('demo clock constant + reset semantics', () {
      expect(demoNowUtc, DateTime.utc(2026, 10, 23, 6, 30));
      expect(demoNowUtcIso, '2026-10-23T06:30:00Z');
      final meta = seeds.table('demo_meta').single;
      expect(meta['demo_now_utc'], '2026-10-23T06:30:00Z');
      expect((meta['reset_semantics']! as String), contains('Regenerating'));
    });
  });

  group('MockAuthRepository (.ae)', () {
    test('demo credentials per role; bad creds rejected', () async {
      final auth = MockAuthRepository();
      final admin =
          await auth.login(identifier: 'admin@demo.ae', secret: 'demo1234');
      expect(admin.isOk, isTrue);
      final dispatch = await auth.login(
          identifier: 'dispatch@demo.ae', secret: 'demo1234');
      expect(dispatch.isOk, isTrue);
      expect(dispatch.value.displayName, 'Mariam Hassan');
      final driver =
          await auth.login(identifier: 'DRV-0028', secret: '1234');
      expect(driver.isOk, isTrue);
      expect(driver.value.driverId, 'DRV-0028');
      final bad =
          await auth.login(identifier: 'nobody@demo.ae', secret: 'x');
      expect(bad.isErr, isTrue);
    });
  });

  group('MockTrackingSimulator (Dubai, 24)', () {
    test('24 tankers move deterministically', () async {
      final a = MockTrackingSimulator();
      final b = MockTrackingSimulator();
      final snapsA = <List<VehiclePosition>>[];
      final sub = a.positions().listen(snapsA.add);
      a.step(const Duration(seconds: 2));
      await Future<void>.delayed(Duration.zero);
      expect(snapsA.single.length, 24);

      final snapsB = <List<VehiclePosition>>[];
      final subB = b.positions().listen(snapsB.add);
      b.step(const Duration(seconds: 2));
      await Future<void>.delayed(Duration.zero);
      for (var i = 0; i < 24; i++) {
        expect(snapsA.single[i].latitude, snapsB.single[i].latitude);
        expect(snapsA.single[i].longitude, snapsB.single[i].longitude);
      }
      // Dubai cluster sanity.
      for (final p in snapsA.single) {
        expect(p.latitude, inInclusiveRange(24.8, 25.5));
        expect(p.longitude, inInclusiveRange(54.9, 55.5));
      }
      final before = snapsA.single.first;
      a.step(const Duration(minutes: 5));
      await Future<void>.delayed(Duration.zero);
      final after = snapsA.last
          .firstWhere((p) => p.vehicleId == before.vehicleId);
      final moved = (after.latitude - before.latitude).abs() +
          (after.longitude - before.longitude).abs();
      expect(moved, greaterThan(0));
      await sub.cancel();
      await subB.cancel();
      a.dispose();
      b.dispose();
    });

    test('breakdown inject → critical status + critical event', () async {
      final sim = MockTrackingSimulator();
      final events = <FleetEvent>[];
      final positions = <List<VehiclePosition>>[];
      final se = sim.events().listen(events.add);
      final sp = sim.positions().listen(positions.add);
      sim.injectBreakdown('T-07');
      sim.step(const Duration(seconds: 2));
      await Future<void>.delayed(Duration.zero);
      expect(
          events.where(
              (e) => e.type == 'breakdown' && e.severity == 'critical'),
          isNotEmpty);
      final broken =
          positions.last.firstWhere((p) => p.vehicleId == 'T-07');
      expect(broken.status, 'critical');
      expect(broken.speedKph, 0);
      await se.cancel();
      await sp.cancel();
      sim.dispose();
    });
  });
}
