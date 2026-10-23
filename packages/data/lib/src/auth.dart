import 'package:core/core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth.freezed.dart';
part 'auth.g.dart';

/// Session returned by [AuthRepository]. Role drives go_router guards.
@freezed
abstract class Session with _$Session {
  const factory Session({
    required String userId,
    required String displayName,
    required Role role,
    String? driverId,
  }) = _Session;

  factory Session.fromJson(Map<String, Object?> json) =>
      _$SessionFromJson(json);
}

/// Auth seam: UI-first uses [MockAuthRepository]; P11 swaps the remote
/// implementation with zero widget changes.
abstract class AuthRepository {
  Future<Result<Session>> login({
    required String identifier,
    required String secret,
  });

  Future<void> logout();
}

/// Demo credentials — one per role + the R3 hero driver (Ahmed Khan).
/// PIN '1234' for drivers, password 'demo1234' for office roles.
/// Dubai tenant: all office emails end in `.ae` (r3-contracts §2).
class MockAuthRepository implements AuthRepository {
  static const _users = [
    ('admin@demo.ae', 'demo1234', 'Layla Haddad', Role.admin, null),
    ('sales@demo.ae', 'demo1234', 'Omar Farouk', Role.sales, null),
    ('dispatch@demo.ae', 'demo1234', 'Mariam Hassan', Role.dispatcher, null),
    ('fleet@demo.ae', 'demo1234', 'Hassan Ali', Role.fleetController, null),
    ('super@demo.ae', 'demo1234', 'Maha Al-Dossari', Role.supervisor, null),
    ('finance@demo.ae', 'demo1234', 'Fatima Ali', Role.finance, null),
    ('DRV-0028', '1234', 'Ahmed Khan', Role.driver, 'DRV-0028'),
    ('DRV-0014', '1234', 'Rashid Kareem', Role.driver, 'DRV-0014'),
  ];

  @override
  Future<Result<Session>> login({
    required String identifier,
    required String secret,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    for (final u in _users) {
      if (u.$1.toLowerCase() == identifier.trim().toLowerCase() &&
          u.$2 == secret) {
        return Ok(Session(
          userId: u.$1,
          displayName: u.$3,
          role: u.$4,
          driverId: u.$5,
        ));
      }
    }
    return const Err(AppError.validation(message: 'Invalid credentials'));
  }

  @override
  Future<void> logout() async {}
}
