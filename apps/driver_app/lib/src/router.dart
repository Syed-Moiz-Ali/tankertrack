import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'features/auth/driver_login_screen.dart';
import 'features/design/design_screen.dart';
import 'features/home/home_screen.dart';
import 'providers.dart';

/// Typed route constants — never string literals at call sites (08 §3.1).
abstract final class AppRoutes {
  static const login = '/login';
  static const design = '/design';
  static const home = '/home';
}

/// Role-guarded router: unauthenticated → /login (except /design storybook
/// for client review); authenticated away from /login → /home.
GoRouter buildRouter(WidgetRef ref) {
  final session = ref.watch(sessionProvider);
  return GoRouter(
    initialLocation: session == null ? AppRoutes.login : AppRoutes.home,
    redirect: (context, state) {
      final loggedIn = ref.read(sessionProvider) != null;
      final loc = state.matchedLocation;
      if (!loggedIn && loc != AppRoutes.login && loc != AppRoutes.design) {
        return AppRoutes.login;
      }
      if (loggedIn && loc == AppRoutes.login) return AppRoutes.home;
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
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
}
