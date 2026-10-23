import 'state_machine.dart';

/// Canonical statuses — exactly FRS §17. Image variants (Scheduled,
/// Delivered, Inspection, Loaded, Returning…) are DERIVED display aliases
/// (see helpers below), never stored states.

enum OrderStatus {
  draft,
  confirmed,
  onHold,
  unassigned,
  assigned,
  inProgress,
  completed,
  partial,
  failed,
  cancelled,
}

enum TripStatus {
  planned,
  assigned,
  accepted,
  started,
  atLoading,
  loaded,
  delivering,
  paused,
  breakdown,
  completed,
  closed,
}

enum TaskStatus {
  pending,
  accepted,
  enRoute,
  arrived,
  started,
  completed,
  skipped,
  failed,
  cancelled,
}

enum VehicleStatus {
  available,
  reserved,
  loading,
  inTransit,
  atCustomer,
  onBreak,
  breakdown,
  maintenance,
  outOfService,
}

enum DriverStatus {
  offline,
  available,
  assigned,
  driving,
  working,
  waiting,
  onBreak,
  breakdown,
  completedDay,
}

class StatusMachines {
  const StatusMachines._();

  static const order = StateMachine<OrderStatus>({
    OrderStatus.draft: {OrderStatus.confirmed, OrderStatus.cancelled},
    OrderStatus.confirmed: {
      OrderStatus.unassigned,
      OrderStatus.onHold,
      OrderStatus.cancelled,
    },
    OrderStatus.onHold: {OrderStatus.confirmed, OrderStatus.cancelled},
    OrderStatus.unassigned: {
      OrderStatus.assigned,
      OrderStatus.onHold,
      OrderStatus.cancelled,
    },
    OrderStatus.assigned: {
      OrderStatus.inProgress,
      OrderStatus.unassigned,
      OrderStatus.onHold,
      OrderStatus.cancelled,
    },
    OrderStatus.inProgress: {
      OrderStatus.completed,
      OrderStatus.partial,
      OrderStatus.failed,
      OrderStatus.onHold,
      OrderStatus.cancelled,
    },
    OrderStatus.partial: {OrderStatus.completed, OrderStatus.failed},
    OrderStatus.failed: {OrderStatus.unassigned},
    OrderStatus.completed: {},
    OrderStatus.cancelled: {},
  });

  static const trip = StateMachine<TripStatus>({
    TripStatus.planned: {TripStatus.assigned},
    TripStatus.assigned: {TripStatus.accepted, TripStatus.planned},
    TripStatus.accepted: {TripStatus.started},
    TripStatus.started: {
      TripStatus.atLoading,
      TripStatus.paused,
      TripStatus.breakdown,
    },
    TripStatus.atLoading: {
      TripStatus.loaded,
      TripStatus.paused,
      TripStatus.breakdown,
    },
    TripStatus.loaded: {
      TripStatus.delivering,
      TripStatus.paused,
      TripStatus.breakdown,
    },
    TripStatus.delivering: {
      TripStatus.paused,
      TripStatus.breakdown,
      TripStatus.completed,
    },
    TripStatus.paused: {TripStatus.started, TripStatus.breakdown},
    TripStatus.breakdown: {TripStatus.started},
    TripStatus.completed: {TripStatus.closed},
    TripStatus.closed: {},
  });

  static const task = StateMachine<TaskStatus>({
    TaskStatus.pending: {
      TaskStatus.accepted,
      TaskStatus.skipped,
      TaskStatus.cancelled,
    },
    TaskStatus.accepted: {TaskStatus.enRoute, TaskStatus.cancelled},
    TaskStatus.enRoute: {TaskStatus.arrived, TaskStatus.failed},
    TaskStatus.arrived: {TaskStatus.started, TaskStatus.failed},
    TaskStatus.started: {
      TaskStatus.completed,
      TaskStatus.failed,
      TaskStatus.skipped,
    },
    TaskStatus.completed: {},
    TaskStatus.skipped: {},
    TaskStatus.failed: {TaskStatus.pending},
    TaskStatus.cancelled: {},
  });

  static const vehicle = StateMachine<VehicleStatus>({
    VehicleStatus.available: {
      VehicleStatus.reserved,
      VehicleStatus.maintenance,
      VehicleStatus.outOfService,
    },
    VehicleStatus.reserved: {
      VehicleStatus.available,
      VehicleStatus.loading,
      VehicleStatus.maintenance,
    },
    VehicleStatus.loading: {
      VehicleStatus.inTransit,
      VehicleStatus.onBreak,
      VehicleStatus.breakdown,
    },
    VehicleStatus.inTransit: {
      VehicleStatus.atCustomer,
      VehicleStatus.onBreak,
      VehicleStatus.breakdown,
    },
    VehicleStatus.atCustomer: {
      VehicleStatus.inTransit,
      VehicleStatus.onBreak,
      VehicleStatus.available,
      VehicleStatus.breakdown,
    },
    VehicleStatus.onBreak: {
      VehicleStatus.loading,
      VehicleStatus.inTransit,
      VehicleStatus.atCustomer,
      VehicleStatus.available,
    },
    VehicleStatus.breakdown: {
      VehicleStatus.maintenance,
      VehicleStatus.available,
    },
    VehicleStatus.maintenance: {VehicleStatus.available},
    VehicleStatus.outOfService: {
      VehicleStatus.available,
      VehicleStatus.maintenance,
    },
  });

  static const driver = StateMachine<DriverStatus>({
    DriverStatus.offline: {DriverStatus.available},
    DriverStatus.available: {DriverStatus.assigned, DriverStatus.offline},
    DriverStatus.assigned: {
      DriverStatus.driving,
      DriverStatus.waiting,
      DriverStatus.onBreak,
      DriverStatus.completedDay,
    },
    DriverStatus.driving: {
      DriverStatus.waiting,
      DriverStatus.working,
      DriverStatus.onBreak,
      DriverStatus.breakdown,
      DriverStatus.completedDay,
    },
    DriverStatus.working: {
      DriverStatus.driving,
      DriverStatus.waiting,
      DriverStatus.onBreak,
      DriverStatus.completedDay,
    },
    DriverStatus.waiting: {
      DriverStatus.driving,
      DriverStatus.working,
      DriverStatus.onBreak,
      DriverStatus.completedDay,
    },
    DriverStatus.onBreak: {
      DriverStatus.assigned,
      DriverStatus.driving,
      DriverStatus.working,
      DriverStatus.waiting,
    },
    DriverStatus.breakdown: {DriverStatus.assigned},
    DriverStatus.completedDay: {
      DriverStatus.offline,
      DriverStatus.available,
    },
  });
}

/// Derived display aliases (C1/C3). Pure functions — never stored.
class DerivedStatus {
  const DerivedStatus._();

  /// `Scheduled` = Assigned with a planned date (flag-gated in UI).
  static bool orderShowsScheduled(OrderStatus s, {required bool hasPlanDate}) =>
      s == OrderStatus.assigned && hasPlanDate;

  /// `Delivered` = Completed for single-drop orders (flag-gated in UI).
  static bool orderShowsDelivered(OrderStatus s, {required bool singleDrop}) =>
      s == OrderStatus.completed && singleDrop;

  /// FRS §6 granular transit phases derived from linked trip/task states.
  static String? orderExecutionPhase({
    required OrderStatus order,
    TripStatus? trip,
    TaskStatus? task,
  }) {
    if (order != OrderStatus.inProgress) return null;
    if (task == TaskStatus.enRoute) return 'en_route_loading';
    if (task == TaskStatus.arrived) return 'arrived';
    if (task == TaskStatus.started) {
      return trip == TripStatus.atLoading ? 'loading' : 'unloading';
    }
    if (trip == TripStatus.loaded) return 'loaded';
    if (trip == TripStatus.delivering) return 'en_route_customer';
    return 'in_progress';
  }
}
