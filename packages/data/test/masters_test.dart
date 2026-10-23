import 'dart:io';

import 'package:data/data.dart';
import 'package:test/test.dart';

void main() {
  late SeedBundle seeds;
  late MockMasterDataService service;

  setUpAll(() async {
    seeds = await SeedBundle.load(Directory('assets/seeds'));
    service = MockMasterDataService(seeds);
  });

  group('masters volumes (R3 Dubai)', () {
    test('entity volumes via service', () async {
      expect(await service.customers(), hasLength(12));
      expect(await service.sites(), hasLength(8));
      expect(await service.depots(), hasLength(3));
      expect(await service.products(), hasLength(3));
      expect(await service.drivers(), hasLength(28));
      expect(await service.vehicles(), hasLength(24));
      expect(await service.ordersToday(), hasLength(87));
    });

    test('sitesFor filters by customer', () async {
      final customers = await service.customers();
      final sites = await service.sitesFor(customers.first.id);
      expect(sites, isNotEmpty);
      for (final s in sites) {
        expect(s.customerId, customers.first.id);
      }
      expect(await service.sitesFor('CUST-404'), isEmpty);
    });
  });

  group('dashboardKpis math vs seeds', () {
    test('requested == manual sum; loaded/delivered/pending rules', () async {
      final raw = seeds.table('orders_today');
      int qty(Map<String, Object?> o) => o['qty_tenths']! as int;
      final manualRequested = raw.fold<int>(0, (a, o) => a + qty(o));
      final manualLoaded = raw
          .where(
            (o) =>
                o['status'] == 'inProgress' ||
                o['status'] == 'completed' ||
                o['status'] == 'partial',
          )
          .fold<int>(0, (a, o) => a + qty(o));
      final manualDelivered =
          raw
              .where((o) => o['status'] == 'completed')
              .fold<int>(0, (a, o) => a + qty(o)) +
          raw
              .where((o) => o['status'] == 'partial')
              .fold<int>(0, (a, o) => a + qty(o) ~/ 2);

      final kpis = await service.dashboardKpis();
      expect(kpis.requestedTenths, manualRequested);
      expect(kpis.loadedTenths, manualLoaded);
      expect(kpis.deliveredTenths, manualDelivered);
      expect(kpis.pendingTenths, manualRequested - manualDelivered);
    });

    test('ordersByStatus counts sum to 87 and match BO-06 chips', () async {
      final kpis = await service.dashboardKpis();
      final total = kpis.ordersByStatus.values.fold<int>(0, (a, c) => a + c);
      expect(total, 87);
      expect(kpis.ordersByStatus['inProgress'], 28);
      expect(kpis.ordersByStatus['completed'], 31);
      for (final entry in kpis.ordersByStatus.entries) {
        expect(
          entry.value,
          seeds
              .table('orders_today')
              .where((o) => o['status'] == entry.key)
              .length,
        );
      }
    });

    test('driver counters sum to 28 with even/odd onDuty split', () async {
      final kpis = await service.dashboardKpis();
      expect(
        kpis.driversAvailable + kpis.driversBusy + kpis.driversOffline,
        28,
      );
      expect(kpis.driversAvailable + kpis.driversBusy, 22);
      expect(kpis.driversOffline, 6);
    });

    test('vehicle counters sum to 24', () async {
      final kpis = await service.dashboardKpis();
      expect(
        kpis.vehiclesFree +
            kpis.vehiclesAssigned +
            kpis.vehiclesBreakdown +
            kpis.vehiclesMaintenance,
        24,
      );
      expect(kpis.vehiclesFree, 3);
      expect(kpis.vehiclesAssigned, 18);
      expect(kpis.vehiclesBreakdown, 1);
      expect(kpis.vehiclesMaintenance, 2);
    });

    test('lateOrders == inProgress count (28)', () async {
      final kpis = await service.dashboardKpis();
      expect(kpis.lateOrders, 28);
    });

    test('reloadRequired matches low-balance filter', () async {
      const excluded = {'maintenance', 'breakdown', 'outOfService'};
      final manual = seeds
          .table('vehicles')
          .where((v) {
            return (v['on_board_tenths']! as int) < 5000 &&
                !excluded.contains(v['status']);
          })
          .map((v) => v['vehicle_id']! as String);
      final kpis = await service.dashboardKpis();
      expect(kpis.reloadRequired, unorderedEquals(manual));
    });

    test('alerts = open incidents + first 10 unread notifications', () async {
      final kpis = await service.dashboardKpis();
      final open = seeds.table('incidents').where((i) => i['open'] == true);
      expect(kpis.alerts.length, open.length + 10);
      for (var i = 0; i < open.length; i++) {
        expect(kpis.alerts[i].id, open.elementAt(i)['incident_id']);
      }
    });
  });

  group('entity fromJson incl. Arabic names', () {
    test('customer + bilingual getter (ABC)', () {
      final raw = seeds.table('customers').firstWhere(
          (c) => c['customer_id'] == 'CUST-0018');
      final c = Customer.fromJson(raw);
      expect(c.id, 'CUST-0018');
      expect(c.nameEn, 'ABC Construction');
      expect(c.name(arabic: false), c.nameEn);
      expect(c.name(arabic: true), c.nameAr);
    });

    test('delivery site over seed keys', () {
      final s = DeliverySite.fromJson(seeds.table('sites').first);
      expect(s.id, isNotEmpty);
      expect(s.customerId, startsWith('CUST-'));
      expect(s.name(arabic: true), s.nameAr);
      expect(s.geofenceM, 200);
    });

    test('depot over seed keys (Dubai Depot)', () {
      final d = Depot.fromJson(seeds.table('depots').first);
      expect(d.id, 'D-1');
      expect(d.nameEn, 'Dubai Depot');
      expect(d.name(arabic: true), isNotEmpty);
      expect(d.geofenceM, 300);
      expect(d.products, contains('PROD-001'));
    });

    test('product PROD-001 primary active', () {
      final products = seeds.table('products').map(Product.fromJson).toList();
      expect(products.map((p) => p.id), contains('PROD-001'));
      expect(
          products.firstWhere((p) => p.id == 'PROD-001').active, isTrue);
      expect(products.where((p) => p.active), hasLength(1));
    });

    test('R3 hero driver Ahmed Khan DRV-0028', () {
      final raw = seeds.table('drivers').firstWhere(
          (d) => d['driver_id'] == 'DRV-0028');
      final d = DriverInfo.fromJson(raw);
      expect(d.nameEn, 'Ahmed Khan');
      expect(d.name(arabic: true), d.nameAr);
    });

    test('vehicle T-07 Dubai reg', () {
      final raw = seeds.table('vehicles').firstWhere(
          (v) => v['vehicle_id'] == 'T-07');
      final v = VehicleInfo.fromJson(raw);
      expect(v.registration, 'Dubai A 12345');
      expect(v.capacityTenths, 50000);
    });

    test('order summary over seed keys', () {
      final o = OrderSummary.fromJson(seeds.table('orders_today').first);
      expect(o.id, startsWith('SO-'));
      expect(o.productId, 'PROD-001');
    });

    test('alert fromJson accepts incident + notification shapes', () {
      final inc = AlertItem.fromJson(
        seeds.table('incidents').firstWhere((i) => i['open'] == true),
      );
      expect(inc.severity, isNotEmpty);
      expect(inc.atIdentifier, isNotEmpty);
      final n = AlertItem.fromJson(
        seeds.table('notifications').firstWhere((x) => x['read'] != true),
      );
      expect(n.titleEn, n.type);
      expect(n.title(arabic: false), n.titleEn);
    });
  });

  group('SeedBundle strings + assetUris', () {
    test('fromStrings == load(Directory)', () async {
      final strings = <String, String>{};
      for (final f in SeedBundle.files) {
        strings[f] = await File('assets/seeds/$f').readAsString();
      }
      final viaStrings = SeedBundle.fromStrings(strings);
      expect(viaStrings.tables, equals(seeds.tables));
    });

    test('assetUris cover every file keyed by table name', () {
      expect(
        SeedBundle.assetUris.keys,
        unorderedEquals(SeedBundle.files.map((f) => f.replaceAll('.json', ''))),
      );
      expect(
        SeedBundle.assetUris['customers'],
        'packages/data/assets/seeds/customers.json',
      );
      expect(
        SeedBundle.assetUris['snapshot_a'],
        'packages/data/assets/seeds/snapshot_a.json',
      );
      for (final uri in SeedBundle.assetUris.values) {
        expect(uri, startsWith('packages/data/assets/seeds/'));
        expect(uri, endsWith('.json'));
      }
    });
  });
}
