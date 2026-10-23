/// Typed route constants — never string literals at call sites (08 §3.1).
/// Split from router.dart so feature screens can navigate without an
/// import cycle.
abstract final class AppRoutes {
  static const root = '/';
  static const login = '/login';
  static const mfa = '/mfa';
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
