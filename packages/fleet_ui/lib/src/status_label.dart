import 'package:core/core.dart';
import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:l10n/l10n.dart';

/// Localized role badge label (zero raw role names in UI).
String roleLabel(Role role, AppLocalizations l10n) => switch (role) {
      Role.admin => l10n.role_admin,
      Role.sales => l10n.role_sales,
      Role.dispatcher => l10n.role_dispatcher,
      Role.fleetController => l10n.role_fleet,
      Role.driver => l10n.role_driver,
      Role.supervisor => l10n.role_supervisor,
      Role.finance => l10n.role_finance,
      Role.customerStub => l10n.role_customer,
    };

/// Localized status labels. Typed overloads map WITHIN their own enum
/// (shared raw names like `assigned`/`available` differ by gender in
/// Arabic across enums — never share one switch across enums).
String orderStatusLabel(OrderStatus s, AppLocalizations l10n) =>
    switch (s) {
      OrderStatus.draft => l10n.st_order_draft,
      OrderStatus.confirmed => l10n.st_order_confirmed,
      OrderStatus.onHold => l10n.st_order_on_hold,
      OrderStatus.unassigned => l10n.st_order_unassigned,
      OrderStatus.assigned => l10n.st_order_assigned,
      OrderStatus.inProgress => l10n.st_order_in_progress,
      OrderStatus.completed => l10n.st_order_completed,
      OrderStatus.partial => l10n.st_order_partial,
      OrderStatus.failed => l10n.st_order_failed,
      OrderStatus.cancelled => l10n.st_order_cancelled,
    };

String tripStatusLabel(TripStatus s, AppLocalizations l10n) => switch (s) {
      TripStatus.planned => l10n.st_trip_planned,
      TripStatus.assigned => l10n.st_trip_assigned,
      TripStatus.accepted => l10n.st_trip_accepted,
      TripStatus.started => l10n.st_trip_started,
      TripStatus.atLoading => l10n.st_trip_at_loading,
      TripStatus.loaded => l10n.st_trip_loaded,
      TripStatus.delivering => l10n.st_trip_delivering,
      TripStatus.paused => l10n.st_trip_paused,
      TripStatus.breakdown => l10n.st_trip_breakdown,
      TripStatus.completed => l10n.st_trip_completed,
      TripStatus.closed => l10n.st_trip_closed,
    };

String taskStatusLabel(TaskStatus s, AppLocalizations l10n) => switch (s) {
      TaskStatus.pending => l10n.st_task_pending,
      TaskStatus.accepted => l10n.st_task_accepted,
      TaskStatus.enRoute => l10n.st_task_en_route,
      TaskStatus.arrived => l10n.st_task_arrived,
      TaskStatus.started => l10n.st_task_started,
      TaskStatus.completed => l10n.st_task_completed,
      TaskStatus.skipped => l10n.st_task_skipped,
      TaskStatus.failed => l10n.st_task_failed,
      TaskStatus.cancelled => l10n.st_task_cancelled,
    };

String vehicleStatusLabel(VehicleStatus s, AppLocalizations l10n) =>
    switch (s) {
      VehicleStatus.available => l10n.st_vehicle_available,
      VehicleStatus.reserved => l10n.st_vehicle_reserved,
      VehicleStatus.loading => l10n.st_vehicle_loading,
      VehicleStatus.inTransit => l10n.st_vehicle_in_transit,
      VehicleStatus.atCustomer => l10n.st_vehicle_at_customer,
      VehicleStatus.onBreak => l10n.st_vehicle_on_break,
      VehicleStatus.breakdown => l10n.st_vehicle_breakdown,
      VehicleStatus.maintenance => l10n.st_vehicle_maintenance,
      VehicleStatus.outOfService => l10n.st_vehicle_out_of_service,
    };

String driverStatusLabel(DriverStatus s, AppLocalizations l10n) =>
    switch (s) {
      DriverStatus.offline => l10n.st_driver_offline,
      DriverStatus.available => l10n.st_driver_available,
      DriverStatus.assigned => l10n.st_driver_assigned,
      DriverStatus.driving => l10n.st_driver_driving,
      DriverStatus.working => l10n.st_driver_working,
      DriverStatus.waiting => l10n.st_driver_waiting,
      DriverStatus.onBreak => l10n.st_driver_on_break,
      DriverStatus.breakdown => l10n.st_driver_breakdown,
      DriverStatus.completedDay => l10n.st_driver_completed_day,
    };

/// Simulator live-board keys (tracking.dart display statuses).
String liveStatusLabel(String key, AppLocalizations l10n) => switch (key) {
      'active' => l10n.st_live_active,
      'loading' => l10n.st_live_loading,
      'unloading' => l10n.st_live_unloading,
      'waiting' => l10n.st_live_waiting,
      'completed' => l10n.st_live_completed,
      'critical' => l10n.st_live_critical,
      _ => l10n.st_live_offline,
    };
/// Alert titles: incident categories + notification types → localized
/// labels. Falls back to the alert's own bilingual title, then raw type.
String alertTitle(AlertItem alert, AppLocalizations l10n) {
  final arabic = l10n.localeName == 'ar';
  switch (alert.type) {
    case 'breakdown':
      return l10n.inc_breakdown;
    case 'accident':
      return l10n.inc_accident;
    case 'spill':
      return l10n.inc_spill;
    case 'customer_unavailable':
      return l10n.inc_customer_unavailable;
    case 'meter_issue':
      return l10n.inc_meter_issue;
    case 'traffic':
      return l10n.inc_traffic;
    case 'access_denied':
      return l10n.inc_access_denied;
    case 'gps_issue':
      return l10n.inc_gps_issue;
    case 'assigned':
      return l10n.ntf_assigned;
    case 'late_eta':
      return l10n.ntf_late_eta;
    case 'geofence':
      return l10n.ntf_geofence;
    case 'variance':
      return l10n.ntf_variance;
    case 'deviation':
      return l10n.ntf_deviation;
    case 'doc_expiry':
      return l10n.ntf_doc_expiry;
    case 'gps_stale':
      return l10n.ntf_gps_stale;
    default:
      final fallback = alert.title(arabic: arabic);
      return fallback.isNotEmpty ? fallback : alert.type;
  }
}
String masterStatusLabel(String raw, AppLocalizations l10n) {
  switch (raw) {
    // Orders (seed vocabulary == OrderStatus names).
    case 'draft':
      return l10n.st_order_draft;
    case 'confirmed':
      return l10n.st_order_confirmed;
    case 'onHold':
      return l10n.st_order_on_hold;
    case 'unassigned':
      return l10n.st_order_unassigned;
    case 'assigned':
      return l10n.st_order_assigned;
    case 'inProgress':
      return l10n.st_order_in_progress;
    case 'completed':
      return l10n.st_order_completed;
    case 'partial':
      return l10n.st_order_partial;
    case 'failed':
      return l10n.st_order_failed;
    case 'cancelled':
      return l10n.st_order_cancelled;
    // Vehicles (seed vocabulary == VehicleStatus names).
    case 'available':
      return l10n.st_vehicle_available;
    case 'reserved':
      return l10n.st_vehicle_reserved;
    case 'loading':
      return l10n.st_vehicle_loading;
    case 'inTransit':
      return l10n.st_vehicle_in_transit;
    case 'atCustomer':
      return l10n.st_vehicle_at_customer;
    case 'onBreak':
      return l10n.st_vehicle_on_break;
    case 'breakdown':
      return l10n.st_vehicle_breakdown;
    case 'maintenance':
      return l10n.st_vehicle_maintenance;
    case 'outOfService':
      return l10n.st_vehicle_out_of_service;
    // Customers.
    case 'active':
      return l10n.st_cust_active;
    case 'credit_hold':
      return l10n.st_cust_credit_hold;
    case 'inactive':
      return l10n.st_cust_inactive;
    // Driver duty roster (seed vocabulary, NOT DriverStatus).
    case 'onDuty':
      return l10n.st_duty_on;
    case 'offDuty':
      return l10n.st_duty_off;
    case 'suspended':
      return l10n.st_duty_suspended;
    case 'leave':
      return l10n.st_duty_leave;
    // Alert severities.
    case 'critical':
      return l10n.st_sev_critical;
    case 'high':
      return l10n.st_sev_high;
    case 'medium':
      return l10n.st_sev_medium;
    case 'low':
      return l10n.st_sev_low;
    case 'info':
      return l10n.st_sev_info;
    default:
      return raw;
  }
}
