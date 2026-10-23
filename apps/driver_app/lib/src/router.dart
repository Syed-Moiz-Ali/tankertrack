import 'package:data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'features/auth/driver_login_screen.dart';
import 'features/design/design_screen.dart';
import 'features/home/home_screen.dart';
import 'features/shift/start_shift_screen.dart';
import 'features/verify/verify_screen.dart';
import 'providers.dart';

/// Typed route constants — never string literals at call sites (08 §3.1).
abstract final class AppRoutes {
  static const login = '/login';
  static const design = '/design';
  static const home = '/home';

  /// R3 DR-02: account verification gate after login.
  static const verify = '/verify';

  /// R3 DR-03: start-shift gate after verification.
  static const startShift = '/start-shift';
}

/// Role-guarded router: unauthenticated → /login (except /design storybook
/// for client review); verified-but-not-started → /start-shift; unverified →
/// /verify. Watching all three gate providers rebuilds the router so each
/// gate flip lands on the right screen (same mechanism as the login gate).
GoRouter buildRouter(WidgetRef ref) {
  final session = ref.watch(sessionProvider);
  final verified = ref.watch(verifiedProvider);
  final shiftStarted = ref.watch(shiftStartedProvider);
  return GoRouter(
    initialLocation: _initial(session, verified, shiftStarted),
    redirect: (context, state) {
      final loggedIn = ref.read(sessionProvider) != null;
      final isVerified = ref.read(verifiedProvider);
      final isStarted = ref.read(shiftStartedProvider);
      final loc = state.matchedLocation;
      if (!loggedIn && loc != AppRoutes.login && loc != AppRoutes.design) {
        return AppRoutes.login;
      }
      if (loggedIn && loc == AppRoutes.login) {
        return _initial(ref.read(sessionProvider), isVerified, isStarted);
      }
      if (loggedIn &&
          !isVerified &&
          loc != AppRoutes.verify &&
          loc != AppRoutes.design) {
        return AppRoutes.verify;
      }
      if (loggedIn &&
          isVerified &&
          !isStarted &&
          loc != AppRoutes.startShift &&
          loc != AppRoutes.design) {
        return AppRoutes.startShift;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const DriverLoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.design,
        builder: (context, state) => const DesignScreen(),
      ),
      GoRoute(
        path: AppRoutes.verify,
        builder: (context, state) => const VerifyScreen(),
      ),
      GoRoute(
        path: AppRoutes.startShift,
        builder: (context, state) => const StartShiftScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
}

String _initial(Session? session, bool verified, bool shiftStarted) {
  if (session == null) return AppRoutes.login;
  if (!verified) return AppRoutes.verify;
  if (!shiftStarted) return AppRoutes.startShift;
  return AppRoutes.home;
}
