import 'package:core/core.dart';

/// Generic typed state machine. Transition tables are declared per status
/// enum in `statuses.dart`; every edge is unit-tested.
class StateMachine<S> {
  const StateMachine(this.allowed);

  /// from-state → allowed to-states.
  final Map<S, Set<S>> allowed;

  bool canTransition(S from, S to) => allowed[from]?.contains(to) ?? false;

  /// Returns `Ok(to)` or `Err(validation)` — never throws.
  Result<S> transition(S from, S to) {
    if (canTransition(from, to)) return Ok(to);
    return Err(AppError.validation(
      message: 'Illegal transition: $from -> $to',
      details: {'from': '$from', 'to': '$to'},
    ));
  }

  /// States with no outgoing edges.
  Set<S> get terminals => {
        for (final e in allowed.entries)
          if (e.value.isEmpty) e.key,
      };
}
