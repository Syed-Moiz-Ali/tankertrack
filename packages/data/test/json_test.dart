import 'dart:convert';
import 'dart:io';

import 'package:data/data.dart';
import 'package:test/test.dart';

/// P1b §2 + R3: JSON round-trips for every freezed model.
///
/// For each entity: `fromJson(toJson(x)) == x`, seed-key compat
/// (`customer_id`, `site_id`, `po_ref`, …), plus decoding one real seed
/// row per entity from `assets/seeds/*.json` (R3 Dubai volumes).
void main() {
  late SeedBundle seeds;
  late MockMasterDataService service;

  setUpAll(() async {
    seeds = await SeedBundle.load(Directory('assets/seeds'));
    service = MockMasterDataService(seeds);
  });

  void roundTrip<T>(
    T Function(Map<String, Object?>) fromJson,
    Map<String, Object?> Function(T) toJson,
    T value,
  ) {
    final decoded = fromJson(toJson(value));
    expect(decoded, equals(value));
    expect(() => jsonEncode(toJson(value)), returnsNormally);
  }

  group('seed-key compat (snake_case wire names)', () {
    test('customer uses customer_id/name_en/name_ar', () async {
      final customers = await service.customers();
      final c = customers.first;
      final json = c.toJson();
      expect(json['customer_id'], c.id);
      expect(json['name_en'], c.nameEn);
      expect(json['name_ar'], c.nameAr);
      expect(json.containsKey('nameEn'), isFalse);
      roundTrip(Customer.fromJson, (v) => v.toJson(), c);
    });

    test('delivery site uses site_id/customer_id/geofence_m/gate_hours',
        () async {
      final s = (await service.sites()).first;
      final json = s.toJson();
      expect(json['site_id'], s.id);
      expect(json['customer_id'], s.customerId);
      expect(json['geofence_m'], s.geofenceM);
      expect(json['gate_hours'], s.gateHours);
      roundTrip(DeliverySite.fromJson, (v) => v.toJson(), s);
    });

    test('depot uses source_id/geofence_m + products list', () async {
      final d = (await service.depots()).first;
      final json = d.toJson();
      expect(json['source_id'], d.id);
      expect(json['geofence_m'], d.geofenceM);
      expect(json['products'], d.products);
      roundTrip(Depot.fromJson, (v) => v.toJson(), d);
    });

    test('product uses product_id', () async {
      final p = (await service.products()).first;
      expect(p.toJson()['product_id'], p.id);
      roundTrip(Product.fromJson, (v) => v.toJson(), p);
    });

    test('driver uses driver_id/licence_expiry_days', () async {
      final d = (await service.drivers()).first;
      final json = d.toJson();
      expect(json['driver_id'], d.id);
      expect(json['licence_expiry_days'], d.licenceExpiryDays);
      roundTrip(DriverInfo.fromJson, (v) => v.toJson(), d);
    });

    test('vehicle uses vehicle_id/capacity_tenths/compartments', () async {
      final v = (await service.vehicles()).first;
      final json = v.toJson();
      expect(json['vehicle_id'], v.id);
      expect(json['capacity_tenths'], v.capacityTenths);
      expect(json['on_board_tenths'], v.onBoardTenths);
      expect(json['doc_expiry_days'], v.docExpiryDays);
      expect(json['critical_defect'], v.criticalDefect);
      expect(json['compartments'], isEmpty);
      roundTrip(VehicleInfo.fromJson, (v) => v.toJson(), v);
    });

    test('order uses order_id/site_id/qty_tenths/has_variance/po_ref',
        () async {
      final o = (await service.ordersToday()).first;
      final json = o.toJson();
      expect(json['order_id'], o.id);
      expect(json['site_id'], o.siteId);
      expect(json['product_id'], o.productId);
      expect(json['qty_tenths'], o.qtyTenths);
      expect(json['has_variance'], o.hasVariance);
      expect(json['po_ref'], o.poRef);
      roundTrip(OrderSummary.fromJson, (v) => v.toJson(), o);
    });

    test('alert accepts incident + notification shapes and round-trips',
        () async {
      final kpis = await service.dashboardKpis();
      expect(kpis.alerts, isNotEmpty);
      for (final a in kpis.alerts) {
        roundTrip(AlertItem.fromJson, (v) => v.toJson(), a);
      }
    });

    test('dashboard kpis round-trip (nested alerts + counters)', () async {
      final kpis = await service.dashboardKpis();
      final json = kpis.toJson();
      expect(json['requestedTenths'], kpis.requestedTenths);
      expect(json['ordersByStatus'], kpis.ordersByStatus);
      expect(json['lateOrders'], kpis.lateOrders);
      expect(json['alerts'], hasLength(kpis.alerts.length));
      roundTrip(DashboardKpis.fromJson, (v) => v.toJson(), kpis);
    });

    test('session round-trip incl. role enum (.ae)', () async {
      final auth = MockAuthRepository();
      final result = await auth.login(
        identifier: 'dispatch@demo.ae',
        secret: 'demo1234',
      );
      expect(result.isOk, isTrue);
      final session = result.value;
      final json = session.toJson();
      expect(json['userId'], session.userId);
      expect(json['role'], 'dispatcher');
      roundTrip(Session.fromJson, (v) => v.toJson(), session);
      final driver = await auth.login(identifier: 'DRV-0028', secret: '1234');
      expect(driver.value.driverId, 'DRV-0028');
      roundTrip(Session.fromJson, (v) => v.toJson(), driver.value);
    });
  });

  group('one real seed row per entity', () {
    test('customer CUST-0018 ABC bilingual', () {
      final c = Customer.fromJson(seeds.table('customers').firstWhere(
          (e) => e['customer_id'] == 'CUST-0018'));
      expect(c.id, 'CUST-0018');
      expect(c.nameEn, 'ABC Construction');
      expect(Customer.fromJson(c.toJson()), c);
    });

    test('site SITE-ABC-04 links to ABC', () {
      final s = DeliverySite.fromJson(seeds.table('sites').first);
      expect(s.id, isNotEmpty);
      expect(s.customerId, startsWith('CUST-'));
      expect(DeliverySite.fromJson(s.toJson()), s);
    });

    test('depot D-1 Dubai Depot', () {
      final d = Depot.fromJson(seeds.table('depots').first);
      expect(d.id, 'D-1');
      expect(d.nameEn, 'Dubai Depot');
      expect(d.products, contains('PROD-001'));
      expect(Depot.fromJson(d.toJson()), d);
    });

    test('product PROD-001 active primary', () {
      final p = Product.fromJson(seeds.table('products').firstWhere(
          (e) => e['product_id'] == 'PROD-001'));
      expect(p.active, isTrue);
      expect(Product.fromJson(p.toJson()), p);
    });

    test('driver DRV-0028 hero', () {
      final d = DriverInfo.fromJson(seeds.table('drivers').firstWhere(
          (e) => e['driver_id'] == 'DRV-0028'));
      expect(d.nameEn, 'Ahmed Khan');
      expect(DriverInfo.fromJson(d.toJson()), d);
    });

    test('vehicle T-07 capacity + reg', () {
      final v = VehicleInfo.fromJson(seeds.table('vehicles').firstWhere(
          (e) => e['vehicle_id'] == 'T-07'));
      expect(v.registration, 'Dubai A 12345');
      expect(v.capacityTenths, 50000);
      expect(v.compartments, isEmpty);
      expect(VehicleInfo.fromJson(v.toJson()), v);
    });

    test('order SO-260145 hero', () {
      final o = OrderSummary.fromJson(seeds.table('orders_today').firstWhere(
          (e) => e['order_id'] == 'SO-260145'));
      expect(o.qtyTenths, 15000);
      expect(o.productId, 'PROD-001');
      expect(OrderSummary.fromJson(o.toJson()), o);
    });

    test('kpis computed over 87 orders', () async {
      final kpis = await service.dashboardKpis();
      expect(kpis.ordersByStatus.values.fold<int>(0, (a, c) => a + c), 87);
      expect(DashboardKpis.fromJson(kpis.toJson()), kpis);
    });
  });
}
