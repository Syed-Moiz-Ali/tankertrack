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

  group('masters volumes (06 spec)', () {
    test('entity volumes via service', () async {
      expect(await service.customers(), hasLength(24));
      expect(await service.sites(), hasLength(48));
      expect(await service.depots(), hasLength(5));
      expect(await service.products(), hasLength(4));
      expect(await service.drivers(), hasLength(50));
      expect(await service.vehicles(), hasLength(60));
      expect(await service.ordersToday(), hasLength(110));
    });

    test('sitesFor filters by customer', () async {
      final customers = await service.customers();
      final sites = await service.sitesFor(customers.first.id);
      expect(sites, isNotEmpty);
      for (final s in sites) {
        expect(s.customerId, customers.first.id);
      }
      expect(await service.sitesFor('C-404'), isEmpty);
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

    test('ordersByStatus counts sum to 110 and match seeds', () async {
      final kpis = await service.dashboardKpis();
      final total = kpis.ordersByStatus.values.fold<int>(0, (a, c) => a + c);
      expect(total, 110);
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

    test('driver counters sum to 50 with even/odd onDuty split', () async {
      final kpis = await service.dashboardKpis();
      expect(
        kpis.driversAvailable + kpis.driversBusy + kpis.driversOffline,
        50,
      );
      final raw = seeds.table('drivers');
      var available = 0;
      var busy = 0;
      var offline = 0;
      for (var i = 0; i < raw.length; i++) {
        if (raw[i]['status'] == 'onDuty') {
          if (i.isEven) {
            available++;
          } else {
            busy++;
          }
        } else {
          offline++;
        }
      }
      expect(kpis.driversAvailable, available);
      expect(kpis.driversBusy, busy);
      expect(kpis.driversOffline, offline);
    });

    test('vehicle counters sum to 60', () async {
      final kpis = await service.dashboardKpis();
      expect(
        kpis.vehiclesFree +
            kpis.vehiclesAssigned +
            kpis.vehiclesBreakdown +
            kpis.vehiclesMaintenance,
        60,
      );
      expect(kpis.vehiclesFree, 4);
      expect(kpis.vehiclesBreakdown, 4);
      // maintenance folds in outOfService (4 counters per contract).
      expect(kpis.vehiclesMaintenance, 5 + 3);
    });

    test('lateOrders == inProgress count', () async {
      final kpis = await service.dashboardKpis();
      expect(kpis.lateOrders, 30);
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
      final unread = seeds
          .table('notifications')
          .where((n) => n['read'] != true)
          .take(10);
      expect(kpis.alerts, hasLength(open.length + 10));
      for (var i = 0; i < open.length; i++) {
        expect(kpis.alerts[i].id, open.elementAt(i)['incident_id']);
        expect(kpis.alerts[i].severity, open.elementAt(i)['severity']);
      }
      for (var i = 0; i < 10; i++) {
        final alert = kpis.alerts[open.length + i];
        expect(alert.id, unread.elementAt(i)['notification_id']);
        expect(alert.titleEn, unread.elementAt(i)['type']);
      }
    });
  });

  group('entity fromJson incl. Arabic names', () {
    test('customer + bilingual getter', () {
      final raw = seeds
          .table('customers')
          .firstWhere((c) => c['customer_id'] == 'C-101');
      final c = Customer.fromJson(raw);
      expect(c.id, 'C-101');
      expect(c.code, 'C-101');
      expect(c.nameEn, 'Al Noor Contracting');
      expect(c.nameAr, 'النور للمقاولات');
      expect(c.name(arabic: false), c.nameEn);
      expect(c.name(arabic: true), c.nameAr);
    });

    test('delivery site over seed keys', () {
      final s = DeliverySite.fromJson(seeds.table('sites').first);
      expect(s.id, isNotEmpty);
      expect(s.customerId, isNotEmpty);
      expect(s.name(arabic: true), s.nameAr);
      expect(s.geofenceM, 200);
    });

    test('depot over seed keys', () {
      final d = Depot.fromJson(seeds.table('depots').first);
      expect(d.id, 'D-1');
      expect(d.nameEn, 'Depot A');
      expect(d.name(arabic: true), isNotEmpty);
      expect(d.geofenceM, 300);
      expect(d.products, contains('DSL-STD'));
    });

    test('product incl. inactive flag', () {
      final products = seeds.table('products').map(Product.fromJson).toList();
      expect(
        products.map((p) => p.id),
        containsAll(['DSL-STD', 'DSL-PRM', 'DSL-WIN', 'DSL-OFF']),
      );
      expect(products.firstWhere((p) => p.id == 'DSL-OFF').active, isFalse);
      expect(products.first.name(arabic: true), isNotEmpty);
    });

    test('S1 hero driver + bilingual names', () {
      final raw = seeds
          .table('drivers')
          .firstWhere((d) => d['driver_id'] == 'DRV-001');
      final d = DriverInfo.fromJson(raw);
      expect(d.nameEn, contains('Khalid Al-Otaibi'));
      expect(d.nameAr, contains('خالد العتيبي'));
      expect(d.name(arabic: true), d.nameAr);
    });

    test('vehicle T-214 over seed keys', () {
      final raw = seeds
          .table('vehicles')
          .firstWhere((v) => v['vehicle_id'] == 'T-214');
      final v = VehicleInfo.fromJson(raw);
      expect(v.registration, isNotEmpty);
      expect(v.capacityTenths, inInclusiveRange(20000, 60000));
    });

    test('order summary over seed keys', () {
      final o = OrderSummary.fromJson(seeds.table('orders_today').first);
      expect(o.id, startsWith('SO-'));
      expect(o.qtyTenths, inInclusiveRange(5000, 40000));
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
      for (final uri in SeedBundle.assetUris.values) {
        expect(uri, startsWith('packages/data/assets/seeds/'));
        expect(uri, endsWith('.json'));
      }
    });
  });
}
