// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entities.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Customer _$CustomerFromJson(Map<String, dynamic> json) => _Customer(
  id: json['customer_id'] as String,
  code: json['code'] as String,
  nameEn: json['name_en'] as String,
  nameAr: json['name_ar'] as String,
  contact: json['contact'] as String,
  phone: json['phone'] as String,
  status: json['status'] as String,
);

Map<String, dynamic> _$CustomerToJson(_Customer instance) => <String, dynamic>{
  'customer_id': instance.id,
  'code': instance.code,
  'name_en': instance.nameEn,
  'name_ar': instance.nameAr,
  'contact': instance.contact,
  'phone': instance.phone,
  'status': instance.status,
};

_DeliverySite _$DeliverySiteFromJson(Map<String, dynamic> json) =>
    _DeliverySite(
      id: json['site_id'] as String,
      customerId: json['customer_id'] as String,
      nameEn: json['name_en'] as String,
      nameAr: json['name_ar'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      geofenceM: (json['geofence_m'] as num).toInt(),
      gateHours: json['gate_hours'] as String,
    );

Map<String, dynamic> _$DeliverySiteToJson(_DeliverySite instance) =>
    <String, dynamic>{
      'site_id': instance.id,
      'customer_id': instance.customerId,
      'name_en': instance.nameEn,
      'name_ar': instance.nameAr,
      'lat': instance.lat,
      'lng': instance.lng,
      'geofence_m': instance.geofenceM,
      'gate_hours': instance.gateHours,
    };

_Depot _$DepotFromJson(Map<String, dynamic> json) => _Depot(
  id: json['source_id'] as String,
  nameEn: json['name_en'] as String,
  nameAr: json['name_ar'] as String,
  lat: (json['lat'] as num).toDouble(),
  lng: (json['lng'] as num).toDouble(),
  geofenceM: (json['geofence_m'] as num).toInt(),
  hours: json['hours'] as String,
  products:
      (json['products'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
);

Map<String, dynamic> _$DepotToJson(_Depot instance) => <String, dynamic>{
  'source_id': instance.id,
  'name_en': instance.nameEn,
  'name_ar': instance.nameAr,
  'lat': instance.lat,
  'lng': instance.lng,
  'geofence_m': instance.geofenceM,
  'hours': instance.hours,
  'products': instance.products,
};

_Product _$ProductFromJson(Map<String, dynamic> json) => _Product(
  id: json['product_id'] as String,
  nameEn: json['name_en'] as String,
  nameAr: json['name_ar'] as String,
  unit: json['unit'] as String,
  active: json['active'] as bool,
);

Map<String, dynamic> _$ProductToJson(_Product instance) => <String, dynamic>{
  'product_id': instance.id,
  'name_en': instance.nameEn,
  'name_ar': instance.nameAr,
  'unit': instance.unit,
  'active': instance.active,
};

_DriverInfo _$DriverInfoFromJson(Map<String, dynamic> json) => _DriverInfo(
  id: json['driver_id'] as String,
  nameEn: json['name_en'] as String,
  nameAr: json['name_ar'] as String,
  phone: json['phone'] as String,
  status: json['status'] as String,
  licenceExpiryDays: (json['licence_expiry_days'] as num).toInt(),
);

Map<String, dynamic> _$DriverInfoToJson(_DriverInfo instance) =>
    <String, dynamic>{
      'driver_id': instance.id,
      'name_en': instance.nameEn,
      'name_ar': instance.nameAr,
      'phone': instance.phone,
      'status': instance.status,
      'licence_expiry_days': instance.licenceExpiryDays,
    };

_VehicleInfo _$VehicleInfoFromJson(Map<String, dynamic> json) => _VehicleInfo(
  id: json['vehicle_id'] as String,
  registration: json['registration'] as String,
  capacityTenths: (json['capacity_tenths'] as num).toInt(),
  onBoardTenths: (json['on_board_tenths'] as num).toInt(),
  status: json['status'] as String,
  docExpiryDays: (json['doc_expiry_days'] as num).toInt(),
  criticalDefect: json['critical_defect'] as bool,
  compartments:
      (json['compartments'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
);

Map<String, dynamic> _$VehicleInfoToJson(_VehicleInfo instance) =>
    <String, dynamic>{
      'vehicle_id': instance.id,
      'registration': instance.registration,
      'capacity_tenths': instance.capacityTenths,
      'on_board_tenths': instance.onBoardTenths,
      'status': instance.status,
      'doc_expiry_days': instance.docExpiryDays,
      'critical_defect': instance.criticalDefect,
      'compartments': instance.compartments,
    };

_OrderSummary _$OrderSummaryFromJson(Map<String, dynamic> json) =>
    _OrderSummary(
      id: json['order_id'] as String,
      siteId: json['site_id'] as String,
      productId: json['product_id'] as String,
      qtyTenths: (json['qty_tenths'] as num).toInt(),
      priority: json['priority'] as String,
      window: json['window'] as String,
      status: json['status'] as String,
      hasVariance: json['has_variance'] as bool,
      poRef: json['po_ref'] as String?,
    );

Map<String, dynamic> _$OrderSummaryToJson(_OrderSummary instance) =>
    <String, dynamic>{
      'order_id': instance.id,
      'site_id': instance.siteId,
      'product_id': instance.productId,
      'qty_tenths': instance.qtyTenths,
      'priority': instance.priority,
      'window': instance.window,
      'status': instance.status,
      'has_variance': instance.hasVariance,
      'po_ref': instance.poRef,
    };

_AlertItem _$AlertItemFromJson(Map<String, dynamic> json) => _AlertItem(
  id: _alertReadId(json, 'id') as String,
  type: _alertReadType(json, 'type') as String,
  severity: _alertReadSeverity(json, 'severity') as String,
  titleEn: _alertReadTitleEn(json, 'titleEn') as String,
  titleAr: _alertReadTitleAr(json, 'titleAr') as String,
  atIdentifier: _alertReadAt(json, 'atIdentifier') as String,
);

Map<String, dynamic> _$AlertItemToJson(_AlertItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'severity': instance.severity,
      'titleEn': instance.titleEn,
      'titleAr': instance.titleAr,
      'atIdentifier': instance.atIdentifier,
    };

_DashboardKpis _$DashboardKpisFromJson(Map<String, dynamic> json) =>
    _DashboardKpis(
      requestedTenths: (json['requestedTenths'] as num).toInt(),
      loadedTenths: (json['loadedTenths'] as num).toInt(),
      deliveredTenths: (json['deliveredTenths'] as num).toInt(),
      pendingTenths: (json['pendingTenths'] as num).toInt(),
      ordersByStatus: Map<String, int>.from(json['ordersByStatus'] as Map),
      driversAvailable: (json['driversAvailable'] as num).toInt(),
      driversBusy: (json['driversBusy'] as num).toInt(),
      driversOffline: (json['driversOffline'] as num).toInt(),
      vehiclesFree: (json['vehiclesFree'] as num).toInt(),
      vehiclesAssigned: (json['vehiclesAssigned'] as num).toInt(),
      vehiclesBreakdown: (json['vehiclesBreakdown'] as num).toInt(),
      vehiclesMaintenance: (json['vehiclesMaintenance'] as num).toInt(),
      lateOrders: (json['lateOrders'] as num).toInt(),
      alerts: (json['alerts'] as List<dynamic>)
          .map((e) => AlertItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      reloadRequired: (json['reloadRequired'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$DashboardKpisToJson(_DashboardKpis instance) =>
    <String, dynamic>{
      'requestedTenths': instance.requestedTenths,
      'loadedTenths': instance.loadedTenths,
      'deliveredTenths': instance.deliveredTenths,
      'pendingTenths': instance.pendingTenths,
      'ordersByStatus': instance.ordersByStatus,
      'driversAvailable': instance.driversAvailable,
      'driversBusy': instance.driversBusy,
      'driversOffline': instance.driversOffline,
      'vehiclesFree': instance.vehiclesFree,
      'vehiclesAssigned': instance.vehiclesAssigned,
      'vehiclesBreakdown': instance.vehiclesBreakdown,
      'vehiclesMaintenance': instance.vehiclesMaintenance,
      'lateOrders': instance.lateOrders,
      'alerts': instance.alerts.map((e) => e.toJson()).toList(),
      'reloadRequired': instance.reloadRequired,
    };
