import 'package:data/data.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Slice-D data seam (P1 contracts §2): providers over slice-A
/// [MasterDataService] / [MockMasterDataService] / [SeedBundle].
///
/// [seedBundleProvider] loads `packages/data/assets/seeds/<f>` via rootBundle
/// ([SeedBundle.fromStrings] per contract); [masterDataProvider] serves a
/// [DemoMasterDataService] — slice-A mock plus in-memory form persistence
/// (added/edited rows merge over seed reads; KPIs stay seed-pure).
/// Loading/error states are handled by consumers with
/// TTSkeleton/TTErrorState.

// ---------------------------------------------------------------------------
// Demo mutation overlay (forms actually create/edit rows in the demo).
// ---------------------------------------------------------------------------

class DemoMasterDataService extends MockMasterDataService {
  DemoMasterDataService(super.bundle);

  final Map<String, List<Map<String, Object?>>> _added = {};

  List<Map<String, Object?>> _extra(String table) =>
      _added.putIfAbsent(table, () => []);

  void _save(
    String table,
    String idKey,
    String id,
    Map<String, Object?> row,
  ) {
    final rows = _extra(table);
    final i = rows.indexWhere((r) => r[idKey] == id);
    if (i < 0) {
      rows.add(row);
    } else {
      rows[i] = row;
    }
  }

  /// Demo id factory for created rows (`C-`, `D-`, `DSL-`, `DRV-`, `T-`).
  String newIdFor(String prefix, String table, String idKey) {
    final taken = {
      for (final r in bundle.table(table)) r[idKey],
      for (final r in _extra(table)) r[idKey],
    };
    var n = bundle.table(table).length + 1;
    while (taken.contains('$prefix$n')) {
      n++;
    }
    return '$prefix$n';
  }

  void saveCustomer(Customer c) => _save('customers', 'customer_id', c.id, {
        'customer_id': c.id,
        'code': c.code,
        'name_en': c.nameEn,
        'name_ar': c.nameAr,
        'contact': c.contact,
        'phone': c.phone,
        'status': c.status,
      });

  void saveDepot(Depot d) => _save('depots', 'source_id', d.id, {
        'source_id': d.id,
        'name_en': d.nameEn,
        'name_ar': d.nameAr,
        'lat': d.lat,
        'lng': d.lng,
        'geofence_m': d.geofenceM,
        'hours': d.hours,
        'products': d.products,
      });

  void saveProduct(Product p) => _save('products', 'product_id', p.id, {
        'product_id': p.id,
        'name_en': p.nameEn,
        'name_ar': p.nameAr,
        'unit': p.unit,
        'active': p.active,
      });

  void saveDriver(DriverInfo d) => _save('drivers', 'driver_id', d.id, {
        'driver_id': d.id,
        'name_en': d.nameEn,
        'name_ar': d.nameAr,
        'phone': d.phone,
        'status': d.status,
        'licence_expiry_days': d.licenceExpiryDays,
      });

  void saveVehicle(VehicleInfo v) => _save('vehicles', 'vehicle_id', v.id, {
        'vehicle_id': v.id,
        'registration': v.registration,
        'capacity_tenths': v.capacityTenths,
        'on_board_tenths': v.onBoardTenths,
        'status': v.status,
        'doc_expiry_days': v.docExpiryDays,
        'critical_defect': v.criticalDefect,
        'compartments': const [],
      });

  @override
  Future<List<Customer>> customers() async =>
      [...await super.customers(), ..._extra('customers').map(Customer.fromJson)];

  @override
  Future<List<Depot>> depots() async =>
      [...await super.depots(), ..._extra('depots').map(Depot.fromJson)];

  @override
  Future<List<Product>> products() async =>
      [...await super.products(), ..._extra('products').map(Product.fromJson)];

  @override
  Future<List<DriverInfo>> drivers() async =>
      [...await super.drivers(), ..._extra('drivers').map(DriverInfo.fromJson)];

  @override
  Future<List<VehicleInfo>> vehicles() async => [
        ...await super.vehicles(),
        ..._extra('vehicles').map(VehicleInfo.fromJson),
      ];
}

// ---------------------------------------------------------------------------
// Providers.
// ---------------------------------------------------------------------------

/// Loads seed JSON via rootBundle (contract §2). Tests override this with
/// [SeedBundle.load] from the package dir.
final seedBundleProvider = FutureProvider<SeedBundle>((ref) async {
  final sources = <String, String>{};
  for (final e in SeedBundle.assetUris.entries) {
    sources[e.key] = await rootBundle.loadString(e.value);
  }
  return SeedBundle.fromStrings(sources);
});

final masterDataProvider = Provider<DemoMasterDataService>((ref) {
  final bundle =
      ref.watch(seedBundleProvider).valueOrNull ?? const SeedBundle({});
  return DemoMasterDataService(bundle);
});

final customersProvider = FutureProvider<List<Customer>>(
    (ref) async => ref.watch(masterDataProvider).customers());
final sitesProvider = FutureProvider<List<DeliverySite>>(
    (ref) async => ref.watch(masterDataProvider).sites());
final depotsProvider = FutureProvider<List<Depot>>(
    (ref) async => ref.watch(masterDataProvider).depots());
final productsProvider = FutureProvider<List<Product>>(
    (ref) async => ref.watch(masterDataProvider).products());
final driversProvider = FutureProvider<List<DriverInfo>>(
    (ref) async => ref.watch(masterDataProvider).drivers());
final vehiclesProvider = FutureProvider<List<VehicleInfo>>(
    (ref) async => ref.watch(masterDataProvider).vehicles());
final ordersTodayProvider = FutureProvider<List<OrderSummary>>(
    (ref) async => ref.watch(masterDataProvider).ordersToday());

final kpisProvider = FutureProvider<DashboardKpis>((ref) async {
  // Gate on the bundle so load errors surface once, at the bundle level.
  await ref.watch(seedBundleProvider.future);
  return ref.watch(masterDataProvider).dashboardKpis();
});

/// ONE simulator for the app lifetime, started once, disposed with the scope.
final trackingProvider = StateProvider<MockTrackingSimulator>((ref) {
  final sim = MockTrackingSimulator();
  sim.start();
  ref.onDispose(sim.dispose);
  return sim;
});

final positionsProvider = StreamProvider<List<VehiclePosition>>((ref) {
  final sim = ref.watch(trackingProvider);
  return sim.positions();
});

final fleetEventsProvider = StreamProvider<FleetEvent>((ref) {
  final sim = ref.watch(trackingProvider);
  return sim.events();
});

/// Deterministic demo commitments {dayOfMonth: count} derived from a seed
/// string (driver id / registration). Stable across rebuilds; real trip data
/// lands with the dispatcher in later phases.
Map<int, int> demoCommitments(String seed, int year, int month) {
  var h = 0;
  for (final c in seed.codeUnits) {
    h = (h * 31 + c) & 0x7fffffff;
  }
  final daysInMonth = DateTime(year, month + 1, 0).day;
  final out = <int, int>{};
  for (var i = 0; i < 6; i++) {
    final day = (h + i * 7) % daysInMonth + 1;
    out.update(day, (v) => v + 1, ifAbsent: () => 1);
  }
  return out;
}
