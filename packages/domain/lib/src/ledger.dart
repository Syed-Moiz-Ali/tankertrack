import 'package:core/core.dart';

import 'quantity_ig.dart';

/// Ledger transaction kinds (FRS §14).
enum LedgerKind { opening, load, delivery, ret, transferOut, transferIn, adjustment }

class LedgerEntry {
  const LedgerEntry({
    required this.kind,
    required this.signedTenths,
    required this.reference,
  });

  final LedgerKind kind;
  final int signedTenths;
  final String reference;

  QuantityIG get quantity => QuantityIG(signedTenths);
}

/// Variance disposition vs tolerance.
enum VarianceDisposition { withinTolerance, reasonRequired, approvalRequired }

/// Vehicle on-board balance rules (FRS §14 + §23).
/// Formula: Opening + Loaded − Delivered − Returned ± Adjustments = Closing.
class LedgerRule {
  const LedgerRule._();

  /// Exact integer closing balance.
  static QuantityIG closing({
    required QuantityIG opening,
    List<QuantityIG> loads = const [],
    List<QuantityIG> deliveries = const [],
    List<QuantityIG> returns = const [],
    List<QuantityIG> adjustments = const [],
  }) {
    var total = opening.tenthGallons;
    for (final q in loads) {
      total += q.tenthGallons;
    }
    for (final q in deliveries) {
      total -= q.tenthGallons;
    }
    for (final q in returns) {
      total -= q.tenthGallons;
    }
    for (final q in adjustments) {
      total += q.tenthGallons;
    }
    return QuantityIG(total);
  }

  /// A delivery must not exceed on-board balance without supervisor override.
  static Result<QuantityIG> checkDelivery({
    required QuantityIG onBoard,
    required QuantityIG requested,
    required bool supervisorOverride,
  }) {
    if (requested <= onBoard) return Ok(QuantityIG(onBoard.tenthGallons - requested.tenthGallons));
    if (supervisorOverride) {
      return Ok(QuantityIG(onBoard.tenthGallons - requested.tenthGallons));
    }
    return Err(AppError.validation(
      message: 'Delivery exceeds on-board balance without override',
      details: {
        'onBoard': onBoard.tenthGallons,
        'requested': requested.tenthGallons,
      },
    ));
  }

  /// Variance vs tolerance: |planned − actual| compared against the GREATER
  /// of pct-of-planned and absolute tolerance (configurable per txn type).
  static VarianceDisposition variance({
    required QuantityIG planned,
    required QuantityIG actual,
    required int tolerancePct,
    required int toleranceAbsTenths,
  }) {
    final diff = (planned.tenthGallons - actual.tenthGallons).abs();
    if (diff == 0) return VarianceDisposition.withinTolerance;
    final pctTol = (planned.tenthGallons.abs() * tolerancePct) ~/ 100;
    final tol = pctTol > toleranceAbsTenths ? pctTol : toleranceAbsTenths;
    if (diff <= tol) return VarianceDisposition.withinTolerance;
    if (diff <= tol * 2) return VarianceDisposition.reasonRequired;
    return VarianceDisposition.approvalRequired;
  }
}
