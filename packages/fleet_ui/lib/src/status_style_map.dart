import 'package:design_system/design_system.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';

/// Maps domain statuses to display [StatusStyle] (design_system stays
/// dependency-free; the mapping lives here).
extension OrderStatusStyle on OrderStatus {
  StatusStyle get style => switch (this) {
        OrderStatus.completed => StatusStyle.completed,
        OrderStatus.inProgress || OrderStatus.assigned => StatusStyle.active,
        OrderStatus.partial => StatusStyle.unloading,
        OrderStatus.failed || OrderStatus.cancelled => StatusStyle.offline,
        OrderStatus.draft ||
        OrderStatus.confirmed ||
        OrderStatus.onHold ||
        OrderStatus.unassigned =>
          StatusStyle.waiting,
      };
}

extension TripStatusStyle on TripStatus {
  StatusStyle get style => switch (this) {
        TripStatus.completed || TripStatus.closed => StatusStyle.completed,
        TripStatus.assigned ||
        TripStatus.accepted ||
        TripStatus.started ||
        TripStatus.delivering =>
          StatusStyle.active,
        TripStatus.atLoading || TripStatus.loaded => StatusStyle.loading,
        TripStatus.paused => StatusStyle.waiting,
        TripStatus.breakdown => StatusStyle.critical,
        TripStatus.planned => StatusStyle.offline,
      };
}

extension TaskStatusStyle on TaskStatus {
  StatusStyle get style => switch (this) {
        TaskStatus.completed => StatusStyle.completed,
        TaskStatus.accepted ||
        TaskStatus.enRoute ||
        TaskStatus.arrived ||
        TaskStatus.started =>
          StatusStyle.active,
        TaskStatus.skipped => StatusStyle.waiting,
        TaskStatus.failed || TaskStatus.cancelled => StatusStyle.offline,
        TaskStatus.pending => StatusStyle.waiting,
      };
}

extension VehicleStatusStyle on VehicleStatus {
  StatusStyle get style => switch (this) {
        VehicleStatus.available => StatusStyle.completed,
        VehicleStatus.reserved || VehicleStatus.inTransit =>
          StatusStyle.active,
        VehicleStatus.loading => StatusStyle.loading,
        VehicleStatus.atCustomer => StatusStyle.unloading,
        VehicleStatus.onBreak => StatusStyle.waiting,
        VehicleStatus.breakdown => StatusStyle.critical,
        VehicleStatus.maintenance || VehicleStatus.outOfService =>
          StatusStyle.offline,
      };
}

extension DriverStatusStyle on DriverStatus {
  StatusStyle get style => switch (this) {
        DriverStatus.completedDay || DriverStatus.available =>
          StatusStyle.completed,
        DriverStatus.assigned ||
        DriverStatus.driving ||
        DriverStatus.working ||
        DriverStatus.waiting =>
          StatusStyle.active,
        DriverStatus.onBreak => StatusStyle.waiting,
        DriverStatus.breakdown => StatusStyle.critical,
        DriverStatus.offline => StatusStyle.offline,
      };
}

/// Simulator string keys (tracking.dart) → [StatusStyle].
StatusStyle statusStyleForKey(String key) => switch (key) {
      'completed' => StatusStyle.completed,
      'active' => StatusStyle.active,
      'loading' => StatusStyle.loading,
      'unloading' => StatusStyle.unloading,
      'waiting' => StatusStyle.waiting,
      'critical' => StatusStyle.critical,
      _ => StatusStyle.offline,
    };

/// Resolves a [StatusStyle] to its paint color (dots, badges, markers).
Color statusStyleColor(StatusStyle style, StatusColors status) =>
    switch (style) {
      StatusStyle.completed => status.completed,
      StatusStyle.active => status.active,
      StatusStyle.loading => status.loading,
      StatusStyle.unloading => status.unloading,
      StatusStyle.waiting => status.waiting,
      StatusStyle.critical => status.critical,
      StatusStyle.offline => status.offline,
    };
