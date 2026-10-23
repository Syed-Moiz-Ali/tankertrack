// ignore_for_file: invalid_annotation_target
// Pinned json_annotation 4.9 declares JsonKey for field/getter targets only;
// @JsonKey on freezed factory params is consumed correctly by codegen
// (verified in entities.g.dart; upstream 4.12 adds TargetKind.parameter).
/// Back-office master entities (P1 contracts §2).
///
/// Immutable value types with `const` factories plus `fromJson`/`toJson`
/// over the `packages/data/assets/seeds/*.json` key names (snake_case).
/// Display formatting lives in `package:l10n`; quantities stay integer
/// tenths of an Imperial Gallon (see `package:domain` `QuantityIG`).
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'entities.freezed.dart';
part 'entities.g.dart';

/// P1 contracts §2: Customer { id, code, nameEn, nameAr, contact, phone, status }.
@freezed
abstract class Customer with _$Customer {
  const Customer._();

  const factory Customer({
    @JsonKey(name: 'customer_id') required String id,
    required String code,
    @JsonKey(name: 'name_en') required String nameEn,
    @JsonKey(name: 'name_ar') required String nameAr,
    required String contact,
    required String phone,
    required String status,
  }) = _Customer;

  factory Customer.fromJson(Map<String, Object?> json) =>
      _$CustomerFromJson(json);

  String name({required bool arabic}) => arabic ? nameAr : nameEn;
}

/// P1 contracts §2: DeliverySite
/// { id, customerId, nameEn, nameAr, lat, lng, geofenceM, gateHours }.
@freezed
abstract class DeliverySite with _$DeliverySite {
  const DeliverySite._();

  const factory DeliverySite({
    @JsonKey(name: 'site_id') required String id,
    @JsonKey(name: 'customer_id') required String customerId,
    @JsonKey(name: 'name_en') required String nameEn,
    @JsonKey(name: 'name_ar') required String nameAr,
    required double lat,
    required double lng,
    @JsonKey(name: 'geofence_m') required int geofenceM,
    @JsonKey(name: 'gate_hours') required String gateHours,
  }) = _DeliverySite;

  factory DeliverySite.fromJson(Map<String, Object?> json) =>
      _$DeliverySiteFromJson(json);

  String name({required bool arabic}) => arabic ? nameAr : nameEn;
}

/// P1 contracts §2: Depot
/// { id, nameEn, nameAr, lat, lng, geofenceM, hours, products }.
@freezed
abstract class Depot with _$Depot {
  const Depot._();

  const factory Depot({
    @JsonKey(name: 'source_id') required String id,
    @JsonKey(name: 'name_en') required String nameEn,
    @JsonKey(name: 'name_ar') required String nameAr,
    required double lat,
    required double lng,
    @JsonKey(name: 'geofence_m') required int geofenceM,
    required String hours,
    @Default(<String>[]) List<String> products,
  }) = _Depot;

  factory Depot.fromJson(Map<String, Object?> json) => _$DepotFromJson(json);

  String name({required bool arabic}) => arabic ? nameAr : nameEn;
}

/// P1 contracts §2: Product { id, nameEn, nameAr, unit, active }.
@freezed
abstract class Product with _$Product {
  const Product._();

  const factory Product({
    @JsonKey(name: 'product_id') required String id,
    @JsonKey(name: 'name_en') required String nameEn,
    @JsonKey(name: 'name_ar') required String nameAr,
    required String unit,
    required bool active,
  }) = _Product;

  factory Product.fromJson(Map<String, Object?> json) =>
      _$ProductFromJson(json);

  String name({required bool arabic}) => arabic ? nameAr : nameEn;
}

/// P1 contracts §2: DriverInfo
/// { id, nameEn, nameAr, phone, status, licenceExpiryDays }.
@freezed
abstract class DriverInfo with _$DriverInfo {
  const DriverInfo._();

  const factory DriverInfo({
    @JsonKey(name: 'driver_id') required String id,
    @JsonKey(name: 'name_en') required String nameEn,
    @JsonKey(name: 'name_ar') required String nameAr,
    required String phone,
    required String status,
    @JsonKey(name: 'licence_expiry_days') required int licenceExpiryDays,
  }) = _DriverInfo;

  factory DriverInfo.fromJson(Map<String, Object?> json) =>
      _$DriverInfoFromJson(json);

  String name({required bool arabic}) => arabic ? nameAr : nameEn;
}

/// P1 contracts §2: VehicleInfo
/// { id, registration, capacityTenths, onBoardTenths, status,
///   docExpiryDays, criticalDefect, compartments }.
@freezed
abstract class VehicleInfo with _$VehicleInfo {
  const VehicleInfo._();

  const factory VehicleInfo({
    @JsonKey(name: 'vehicle_id') required String id,
    required String registration,
    @JsonKey(name: 'capacity_tenths') required int capacityTenths,
    @JsonKey(name: 'on_board_tenths') required int onBoardTenths,
    required String status,
    @JsonKey(name: 'doc_expiry_days') required int docExpiryDays,
    @JsonKey(name: 'critical_defect') required bool criticalDefect,
    @Default(<String>[]) List<String> compartments,
  }) = _VehicleInfo;

  factory VehicleInfo.fromJson(Map<String, Object?> json) =>
      _$VehicleInfoFromJson(json);
}

/// P1 contracts §2: OrderSummary
/// { id, siteId, productId, qtyTenths, priority, window, status,
///   hasVariance, poRef? }.
@freezed
abstract class OrderSummary with _$OrderSummary {
  const OrderSummary._();

  const factory OrderSummary({
    @JsonKey(name: 'order_id') required String id,
    @JsonKey(name: 'site_id') required String siteId,
    @JsonKey(name: 'product_id') required String productId,
    @JsonKey(name: 'qty_tenths') required int qtyTenths,
    required String priority,
    required String window,
    required String status,
    @JsonKey(name: 'has_variance') required bool hasVariance,
    @JsonKey(name: 'po_ref') String? poRef,
  }) = _OrderSummary;

  factory OrderSummary.fromJson(Map<String, Object?> json) =>
      _$OrderSummaryFromJson(json);
}

Object? _alertReadId(Map<dynamic, dynamic> json, String key) =>
    json['id'] ?? json['incident_id'] ?? json['notification_id'];

Object? _alertReadType(Map<dynamic, dynamic> json, String key) =>
    json['type'] ?? json['category'] ?? '';

Object? _alertReadSeverity(Map<dynamic, dynamic> json, String key) =>
    json['severity'] ?? 'info';

Object? _alertReadTitleEn(Map<dynamic, dynamic> json, String key) =>
    json['titleEn'] ??
    json['title_en'] ??
    json['type'] ??
    json['category'] ??
    '';

Object? _alertReadTitleAr(Map<dynamic, dynamic> json, String key) =>
    json['titleAr'] ??
    json['title_ar'] ??
    json['type'] ??
    json['category'] ??
    '';

Object? _alertReadAt(Map<dynamic, dynamic> json, String key) =>
    json['atIdentifier'] ??
    json['vehicle_id'] ??
    json['order_id'] ??
    json['at'] ??
    '';

/// P1 contracts §2: AlertItem
/// { id, type, severity, titleEn, titleAr, atIdentifier }.
///
/// Aggregated by [MockMasterDataService] from open incidents (severity
/// preserved) plus unread notifications. `fromJson` accepts both seed
/// shapes via `readValue`: incident keys (`incident_id`, `category`,
/// `vehicle_id`) and notification keys (`notification_id`, `type`,
/// `order_id`), plus the canonical `toJson` shape so
/// `fromJson(toJson(x)) == x` round-trips.
@freezed
abstract class AlertItem with _$AlertItem {
  const AlertItem._();

  const factory AlertItem({
    @JsonKey(readValue: _alertReadId) required String id,
    @JsonKey(readValue: _alertReadType) required String type,
    @JsonKey(readValue: _alertReadSeverity) required String severity,
    @JsonKey(readValue: _alertReadTitleEn) required String titleEn,
    @JsonKey(readValue: _alertReadTitleAr) required String titleAr,
    @JsonKey(readValue: _alertReadAt) required String atIdentifier,
  }) = _AlertItem;

  factory AlertItem.fromJson(Map<String, Object?> json) =>
      _$AlertItemFromJson(json);

  String title({required bool arabic}) => arabic ? titleAr : titleEn;
}

/// P1 contracts §2: DashboardKpis aggregate (computed, not a seed row).
@freezed
abstract class DashboardKpis with _$DashboardKpis {
  const DashboardKpis._();

  @JsonSerializable(explicitToJson: true)
  const factory DashboardKpis({
    required int requestedTenths,
    required int loadedTenths,
    required int deliveredTenths,
    required int pendingTenths,
    required Map<String, int> ordersByStatus,
    required int driversAvailable,
    required int driversBusy,
    required int driversOffline,
    required int vehiclesFree,
    required int vehiclesAssigned,
    required int vehiclesBreakdown,
    required int vehiclesMaintenance,
    required int lateOrders,
    required List<AlertItem> alerts,
    required List<String> reloadRequired,
  }) = _DashboardKpis;

  factory DashboardKpis.fromJson(Map<String, Object?> json) =>
      _$DashboardKpisFromJson(json);
}
