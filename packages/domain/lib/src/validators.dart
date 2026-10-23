import 'package:core/core.dart';

import 'quantity_ig.dart';

/// Dispatch + order validation (FRS §7, §23).
class OrderValidator {
  const OrderValidator._();

  /// An order is dispatchable only with coordinates, product, qty and date.
  static Result<bool> dispatchable({
    required double? latitude,
    required double? longitude,
    required String? productId,
    required QuantityIG? quantity,
    required DateTime? requestedDate,
  }) {
    final missing = <String>[];
    if (latitude == null || longitude == null) missing.add('coordinates');
    if (productId == null || productId.isEmpty) missing.add('product');
    if (quantity == null || !quantity.isPositive) missing.add('quantity');
    if (requestedDate == null) missing.add('requestedDate');
    if (missing.isEmpty) return const Ok(true);
    return Err(AppError.validation(
      message: 'Order not dispatchable',
      details: {'missing': missing},
    ));
  }

  /// Vehicle capacity must cover the planned load (cumulative for multi-drop).
  static Result<bool> capacity({
    required QuantityIG capacity,
    required QuantityIG plannedCumulative,
    required bool supervisorOverride,
  }) {
    if (plannedCumulative <= capacity) return const Ok(true);
    if (supervisorOverride) return const Ok(true);
    return Err(AppError.validation(
      message: 'Planned load exceeds vehicle capacity without override',
      details: {
        'capacity': capacity.tenthGallons,
        'planned': plannedCumulative.tenthGallons,
      },
    ));
  }

  /// Hard blocks (FRS §23): maintenance/breakdown/critical-defect vehicle,
  /// off-duty/suspended/expired-credential driver.
  static Result<bool> assignable({
    required bool vehicleBlocked,
    required bool driverBlocked,
    required bool supervisorOverride,
  }) {
    if (!vehicleBlocked && !driverBlocked) return const Ok(true);
    if (supervisorOverride) return const Ok(true);
    return Err(AppError.validation(
      message: 'Assignment blocked without override',
      details: {
        'vehicleBlocked': vehicleBlocked,
        'driverBlocked': driverBlocked,
      },
    ));
  }
}
