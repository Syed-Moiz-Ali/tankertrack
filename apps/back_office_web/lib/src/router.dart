import 'package:core/core.dart';
import 'package:data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n/l10n.dart';

import 'features/auth/forgot_password_screen.dart';
import 'features/auth/office_login_screen.dart';
import 'features/auth/otp_screen.dart';
import 'features/auth/role_select_screen.dart';
import 'features/customers/customer_screens.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/depots/depot_screens.dart';
import 'features/design/design_screen.dart';
import 'features/drivers/driver_screens.dart';
import 'features/error/error_screens.dart';
import 'features/products/product_screens.dart';
import 'features/tower/tower_screen.dart';
import 'features/vehicles/vehicle_screens.dart';
import 'providers.dart';
import 'routes.dart';
import 'shell/app_shell.dart';

/// Typed route constants live in routes.dart (re-exported here so existing
/// `router.dart` importers keep working).
export 'routes.dart' show AppRoutes, mfaRoles, routeRoles;

bool isRouteAllowed(String location, Role role) {
  for (final entry in routeRoles.entries) {
    final base = entry.key;
    if (location == base || location.startsWith('$base/')) {
      return entry.value.contains(role);
    }
  }
  return true;
}

/// Mutable auth snapshot driving router refreshes. [BackOfficeApp] keeps one
/// instance for the app lifetime and syncs it from the Riverpod providers,
/// so theme/locale rebuilds never reset navigation state.
class RouterAuth extends ChangeNotifier {
  RouterAuth({
    required this.session,
    required this.pendingMfa,
    required this.roleChosen,
  });

  Session? session;
  bool pendingMfa;
  bool roleChosen;

  void update(Session? session, bool pendingMfa, bool roleChosen) {
    if (identical(this.session, session) &&
        this.pendingMfa == pendingMfa &&
        this.roleChosen == roleChosen) {
      return;
    }
    this.session = session;
    this.pendingMfa = pendingMfa;
    this.roleChosen = roleChosen;
    notifyListeners();
  }
}

/// Role-guarded router (P1 contracts §1, R3 §1): unauthenticated →
/// /login (except /forgot-password + the /design storybook); pending-MFA
/// sessions for MFA roles → /otp (/mfa alias kept); fresh sessions pick a
/// workspace on /role-select; disallowed roles → /403; unknown locations →
/// /404 page via [errorBuilder]. Authed routes render inside [AppShell];
/// auth/design and the error pages stay shell-less.
GoRouter buildRouter(RouterAuth auth) {
  return GoRouter(
    initialLocation: AppRoutes.login,
    refreshListenable: auth,
    redirect: (context, state) {
      final session = auth.session;
      final loc = state.uri.path;
      if (session == null) {
        if (loc == AppRoutes.login ||
            loc == AppRoutes.forgotPassword ||
            loc == AppRoutes.design) {
          return null;
        }
        return AppRoutes.login;
      }
      // R3 §1: every fresh login verifies BO-03 OTP (the TOTP/MFA concept
      // stays for admin/supervisor/finance — same screen), then /role-select.
      if (auth.pendingMfa) {
        if (loc != AppRoutes.otp && loc != AppRoutes.mfa) {
          return AppRoutes.otp;
        }
        return null;
      }
      if (!auth.roleChosen) {
        if (loc != AppRoutes.roleSelect) return AppRoutes.roleSelect;
        return null;
      }
      if (loc == AppRoutes.login ||
          loc == AppRoutes.mfa ||
          loc == AppRoutes.otp ||
          loc == AppRoutes.roleSelect ||
          loc == AppRoutes.forgotPassword ||
          loc == AppRoutes.root) {
        return AppRoutes.home;
      }
      if (!isRouteAllowed(loc, session.role)) return AppRoutes.forbidden;
      return null;
    },
    errorBuilder: (context, state) => NotFoundScreen(
      title: context.l10n.err404_title,
      message: context.l10n.err404_message,
      backHomeLabel: context.l10n.err_back_home,
      attemptedPath: state.uri.toString(),
      onBackHome: () => context.go(AppRoutes.home),
    ),
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const OfficeLoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.otp,
        builder: (context, state) {
          final l10n = context.l10n;
          return OtpScreen(
            strings: OtpStrings(
              title: l10n.auth_otp_title,
              hint: l10n.auth_otp_hint,
              verify: l10n.auth_otp_verify,
              resend: l10n.auth_otp_resend,
              invalid: l10n.auth_otp_invalid,
            ),
            onVerified: () => ProviderScope.containerOf(context)
                .read(sessionPendingMfaProvider.notifier)
                .state = false,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.mfa,
        builder: (context, state) {
          final l10n = context.l10n;
          return OtpScreen(
            strings: OtpStrings(
              title: l10n.auth_otp_title,
              hint: l10n.auth_otp_hint,
              verify: l10n.auth_otp_verify,
              resend: l10n.auth_otp_resend,
              invalid: l10n.auth_otp_invalid,
            ),
            onVerified: () => ProviderScope.containerOf(context)
                .read(sessionPendingMfaProvider.notifier)
                .state = false,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.roleSelect,
        builder: (context, state) => const RoleSelectScreen(),
      ),
      GoRoute(
        path: AppRoutes.design,
        builder: (context, state) => const DesignScreen(),
      ),
      GoRoute(
        path: AppRoutes.forbidden,
        builder: (context, state) {
          final l10n = context.l10n;
          return ForbiddenScreen(
            title: l10n.err403_title,
            message: l10n.err403_message,
            backHomeLabel: l10n.err_back_home,
            onBackHome: () => context.go(AppRoutes.home),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.notFound,
        builder: (context, state) {
          final l10n = context.l10n;
          return NotFoundScreen(
            title: l10n.err404_title,
            message: l10n.err404_message,
            backHomeLabel: l10n.err_back_home,
            attemptedPath: state.uri.toString(),
            onBackHome: () => context.go(AppRoutes.home),
          );
        },
      ),
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.dashboard,
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: AppRoutes.controlTower,
            builder: (context, state) => const ControlTowerScreen(),
          ),
          GoRoute(
            path: AppRoutes.customers,
            builder: (context, state) => const CustomerListScreen(),
          ),
          GoRoute(
            path: '${AppRoutes.customers}/:id',
            builder: (context, state) => CustomerDetailScreen(
              customerId: state.pathParameters['id'] ?? '',
            ),
          ),
          GoRoute(
            path: AppRoutes.depots,
            builder: (context, state) => const DepotListScreen(),
          ),
          GoRoute(
            path: '${AppRoutes.depots}/:id',
            builder: (context, state) => DepotDetailScreen(
              depotId: state.pathParameters['id'] ?? '',
            ),
          ),
          GoRoute(
            path: AppRoutes.products,
            builder: (context, state) => const ProductListScreen(),
          ),
          GoRoute(
            path: AppRoutes.drivers,
            builder: (context, state) => const DriverListScreen(),
          ),
          GoRoute(
            path: '${AppRoutes.drivers}/:id',
            builder: (context, state) => DriverDetailScreen(
              driverId: state.pathParameters['id'] ?? '',
            ),
          ),
          GoRoute(
            path: AppRoutes.vehicles,
            builder: (context, state) => const VehicleListScreen(),
          ),
          GoRoute(
            path: '${AppRoutes.vehicles}/:id',
            builder: (context, state) => VehicleDetailScreen(
              vehicleId: state.pathParameters['id'] ?? '',
            ),
          ),
        ],
      ),
    ],
  );
}
