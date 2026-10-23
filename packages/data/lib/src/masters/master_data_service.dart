import '../mock/seeds.dart';
import 'entities.dart';

/// P1 contracts §2: master-data seam (mock over [SeedBundle] now,
/// remote in a later phase — UI never knows which).
abstract class MasterDataService {
  Future<List<Customer>> customers();
  Future<List<DeliverySite>> sites();

  /// All sites; filter client-side.
  Future<List<DeliverySite>> sitesFor(String customerId);
  Future<List<Depot>> depots();
  Future<List<Product>> products();
  Future<List<DriverInfo>> drivers();
  Future<List<VehicleInfo>> vehicles();
  Future<List<OrderSummary>> ordersToday();
  Future<DashboardKpis> dashboardKpis();
}

/// Mock over [SeedBundle] with deterministic KPI rules:
///
/// * requested = Σ qty over all today orders;
/// * loaded = Σ qty of orders in {inProgress, completed, partial}
///   (assumed fully loaded);
/// * delivered = Σ qty of {completed} + 50% of {partial};
/// * pending = requested − delivered;
/// * drivers: `onDuty` splits by list index (even → available,
///   odd → busy); every other status → offline;
/// * vehicles: `available` → free; `reserved`/`inTransit`/`loading`/
///   `atCustomer`/`onBreak` → assigned; `breakdown` → breakdown;
///   `maintenance`/`outOfService` → maintenance (contract keeps 4
///   counters, so out-of-service folds into maintenance; onBreak counts
///   as assigned — the tanker is committed mid-route);
/// * lateOrders = count of inProgress orders (mock);
/// * reloadRequired = vehicle ids with onBoardTenths < 5000 (500 IG) and
///   status not in {maintenance, breakdown, outOfService};
/// * alerts = open incidents (severity preserved) + first 10 unread
///   notifications (type as title).
class MockMasterDataService implements MasterDataService {
  const MockMasterDataService(this.bundle);

  final SeedBundle bundle;

  @override
  Future<List<Customer>> customers() async =>
      bundle.table('customers').map(Customer.fromJson).toList();

  @override
  Future<List<DeliverySite>> sites() async =>
      bundle.table('sites').map(DeliverySite.fromJson).toList();

  @override
  Future<List<DeliverySite>> sitesFor(String customerId) async {
    final all = await sites();
    return all.where((s) => s.customerId == customerId).toList();
  }

  @override
  Future<List<Depot>> depots() async =>
      bundle.table('depots').map(Depot.fromJson).toList();

  @override
  Future<List<Product>> products() async =>
      bundle.table('products').map(Product.fromJson).toList();

  @override
  Future<List<DriverInfo>> drivers() async =>
      bundle.table('drivers').map(DriverInfo.fromJson).toList();

  @override
  Future<List<VehicleInfo>> vehicles() async =>
      bundle.table('vehicles').map(VehicleInfo.fromJson).toList();

  @override
  Future<List<OrderSummary>> ordersToday() async =>
      bundle.table('orders_today').map(OrderSummary.fromJson).toList();

  @override
  Future<DashboardKpis> dashboardKpis() async {
    final orders = await ordersToday();
    final driverList = await drivers();
    final vehicleList = await vehicles();

    var requested = 0;
    var loaded = 0;
    var delivered = 0;
    final ordersByStatus = <String, int>{};
    var late = 0;
    for (final o in orders) {
      requested += o.qtyTenths;
      ordersByStatus.update(o.status, (c) => c + 1, ifAbsent: () => 1);
      if (o.status == 'inProgress' ||
          o.status == 'completed' ||
          o.status == 'partial') {
        loaded += o.qtyTenths;
      }
      if (o.status == 'completed') {
        delivered += o.qtyTenths;
      } else if (o.status == 'partial') {
        delivered += o.qtyTenths ~/ 2;
      }
      if (o.status == 'inProgress') {
        late++;
      }
    }

    var available = 0;
    var busy = 0;
    var offline = 0;
    for (var i = 0; i < driverList.length; i++) {
      if (driverList[i].status == 'onDuty') {
        if (i.isEven) {
          available++;
        } else {
          busy++;
        }
      } else {
        offline++;
      }
    }

    var free = 0;
    var assigned = 0;
    var breakdown = 0;
    var maintenance = 0;
    final reloadRequired = <String>[];
    for (final v in vehicleList) {
      switch (v.status) {
        case 'available':
          free++;
        case 'reserved':
        case 'inTransit':
        case 'loading':
        case 'atCustomer':
        case 'onBreak':
          assigned++;
        case 'breakdown':
          breakdown++;
        case 'maintenance':
        case 'outOfService':
          maintenance++;
      }
      if (v.onBoardTenths < 5000 &&
          v.status != 'maintenance' &&
          v.status != 'breakdown' &&
          v.status != 'outOfService') {
        reloadRequired.add(v.id);
      }
    }

    final incidentAlerts = <AlertItem>[
      for (final inc in bundle.table('incidents'))
        if (inc['open'] == true)
          AlertItem(
            id: inc['incident_id']! as String,
            type: inc['category']! as String,
            severity: inc['severity']! as String,
            titleEn: inc['category']! as String,
            titleAr: inc['category']! as String,
            atIdentifier: inc['vehicle_id']! as String,
          ),
    ];
    final notificationAlerts = <AlertItem>[
      for (final n in bundle.table('notifications'))
        if (n['read'] != true)
          AlertItem(
            id: n['notification_id']! as String,
            type: n['type']! as String,
            severity: 'info',
            titleEn: n['type']! as String,
            titleAr: n['type']! as String,
            atIdentifier: n['order_id']! as String,
          ),
    ].take(10).toList();

    return DashboardKpis(
      requestedTenths: requested,
      loadedTenths: loaded,
      deliveredTenths: delivered,
      pendingTenths: requested - delivered,
      ordersByStatus: Map.unmodifiable(ordersByStatus),
      driversAvailable: available,
      driversBusy: busy,
      driversOffline: offline,
      vehiclesFree: free,
      vehiclesAssigned: assigned,
      vehiclesBreakdown: breakdown,
      vehiclesMaintenance: maintenance,
      lateOrders: late,
      alerts: List.unmodifiable([...incidentAlerts, ...notificationAlerts]),
      reloadRequired: List.unmodifiable(reloadRequired),
    );
  }
}
