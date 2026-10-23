import 'package:core/core.dart';

/// Typed route constants — never string literals at call sites (08 §3.1).
/// Split from router.dart so feature screens can navigate without an
/// import cycle.
abstract final class AppRoutes {
  static const root = '/';
  static const login = '/login';
  static const forgotPassword = '/forgot-password';
  static const otp = '/otp';
  static const mfa = '/mfa';
  static const roleSelect = '/role-select';
  static const design = '/design';
  static const dashboard = '/dashboard';
  static const home = dashboard;
  static const controlTower = '/control-tower';
  static const customers = '/customers';
  static const depots = '/depots';
  static const products = '/products';
  static const drivers = '/drivers';
  static const vehicles = '/vehicles';
  static const forbidden = '/403';
  static const notFound = '/404';

  static String customerDetail(String id) => '$customers/$id';
  static String depotDetail(String id) => '$depots/$id';
  static String driverDetail(String id) => '$drivers/$id';
  static String vehicleDetail(String id) => '$vehicles/$id';
}
/// Allowed roles per authed route (P1 contracts §1). Detail routes inherit
/// their list route via prefix match in [isRouteAllowed]. Mirrors the role
/// sets in `buildNavTargets` (shell/nav_targets.dart) — shell_test enforces
/// the two stay in sync. Lives here (not router.dart) so shells and screens
/// can read it without an import cycle.
const Map<String, Set<Role>> routeRoles = {
  AppRoutes.dashboard: {
    Role.admin,
    Role.supervisor,
    Role.dispatcher,
    Role.fleetController,
    Role.finance,
    Role.sales,
  },
  AppRoutes.controlTower: {
    Role.admin,
    Role.supervisor,
    Role.dispatcher,
    Role.fleetController,
  },
  AppRoutes.customers: {
    Role.admin,
    Role.sales,
    Role.dispatcher,
    Role.supervisor,
    Role.finance,
  },
  AppRoutes.depots: {
    Role.admin,
    Role.dispatcher,
    Role.supervisor,
  },
  AppRoutes.products: {
    Role.admin,
    Role.dispatcher,
    Role.supervisor,
    Role.finance,
  },
  AppRoutes.drivers: {
    Role.admin,
    Role.dispatcher,
    Role.fleetController,
    Role.supervisor,
  },
  AppRoutes.vehicles: {
    Role.admin,
    Role.dispatcher,
    Role.fleetController,
    Role.supervisor,
    Role.finance,
  },
};

/// Roles gated behind MFA after password login (P1 contracts §1). Lives
/// here (not router.dart) so login screens can read it without a cycle.
const Set<Role> mfaRoles = {
  Role.admin,
  Role.supervisor,
  Role.finance,
};
