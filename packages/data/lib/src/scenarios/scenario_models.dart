/// R3 first-class scenario models (plain Dart, no codegen).
///
/// Each model mirrors one seed file under `assets/seeds/` so UI slices can
/// depend on typed accessors instead of raw maps. All quantities stay in
/// integer Imperial Gallons (IG) unless the field name says `tenths`.
/// JSON round-trips are covered by `test/scenarios_test.dart`.
library;

/// Snapshot A — live command snapshot 23 Oct 10:30 GST (BO-05/06/08).
class SnapshotA {
  const SnapshotA({
    required this.orders,
    required this.deliveries,
    required this.completed,
    required this.active,
    required this.pending,
    required this.driversActive,
    required this.driversTotal,
    required this.vehiclesActive,
    required this.vehiclesTotal,
    required this.loadedIg,
    required this.deliveredIg,
    required this.varianceIg,
    required this.breakdowns,
    required this.delayed,
    required this.liveLoading,
    required this.liveInTransit,
    required this.liveAtCustomer,
    required this.liveBreak,
    required this.liveDelayedSubset,
    required this.liveBreakdown,
    required this.heroOrderId,
    required this.heroVehicleId,
    required this.heroDriverId,
    required this.heroDriverNameEn,
    required this.heroTelemetryIg,
    required this.heroTelemetryIsLedger,
    required this.heroEtaGst,
    required this.heroDistanceKm,
  });

  final int orders;
  final int deliveries;
  final int completed;
  final int active;
  final int pending;
  final int driversActive;
  final int driversTotal;
  final int vehiclesActive;
  final int vehiclesTotal;
  final int loadedIg;
  final int deliveredIg;
  final int varianceIg;
  final int breakdowns;
  final int delayed;
  final int liveLoading;
  final int liveInTransit;
  final int liveAtCustomer;
  final int liveBreak;
  final int liveDelayedSubset;
  final int liveBreakdown;
  final String heroOrderId;
  final String heroVehicleId;
  final String heroDriverId;
  final String heroDriverNameEn;
  final int heroTelemetryIg;
  final bool heroTelemetryIsLedger;
  final String heroEtaGst;
  final double heroDistanceKm;

  factory SnapshotA.fromJson(Map<String, Object?> json) {
    final hero = json['hero_card']! as Map<String, Object?>;
    final live = json['live']! as Map<String, Object?>;
    return SnapshotA(
      orders: json['orders']! as int,
      deliveries: json['deliveries']! as int,
      completed: json['completed']! as int,
      active: json['active']! as int,
      pending: json['pending']! as int,
      driversActive: json['drivers_active']! as int,
      driversTotal: json['drivers_total']! as int,
      vehiclesActive: json['vehicles_active']! as int,
      vehiclesTotal: json['vehicles_total']! as int,
      loadedIg: json['loaded_ig']! as int,
      deliveredIg: json['delivered_ig']! as int,
      varianceIg: json['variance_ig']! as int,
      breakdowns: json['breakdowns']! as int,
      delayed: json['delayed']! as int,
      liveLoading: live['loading']! as int,
      liveInTransit: live['in_transit']! as int,
      liveAtCustomer: live['at_customer']! as int,
      liveBreak: live['break']! as int,
      liveDelayedSubset: live['delayed_subset']! as int,
      liveBreakdown: live['breakdown']! as int,
      heroOrderId: hero['order_id']! as String,
      heroVehicleId: hero['vehicle_id']! as String,
      heroDriverId: hero['driver_id']! as String,
      heroDriverNameEn: hero['driver_name_en']! as String,
      heroTelemetryIg: hero['telemetry_ig']! as int,
      heroTelemetryIsLedger: hero['telemetry_is_ledger']! as bool,
      heroEtaGst: hero['eta_gst']! as String,
      heroDistanceKm: (hero['distance_km']! as num).toDouble(),
    );
  }

  Map<String, Object?> toJson() => {
        'orders': orders,
        'deliveries': deliveries,
        'completed': completed,
        'active': active,
        'pending': pending,
        'drivers_active': driversActive,
        'drivers_total': driversTotal,
        'vehicles_active': vehiclesActive,
        'vehicles_total': vehiclesTotal,
        'loaded_ig': loadedIg,
        'delivered_ig': deliveredIg,
        'variance_ig': varianceIg,
        'breakdowns': breakdowns,
        'delayed': delayed,
        'live': {
          'loading': liveLoading,
          'in_transit': liveInTransit,
          'at_customer': liveAtCustomer,
          'break': liveBreak,
          'delayed_subset': liveDelayedSubset,
          'breakdown': liveBreakdown,
        },
        'hero_card': {
          'order_id': heroOrderId,
          'vehicle_id': heroVehicleId,
          'driver_id': heroDriverId,
          'driver_name_en': heroDriverNameEn,
          'telemetry_ig': heroTelemetryIg,
          'telemetry_is_ledger': heroTelemetryIsLedger,
          'eta_gst': heroEtaGst,
          'distance_km': heroDistanceKm,
        },
      };

  @override
  bool operator ==(Object other) =>
      other is SnapshotA &&
      other.orders == orders &&
      other.deliveries == deliveries &&
      other.completed == completed &&
      other.active == active &&
      other.pending == pending &&
      other.driversActive == driversActive &&
      other.driversTotal == driversTotal &&
      other.vehiclesActive == vehiclesActive &&
      other.vehiclesTotal == vehiclesTotal &&
      other.loadedIg == loadedIg &&
      other.deliveredIg == deliveredIg &&
      other.varianceIg == varianceIg &&
      other.breakdowns == breakdowns &&
      other.delayed == delayed &&
      other.heroOrderId == heroOrderId &&
      other.heroTelemetryIg == heroTelemetryIg;

  @override
  int get hashCode => Object.hash(orders, deliveries, loadedIg, deliveredIg);
}

/// Trip B ledger (TRIP-260021; doc 12 §3 legacy label TRIP-260023).
class TripBLedger {
  const TripBLedger({
    required this.tripId,
    required this.loadedIg,
    required this.abcIg,
    required this.balanceAfterAbcIg,
    required this.xyzIg,
    required this.balanceAfterXyzIg,
    required this.deltaIg,
    required this.balanceAfterDeltaIg,
    required this.returnIg,
    required this.closingIg,
    required this.varianceIg,
    required this.distanceKm,
  });

  final String tripId;
  final int loadedIg;
  final int abcIg;
  final int balanceAfterAbcIg;
  final int xyzIg;
  final int balanceAfterXyzIg;
  final int deltaIg;
  final int balanceAfterDeltaIg;
  final int returnIg;
  final int closingIg;
  final int varianceIg;
  final int distanceKm;

  factory TripBLedger.fromJson(Map<String, Object?> json) {
    final rawLedger = json['ledger'];
    if (rawLedger is List) {
      final ledger = rawLedger.cast<Map<String, Object?>>();
      int qtyAt(int index) => (ledger[index]['qty_ig']! as int);
      // ledger order: opening, load, ABC, XYZ, Delta, return, closing, variance
      return TripBLedger(
        tripId: json['trip_id']! as String,
        loadedIg: qtyAt(1),
        abcIg: qtyAt(2),
        balanceAfterAbcIg: (ledger[2]['balance_ig']! as int),
        xyzIg: qtyAt(3),
        balanceAfterXyzIg: (ledger[3]['balance_ig']! as int),
        deltaIg: qtyAt(4),
        balanceAfterDeltaIg: (ledger[4]['balance_ig']! as int),
        returnIg: qtyAt(5),
        closingIg: qtyAt(6),
        varianceIg: qtyAt(7),
        distanceKm: (json['distance_km']! as int),
      );
    }
    // Flat round-trip shape from toJson().
    return TripBLedger(
      tripId: json['trip_id']! as String,
      loadedIg: json['loaded_ig']! as int,
      abcIg: json['abc_ig']! as int,
      balanceAfterAbcIg: json['balance_after_abc_ig']! as int,
      xyzIg: json['xyz_ig']! as int,
      balanceAfterXyzIg: json['balance_after_xyz_ig']! as int,
      deltaIg: json['delta_ig']! as int,
      balanceAfterDeltaIg: json['balance_after_delta_ig']! as int,
      returnIg: json['return_ig']! as int,
      closingIg: json['closing_ig']! as int,
      varianceIg: json['variance_ig']! as int,
      distanceKm: json['distance_km']! as int,
    );
  }

  Map<String, Object?> toJson() => {
        'trip_id': tripId,
        'loaded_ig': loadedIg,
        'abc_ig': abcIg,
        'balance_after_abc_ig': balanceAfterAbcIg,
        'xyz_ig': xyzIg,
        'balance_after_xyz_ig': balanceAfterXyzIg,
        'delta_ig': deltaIg,
        'balance_after_delta_ig': balanceAfterDeltaIg,
        'return_ig': returnIg,
        'closing_ig': closingIg,
        'variance_ig': varianceIg,
        'distance_km': distanceKm,
        'ledger': [
          {'step': 'opening', 'qty_ig': 0, 'balance_ig': 0},
          {'step': 'load', 'qty_ig': loadedIg, 'balance_ig': loadedIg},
          {
            'step': 'delivery',
            'order_id': 'SO-260145',
            'qty_ig': abcIg,
            'balance_ig': balanceAfterAbcIg,
          },
          {
            'step': 'delivery',
            'order_id': 'SO-260146',
            'qty_ig': xyzIg,
            'balance_ig': balanceAfterXyzIg,
          },
          {
            'step': 'delivery',
            'order_id': 'SO-260147',
            'qty_ig': deltaIg,
            'balance_ig': balanceAfterDeltaIg,
          },
          {'step': 'return', 'qty_ig': returnIg, 'balance_ig': returnIg},
          {'step': 'closing', 'qty_ig': closingIg, 'balance_ig': closingIg},
          {'step': 'variance', 'qty_ig': varianceIg, 'balance_ig': varianceIg},
        ],
      };

  @override
  bool operator ==(Object other) =>
      other is TripBLedger &&
      other.tripId == tripId &&
      other.loadedIg == loadedIg &&
      other.abcIg == abcIg &&
      other.balanceAfterAbcIg == balanceAfterAbcIg &&
      other.xyzIg == xyzIg &&
      other.balanceAfterXyzIg == balanceAfterXyzIg &&
      other.deltaIg == deltaIg &&
      other.balanceAfterDeltaIg == balanceAfterDeltaIg &&
      other.returnIg == returnIg &&
      other.distanceKm == distanceKm;

  @override
  int get hashCode => Object.hash(tripId, loadedIg, distanceKm);
}

/// R-27 stock exception: 4,950 − 4,700 − 200 − 0 = 50 unexplained.
class ExceptionR27 {
  const ExceptionR27({
    required this.tripId,
    required this.loadedIg,
    required this.deliveredIg,
    required this.returnedIg,
    required this.closingIg,
    required this.unexplainedIg,
    required this.owner,
    required this.approvalState,
  });

  final String tripId;
  final int loadedIg;
  final int deliveredIg;
  final int returnedIg;
  final int closingIg;
  final int unexplainedIg;
  final String owner;
  final String approvalState;

  factory ExceptionR27.fromJson(Map<String, Object?> json) => ExceptionR27(
        tripId: json['trip_id']! as String,
        loadedIg: json['loaded_ig']! as int,
        deliveredIg: json['delivered_ig']! as int,
        returnedIg: json['returned_ig']! as int,
        closingIg: json['closing_ig']! as int,
        unexplainedIg: json['unexplained_ig']! as int,
        owner: json['owner']! as String,
        approvalState: json['approval_state']! as String,
      );

  Map<String, Object?> toJson() => {
        'trip_id': tripId,
        'loaded_ig': loadedIg,
        'delivered_ig': deliveredIg,
        'returned_ig': returnedIg,
        'closing_ig': closingIg,
        'unexplained_ig': unexplainedIg,
        'owner': owner,
        'approval_state': approvalState,
      };

  /// Exact ledger check: loaded − delivered − returned − closing.
  int get computedUnexplained => loadedIg - deliveredIg - returnedIg - closingIg;

  @override
  bool operator ==(Object other) =>
      other is ExceptionR27 &&
      other.tripId == tripId &&
      other.loadedIg == loadedIg &&
      other.deliveredIg == deliveredIg &&
      other.returnedIg == returnedIg &&
      other.unexplainedIg == unexplainedIg;

  @override
  int get hashCode => Object.hash(tripId, unexplainedIg);
}

/// Reporting week 16–22 Oct 2026 (closed period, separate from live).
class ReportWeek {
  const ReportWeek({
    required this.deliveredIg,
    required this.onTimePct,
    required this.deliveriesTotal,
    required this.deliveriesOnTime,
    required this.varianceIg,
    required this.fleetUtilisationPct,
    required this.dailyBars,
  });

  final int deliveredIg;
  final double onTimePct;
  final int deliveriesTotal;
  final int deliveriesOnTime;
  final int varianceIg;
  final double fleetUtilisationPct;
  final List<int> dailyBars;

  factory ReportWeek.fromJson(Map<String, Object?> json) => ReportWeek(
        deliveredIg: json['delivered_ig']! as int,
        onTimePct: (json['on_time_pct']! as num).toDouble(),
        deliveriesTotal: json['deliveries_total']! as int,
        deliveriesOnTime: json['deliveries_on_time']! as int,
        varianceIg: json['variance_ig']! as int,
        fleetUtilisationPct:
            (json['fleet_utilisation_pct']! as num).toDouble(),
        dailyBars:
            (json['daily_bars_ig']! as List).map((e) => (e as int)).toList(),
      );

  Map<String, Object?> toJson() => {
        'delivered_ig': deliveredIg,
        'on_time_pct': onTimePct,
        'deliveries_total': deliveriesTotal,
        'deliveries_on_time': deliveriesOnTime,
        'variance_ig': varianceIg,
        'fleet_utilisation_pct': fleetUtilisationPct,
        'daily_bars_ig': dailyBars,
      };

  @override
  bool operator ==(Object other) =>
      other is ReportWeek &&
      other.deliveredIg == deliveredIg &&
      other.deliveriesTotal == deliveriesTotal &&
      other.varianceIg == varianceIg;

  @override
  int get hashCode => Object.hash(deliveredIg, deliveriesTotal);
}
