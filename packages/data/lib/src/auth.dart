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

/// Demo credentials — one per role + the S1 hero driver.
/// PIN '1234' for drivers, password 'demo1234' for office roles.
class MockAuthRepository implements AuthRepository {
  static const _users = [
    ('admin@demo.sa', 'demo1234', 'Layla Haddad', Role.admin, null),
    ('sales@demo.sa', 'demo1234', 'Omar Farouk', Role.sales, null),
    ('dispatch@demo.sa', 'demo1234', 'Sara Al-Qahtani', Role.dispatcher, null),
    ('fleet@demo.sa', 'demo1234', 'Hassan Ali', Role.fleetController, null),
    ('super@demo.sa', 'demo1234', 'Maha Al-Dossari', Role.supervisor, null),
    ('finance@demo.sa', 'demo1234', 'Adel Karim', Role.finance, null),
    ('DRV-001', '1234', 'Khalid Al-Otaibi', Role.driver, 'DRV-001'),
    ('DRV-002', '1234', 'Ahmed Al-Shammari', Role.driver, 'DRV-002'),
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
