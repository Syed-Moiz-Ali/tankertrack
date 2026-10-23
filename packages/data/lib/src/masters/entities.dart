/// Back-office master entities (P1 contracts §2).
///
/// Immutable value types with `const` ctors and `fromJson` over the
/// `packages/data/assets/seeds/*.json` key names (snake_case).
/// Display formatting lives in `package:l10n`; quantities stay integer
/// tenths of an Imperial Gallon (see `package:domain` `QuantityIG`).
library;

/// P1 contracts §2: Customer { id, code, nameEn, nameAr, contact, phone, status }.
class Customer {
  const Customer({
    required this.id,
    required this.code,
    required this.nameEn,
    required this.nameAr,
    required this.contact,
    required this.phone,
    required this.status,
  });

  factory Customer.fromJson(Map<String, Object?> json) => Customer(
    id: json['customer_id']! as String,
    code: json['code']! as String,
    nameEn: json['name_en']! as String,
    nameAr: json['name_ar']! as String,
    contact: json['contact']! as String,
    phone: json['phone']! as String,
    status: json['status']! as String,
  );

  final String id;
  final String code;
  final String nameEn;
  final String nameAr;
  final String contact;
  final String phone;
  final String status;

  String name({required bool arabic}) => arabic ? nameAr : nameEn;

  @override
  String toString() => 'Customer($id, $nameEn)';
}

/// P1 contracts §2: DeliverySite
/// { id, customerId, nameEn, nameAr, lat, lng, geofenceM, gateHours }.
class DeliverySite {
  const DeliverySite({
    required this.id,
    required this.customerId,
    required this.nameEn,
    required this.nameAr,
    required this.lat,
    required this.lng,
    required this.geofenceM,
    required this.gateHours,
  });

  factory DeliverySite.fromJson(Map<String, Object?> json) => DeliverySite(
    id: json['site_id']! as String,
    customerId: json['customer_id']! as String,
    nameEn: json['name_en']! as String,
    nameAr: json['name_ar']! as String,
    lat: (json['lat']! as num).toDouble(),
    lng: (json['lng']! as num).toDouble(),
    geofenceM: (json['geofence_m']! as num).toInt(),
    gateHours: json['gate_hours']! as String,
  );

  final String id;
  final String customerId;
  final String nameEn;
  final String nameAr;
  final double lat;
  final double lng;
  final int geofenceM;
  final String gateHours;

  String name({required bool arabic}) => arabic ? nameAr : nameEn;

  @override
  String toString() => 'DeliverySite($id, $nameEn)';
}

/// P1 contracts §2: Depot
/// { id, nameEn, nameAr, lat, lng, geofenceM, hours, products }.
class Depot {
  const Depot({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.lat,
    required this.lng,
    required this.geofenceM,
    required this.hours,
    required this.products,
  });

  factory Depot.fromJson(Map<String, Object?> json) => Depot(
    id: json['source_id']! as String,
    nameEn: json['name_en']! as String,
    nameAr: json['name_ar']! as String,
    lat: (json['lat']! as num).toDouble(),
    lng: (json['lng']! as num).toDouble(),
    geofenceM: (json['geofence_m']! as num).toInt(),
    hours: json['hours']! as String,
    products: (json['products']! as List).map((e) => e as String).toList(),
  );

  final String id;
  final String nameEn;
  final String nameAr;
  final double lat;
  final double lng;
  final int geofenceM;
  final String hours;
  final List<String> products;

  String name({required bool arabic}) => arabic ? nameAr : nameEn;

  @override
  String toString() => 'Depot($id, $nameEn)';
}

/// P1 contracts §2: Product { id, nameEn, nameAr, unit, active }.
class Product {
  const Product({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.unit,
    required this.active,
  });

  factory Product.fromJson(Map<String, Object?> json) => Product(
    id: json['product_id']! as String,
    nameEn: json['name_en']! as String,
    nameAr: json['name_ar']! as String,
    unit: json['unit']! as String,
    active: json['active']! as bool,
  );

  final String id;
  final String nameEn;
  final String nameAr;
  final String unit;
  final bool active;

  String name({required bool arabic}) => arabic ? nameAr : nameEn;

  @override
  String toString() => 'Product($id, $nameEn)';
}

/// P1 contracts §2: DriverInfo
/// { id, nameEn, nameAr, phone, status, licenceExpiryDays }.
class DriverInfo {
  const DriverInfo({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.phone,
    required this.status,
    required this.licenceExpiryDays,
  });

  factory DriverInfo.fromJson(Map<String, Object?> json) => DriverInfo(
    id: json['driver_id']! as String,
    nameEn: json['name_en']! as String,
    nameAr: json['name_ar']! as String,
    phone: json['phone']! as String,
    status: json['status']! as String,
    licenceExpiryDays: (json['licence_expiry_days']! as num).toInt(),
  );

  final String id;
  final String nameEn;
  final String nameAr;
  final String phone;
  final String status;
  final int licenceExpiryDays;

  String name({required bool arabic}) => arabic ? nameAr : nameEn;

  @override
  String toString() => 'DriverInfo($id, $nameEn)';
}

/// P1 contracts §2: VehicleInfo
/// { id, registration, capacityTenths, onBoardTenths, status,
///   docExpiryDays, criticalDefect }.
class VehicleInfo {
  const VehicleInfo({
    required this.id,
    required this.registration,
    required this.capacityTenths,
    required this.onBoardTenths,
    required this.status,
    required this.docExpiryDays,
    required this.criticalDefect,
  });

  factory VehicleInfo.fromJson(Map<String, Object?> json) => VehicleInfo(
    id: json['vehicle_id']! as String,
    registration: json['registration']! as String,
    capacityTenths: (json['capacity_tenths']! as num).toInt(),
    onBoardTenths: (json['on_board_tenths']! as num).toInt(),
    status: json['status']! as String,
    docExpiryDays: (json['doc_expiry_days']! as num).toInt(),
    criticalDefect: json['critical_defect']! as bool,
  );

  final String id;
  final String registration;
  final int capacityTenths;
  final int onBoardTenths;
  final String status;
  final int docExpiryDays;
  final bool criticalDefect;

  @override
  String toString() => 'VehicleInfo($id, $status)';
}

/// P1 contracts §2: OrderSummary
/// { id, siteId, productId, qtyTenths, priority, window, status, hasVariance }.
class OrderSummary {
  const OrderSummary({
    required this.id,
    required this.siteId,
    required this.productId,
    required this.qtyTenths,
    required this.priority,
    required this.window,
    required this.status,
    required this.hasVariance,
  });

  factory OrderSummary.fromJson(Map<String, Object?> json) => OrderSummary(
    id: json['order_id']! as String,
    siteId: json['site_id']! as String,
    productId: json['product_id']! as String,
    qtyTenths: (json['qty_tenths']! as num).toInt(),
    priority: json['priority']! as String,
    window: json['window']! as String,
    status: json['status']! as String,
    hasVariance: json['has_variance']! as bool,
  );

  final String id;
  final String siteId;
  final String productId;
  final int qtyTenths;
  final String priority;
  final String window;
  final String status;
  final bool hasVariance;

  @override
  String toString() => 'OrderSummary($id, $status)';
}

/// P1 contracts §2: AlertItem
/// { id, type, severity, titleEn, titleAr, atIdentifier }.
///
/// Aggregated by [MockMasterDataService] from open incidents (severity
/// preserved) plus unread notifications. `fromJson` accepts both seed
/// shapes: incident keys (`incident_id`, `category`, `vehicle_id`) and
/// notification keys (`notification_id`, `type`, `order_id`).
class AlertItem {
  const AlertItem({
    required this.id,
    required this.type,
    required this.severity,
    required this.titleEn,
    required this.titleAr,
    required this.atIdentifier,
  });

  factory AlertItem.fromJson(Map<String, Object?> json) {
    final type = (json['category'] ?? json['type'] ?? '') as String;
    return AlertItem(
      id:
          (json['incident_id'] ?? json['notification_id'] ?? json['id'])!
              as String,
      type: type,
      severity: (json['severity'] ?? 'info') as String,
      titleEn: (json['title_en'] ?? type) as String,
      titleAr: (json['title_ar'] ?? type) as String,
      atIdentifier:
          (json['vehicle_id'] ?? json['order_id'] ?? json['at'] ?? '')
              as String,
    );
  }

  final String id;
  final String type;
  final String severity;
  final String titleEn;
  final String titleAr;
  final String atIdentifier;

  String title({required bool arabic}) => arabic ? titleAr : titleEn;

  @override
  String toString() => 'AlertItem($id, $type, $severity)';
}

/// P1 contracts §2: DashboardKpis aggregate (computed, not a seed row).
class DashboardKpis {
  const DashboardKpis({
    required this.requestedTenths,
    required this.loadedTenths,
    required this.deliveredTenths,
    required this.pendingTenths,
    required this.ordersByStatus,
    required this.driversAvailable,
    required this.driversBusy,
    required this.driversOffline,
    required this.vehiclesFree,
    required this.vehiclesAssigned,
    required this.vehiclesBreakdown,
    required this.vehiclesMaintenance,
    required this.lateOrders,
    required this.alerts,
    required this.reloadRequired,
  });

  final int requestedTenths;
  final int loadedTenths;
  final int deliveredTenths;
  final int pendingTenths;
  final Map<String, int> ordersByStatus;
  final int driversAvailable;
  final int driversBusy;
  final int driversOffline;
  final int vehiclesFree;
  final int vehiclesAssigned;
  final int vehiclesBreakdown;
  final int vehiclesMaintenance;
  final int lateOrders;
  final List<AlertItem> alerts;
  final List<String> reloadRequired;

  @override
  String toString() =>
      'DashboardKpis(requested: $requestedTenths, delivered: $deliveredTenths)';
}
