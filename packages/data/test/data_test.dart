import 'dart:io';

import 'package:data/data.dart';
import 'package:test/test.dart';

void main() {
  group('SeedBundle volumes (06 spec)', () {
    late SeedBundle seeds;

    setUpAll(() async {
      seeds = await SeedBundle.load(Directory('assets/seeds'));
    });

    test('exact volumes', () {
      expect(seeds.table('customers').length, 24);
      expect(seeds.table('sites').length, 48);
      expect(seeds.table('depots').length, 5);
      expect(seeds.table('products').length, 4);
      expect(seeds.table('vehicles').length, 60);
      expect(seeds.table('drivers').length, 50);
      expect(seeds.table('orders_today').length, 110);
      expect(seeds.table('trips_today').length, 34);
      expect(seeds.table('inspections').length, 40);
      expect(seeds.table('incidents').length, 12);
      expect(seeds.table('notifications').length, 60);
      expect(seeds.table('audit').length, 200);
      expect(seeds.table('history_daily').length, 30);
    });

    test('order status spread matches 06', () {
      final orders = seeds.table('orders_today');
      int count(String s) =>
          orders.where((o) => o['status'] == s).length;
      expect(count('draft'), 6);
      expect(count('confirmed'), 8);
      expect(count('onHold'), 4);
      expect(count('unassigned'), 18);
      expect(count('assigned'), 16);
      expect(count('inProgress'), 30);
      expect(count('completed'), 16);
      expect(count('partial'), 4);
      expect(count('failed'), 3);
      expect(count('cancelled'), 5);
    });

    test('bilingual names everywhere', () {
      for (final c in seeds.table('customers')) {
        expect((c['name_en'] as String).isNotEmpty, isTrue);
        expect((c['name_ar'] as String).isNotEmpty, isTrue);
      }
      for (final d in seeds.table('drivers')) {
        expect((d['name_en'] as String).isNotEmpty, isTrue);
        expect((d['name_ar'] as String).isNotEmpty, isTrue);
      }
    });

    test('S1 hero cast present (DRV-001 Khalid, T-214)', () {
      final drivers = seeds.table('drivers');
      final hero = drivers.firstWhere((d) => d['driver_id'] == 'DRV-001');
      expect((hero['name_en'] as String), contains('Khalid Al-Otaibi'));
      final vehicles = seeds.table('vehicles');
      expect(vehicles.any((v) => v['vehicle_id'] == 'T-214'), isTrue);
    });

    test('vehicle capacities 2000-6000 IG, compartments reserved', () {
      for (final v in seeds.table('vehicles')) {
        final cap = v['capacity_tenths'] as int;
        expect(cap, inInclusiveRange(20000, 60000));
        expect(v['compartments'], isEmpty); // flag OFF for MVP
      }
    });

    test('4 trips closed (locked)', () {
      final trips = seeds.table('trips_today');
      expect(trips.where((t) => t['closed'] == true).length, 4);
    });
  });

  group('MockAuthRepository', () {
    test('demo credentials per role; bad creds rejected', () async {
      final auth = MockAuthRepository();
      final admin = await auth.login(
          identifier: 'admin@demo.sa', secret: 'demo1234');
      expect(admin.isOk, isTrue);
      final driver =
          await auth.login(identifier: 'DRV-001', secret: '1234');
      expect(driver.isOk, isTrue);
      expect(driver.value.driverId, 'DRV-001');
      final bad =
          await auth.login(identifier: 'nobody@demo.sa', secret: 'x');
      expect(bad.isErr, isTrue);
    });
  });

  group('MockTrackingSimulator', () {
    test('42 tankers move deterministically', () async {
      final a = MockTrackingSimulator();
      final b = MockTrackingSimulator();
      final snapsA = <List<VehiclePosition>>[];
      final sub = a.positions().listen(snapsA.add);
      a.step(const Duration(seconds: 2));
      await Future<void>.delayed(Duration.zero);
      expect(snapsA.single.length, 42);

      final snapsB = <List<VehiclePosition>>[];
      final subB = b.positions().listen(snapsB.add);
      b.step(const Duration(seconds: 2));
      await Future<void>.delayed(Duration.zero);
      // Same seed → identical snapshots.
      for (var i = 0; i < 42; i++) {
        expect(snapsA.single[i].latitude, snapsB.single[i].latitude);
        expect(snapsA.single[i].longitude, snapsB.single[i].longitude);
      }
      // Movement between steps.
      final before = snapsA.single.first;
      a.step(const Duration(minutes: 5));
      await Future<void>.delayed(Duration.zero);
      final after = snapsA.last.firstWhere(
          (p) => p.vehicleId == before.vehicleId);
      final moved = (after.latitude - before.latitude).abs() +
          (after.longitude - before.longitude).abs();
      expect(moved, greaterThan(0));
      await sub.cancel();
      await subB.cancel();
      a.dispose();
      b.dispose();
    });

    test('breakdown inject → critical status + critical event (S5)', () async {
      final sim = MockTrackingSimulator();
      final events = <FleetEvent>[];
      final positions = <List<VehiclePosition>>[];
      final se = sim.events().listen(events.add);
      final sp = sim.positions().listen(positions.add);
      sim.injectBreakdown('T-214');
      sim.step(const Duration(seconds: 2));
      await Future<void>.delayed(Duration.zero);
      expect(
          events.where(
              (e) => e.type == 'breakdown' && e.severity == 'critical'),
          isNotEmpty);
      final broken = positions.last
          .firstWhere((p) => p.vehicleId == 'T-214');
      expect(broken.status, 'critical');
      expect(broken.speedKph, 0);
      await se.cancel();
      await sp.cancel();
      sim.dispose();
    });
  });
}
