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
}

/// Shell destinations in display order. Role sets mirror the route table
/// (P1 contracts §1) — keep in sync with `routeRoles` in router.dart
/// (enforced by shell_test consistency checks).
List<NavTarget> buildNavTargets(ShellStrings strings) => [
      NavTarget(
        path: AppRoutes.dashboard,
        label: strings.dashboard,
        icon: AppIcons.dashboard,
        roles: const {
          Role.admin,
          Role.supervisor,
          Role.dispatcher,
          Role.fleetController,
          Role.finance,
          Role.sales,
        },
      ),
      NavTarget(
        path: AppRoutes.controlTower,
        label: strings.tower,
        icon: AppIcons.tracking,
        roles: const {
          Role.admin,
          Role.supervisor,
          Role.dispatcher,
          Role.fleetController,
        },
      ),
      NavTarget(
        path: AppRoutes.customers,
        label: strings.customers,
        icon: AppIcons.customer,
        roles: const {
          Role.admin,
          Role.sales,
          Role.dispatcher,
          Role.supervisor,
          Role.finance,
        },
      ),
      NavTarget(
        path: AppRoutes.depots,
        label: strings.depots,
        icon: AppIcons.depot,
        roles: const {
          Role.admin,
          Role.dispatcher,
          Role.supervisor,
        },
      ),
      NavTarget(
        path: AppRoutes.products,
        label: strings.products,
        icon: AppIcons.fuelDrop,
        roles: const {
          Role.admin,
          Role.dispatcher,
          Role.supervisor,
          Role.finance,
        },
      ),
      NavTarget(
        path: AppRoutes.drivers,
        label: strings.drivers,
        icon: AppIcons.user,
        roles: const {
          Role.admin,
          Role.dispatcher,
          Role.fleetController,
          Role.supervisor,
        },
      ),
      NavTarget(
        path: AppRoutes.vehicles,
        label: strings.vehicles,
        icon: AppIcons.truck,
        roles: const {
          Role.admin,
          Role.dispatcher,
          Role.fleetController,
          Role.supervisor,
          Role.finance,
        },
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
