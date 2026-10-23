import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:l10n/l10n.dart';

import '../router.dart';

/// One shell destination: typed route path, resolved localized label,
/// semantic icon, and the roles allowed to see it (P1 contracts §1).
class NavTarget {
  const NavTarget({
    required this.path,
    required this.label,
    required this.icon,
    required this.roles,
  });

  final String path;
  final String label;
  final AppIcon icon;
  final Set<Role> roles;
}

/// Localized labels for shell navigation. Built from `context.l10n` at the
/// call site — this object holds zero styling and zero raw strings.
class ShellStrings {
  const ShellStrings({
    required this.dashboard,
    required this.tower,
    required this.customers,
    required this.depots,
    required this.products,
    required this.drivers,
    required this.vehicles,
    required this.catalogue,
    required this.searchHint,
    required this.signOut,
    required this.today,
    required this.fleet,
    required this.menu,
    required this.profile,
    required this.theme,
    required this.language,
    required this.demoRole,
    required this.searchHintDrivers,
    required this.searchHintVehicles,
    required this.searchHintCustomers,
    required this.allLabel,
  });

  factory ShellStrings.fromL10n(AppLocalizations l10n) => ShellStrings(
        dashboard: l10n.nav_dashboard,
        tower: l10n.nav_tower,
        customers: l10n.nav_customers,
        depots: l10n.nav_depots,
        products: l10n.nav_products,
        drivers: l10n.nav_drivers,
        vehicles: l10n.nav_vehicles,
        catalogue: l10n.nav_catalogue,
        searchHint: l10n.shell_search_hint,
        signOut: l10n.nav_signout,
        today: l10n.tab_today,
        fleet: l10n.nav_vehicles,
        menu: l10n.menu_title,
        profile: l10n.menu_profile,
        theme: l10n.menu_theme,
        language: l10n.menu_language,
        demoRole: l10n.menu_demo_role,
        searchHintDrivers: l10n.search_driver,
        searchHintVehicles: l10n.search_vehicle,
        searchHintCustomers: l10n.search_customer,
        allLabel: l10n.mst_all,
      );

  final String dashboard;
  final String tower;
  final String customers;
  final String depots;
  final String products;
  final String drivers;
  final String vehicles;
  final String catalogue;
  final String searchHint;
  final String signOut;
  final String today;
  final String fleet;
  final String menu;
  final String profile;
  final String theme;
  final String language;
  final String demoRole;
  final String searchHintDrivers;
  final String searchHintVehicles;
  final String searchHintCustomers;
  final String allLabel;
}

/// Top-level tab (R1): Today → dashboard, Fleet → vehicles,
/// Customers → customers, Menu → popover sheet (no route).
class TopTab {
  const TopTab({
    required this.label,
    required this.icon,
    required this.roles,
    this.path,
  });

  final String label;
  final AppIcon icon;
  final Set<Role> roles;

  /// Null for the Menu tab (opens the menu sheet instead of navigating).
  final String? path;
}

/// Top tabs in display order (contracts §5). Role sets mirror `routeRoles`.
List<TopTab> buildTopTabs(ShellStrings strings) => [
      TopTab(
        path: AppRoutes.dashboard,
        label: strings.today,
        icon: AppIcons.dashboard,
        roles: routeRoles[AppRoutes.dashboard]!,
      ),
      TopTab(
        path: AppRoutes.vehicles,
        label: strings.fleet,
        icon: AppIcons.truck,
        roles: routeRoles[AppRoutes.vehicles]!,
      ),
      TopTab(
        path: AppRoutes.customers,
        label: strings.customers,
        icon: AppIcons.customer,
        roles: routeRoles[AppRoutes.customers]!,
      ),
      TopTab(
        label: strings.menu,
        icon: AppIcons.settings,
        roles: const {
          Role.admin,
          Role.sales,
          Role.dispatcher,
          Role.fleetController,
          Role.supervisor,
          Role.finance,
          Role.driver,
          Role.customerStub,
        },
      ),
    ];

/// Menu sheet entries (contracts §5): only EXISTING routes — no dead UI.
/// Design catalogue is visible to every signed-in role.
List<NavTarget> buildMenuEntries(ShellStrings strings) => [
      NavTarget(
        path: AppRoutes.controlTower,
        label: strings.tower,
        icon: AppIcons.tracking,
        roles: routeRoles[AppRoutes.controlTower]!,
      ),
      NavTarget(
        path: AppRoutes.depots,
        label: strings.depots,
        icon: AppIcons.depot,
        roles: routeRoles[AppRoutes.depots]!,
      ),
      NavTarget(
        path: AppRoutes.products,
        label: strings.products,
        icon: AppIcons.fuelDrop,
        roles: routeRoles[AppRoutes.products]!,
      ),
      NavTarget(
        path: AppRoutes.drivers,
        label: strings.drivers,
        icon: AppIcons.user,
        roles: routeRoles[AppRoutes.drivers]!,
      ),
      NavTarget(
        path: AppRoutes.design,
        label: strings.catalogue,
        icon: AppIcons.info,
        roles: const {
          Role.admin,
          Role.sales,
          Role.dispatcher,
          Role.fleetController,
          Role.supervisor,
          Role.finance,
          Role.driver,
          Role.customerStub,
        },
      ),
    ];

/// Shell destinations in display order. Role sets mirror the route table
/// (P1 contracts §1) — keep in sync with `routeRoles` in router.dart
/// (enforced by shell_test consistency checks).
List<NavTarget> buildNavTargets(ShellStrings strings) => [
      NavTarget(
        path: AppRoutes.dashboard,
        label: strings.dashboard,
        icon: AppIcons.dashboard,
        roles: routeRoles[AppRoutes.dashboard]!,
      ),
      NavTarget(
        path: AppRoutes.controlTower,
        label: strings.tower,
        icon: AppIcons.tracking,
        roles: routeRoles[AppRoutes.controlTower]!,
      ),
      NavTarget(
        path: AppRoutes.customers,
        label: strings.customers,
        icon: AppIcons.customer,
        roles: routeRoles[AppRoutes.customers]!,
      ),
      NavTarget(
        path: AppRoutes.depots,
        label: strings.depots,
        icon: AppIcons.depot,
        roles: routeRoles[AppRoutes.depots]!,
      ),
      NavTarget(
        path: AppRoutes.products,
        label: strings.products,
        icon: AppIcons.fuelDrop,
        roles: routeRoles[AppRoutes.products]!,
      ),
      NavTarget(
        path: AppRoutes.drivers,
        label: strings.drivers,
        icon: AppIcons.user,
        roles: routeRoles[AppRoutes.drivers]!,
      ),
      NavTarget(
        path: AppRoutes.vehicles,
        label: strings.vehicles,
        icon: AppIcons.truck,
        roles: routeRoles[AppRoutes.vehicles]!,
      ),
      NavTarget(
        path: AppRoutes.design,
        label: strings.catalogue,
        icon: AppIcons.info,
        roles: const {
          Role.admin,
          Role.sales,
          Role.dispatcher,
          Role.fleetController,
          Role.supervisor,
          Role.finance,
          Role.driver,
          Role.customerStub,
        },
      ),
    ];
