# P1 Contracts — Back-Office Shell + Dashboard + Masters (frozen for the phase)

> Main session wrote these FIRST. Slices implement against them; changes
> need main-session approval + `changes.md` entry. Slices own DISJOINT
> files (see §5); shared files are touched by the main session only.

## 1. Route table (`apps/back_office_web/lib/src/router.dart`, slice C)

| Path | Screen | Allowed roles |
|---|---|---|
| `/login` | OfficeLoginScreen (exists) | — |
| `/mfa` | MfaScreen (slice C) | pending-MFA session only |
| `/design` | DesignScreen (exists) | — (review) |
| `/` | redirect → `/dashboard` | auth |
| `/dashboard` | DashboardScreen (slice D) | admin, supervisor, dispatcher, fleetController, finance, sales |
| `/control-tower` | ControlTowerScreen (slice D) | admin, supervisor, dispatcher, fleetController |
| `/customers` | CustomerListScreen (D) | admin, sales, dispatcher, supervisor, finance |
| `/customers/:id` | CustomerDetailScreen (D, sites tab inside) | same |
| `/depots` | DepotListScreen (D) | admin, dispatcher, supervisor |
| `/depots/:id` | DepotDetailScreen (D) | same |
| `/products` | ProductListScreen (D) | admin, dispatcher, supervisor, finance |
| `/drivers` | DriverListScreen (D) | admin, dispatcher, fleetController, supervisor |
| `/drivers/:id` | DriverDetailScreen (D, calendar tab) | same |
| `/vehicles` | VehicleListScreen (D) | admin, dispatcher, fleetController, supervisor, finance |
| `/vehicles/:id` | VehicleDetailScreen (D, calendar tab) | same |
| `/403` | ForbiddenScreen (C) | — |
| `/404` | NotFoundScreen (C, via errorBuilder) | — |

`AppRoutes` gains matching constants. MFA flow: password login for roles
admin/supervisor/finance → `/mfa`; driver/sales/dispatcher/fleetController
skip MFA (demo policy, documented on the screen). Demo TOTP: any 6-digit
code accepted in demo builds (non-demo: error state, real TOTP is P11).

## 2. Data API (`packages/data/lib/src/masters/`, slice A)

```dart
// Entities (immutable, fromJson over seed keys, bilingual name getters):
class Customer { id, code, nameEn, nameAr, contact, phone, status }
class DeliverySite { id, customerId, nameEn, nameAr, lat, lng, geofenceM, gateHours }
class Depot { id, nameEn, nameAr, lat, lng, geofenceM, hours, products }
class Product { id, nameEn, nameAr, unit, active }
class DriverInfo { id, nameEn, nameAr, phone, status, licenceExpiryDays }
class VehicleInfo { id, registration, capacityTenths, onBoardTenths, status, docExpiryDays, criticalDefect }
class OrderSummary { id, siteId, productId, qtyTenths, priority, window, status, hasVariance }
class AlertItem { id, type, severity, titleEn, titleAr, atIdentifier }
class DashboardKpis {
  requestedTenths, loadedTenths, deliveredTenths, pendingTenths,
  ordersByStatus: Map<String,int>, driversAvailable, driversBusy, driversOffline,
  vehiclesFree, vehiclesAssigned, vehiclesBreakdown, vehiclesMaintenance,
  lateOrders, alerts: List<AlertItem>, reloadRequired: List<String> vehicleIds,
}

abstract class MasterDataService {
  Future<List<Customer>> customers();
  Future<List<DeliverySite>> sites();           // all; filter client-side
  Future<List<DeliverySite>> sitesFor(String customerId);
  Future<List<Depot>> depots();
  Future<List<Product>> products();
  Future<List<DriverInfo>> drivers();
  Future<List<VehicleInfo>> vehicles();
  Future<List<OrderSummary>> ordersToday();
  Future<DashboardKpis> dashboardKpis();
}
class MockMasterDataService implements MasterDataService // over SeedBundle
```

SeedBundle gains `fromStrings(Map<String,String>)` + `assetUris` map
(`packages/data/assets/seeds/<file>` URIs). `data/pubspec.yaml` gains
`flutter: assets: [assets/seeds/]` so apps load via
`rootBundle.loadString('packages/data/...')`. Slice A owns all of this +
`masters_test.dart` (volumes, KPI math vs seeds, S1 spot checks).

App-side: `apps/back_office_web/lib/src/data_providers.dart` (slice D):
`seedBundleProvider` (FutureProvider, rootBundle load with TTSkeleton
splash), `masterDataProvider` (MockMasterDataService over bundle),
`kpisProvider`, `trackingProvider` (MockTrackingSimulator, started once,
disposed on app end — stream exposed as StreamProvider ticking).

## 3. ARB key list (slice B implements en+ar, regens, extends parity test)

nav_dashboard, nav_tower, nav_customers, nav_depots, nav_products,
nav_drivers, nav_vehicles, nav_catalogue, nav_signout,
shell_search_hint, shell_notifications, shell_demo_role, shell_online,
shell_offline,
mfa_title, mfa_hint, mfa_code_label, mfa_verify, mfa_invalid, mfa_note_demo,
err403_title, err403_message, err404_title, err404_message, err_back_home,
dash_title, dash_kpi_requested, dash_kpi_loaded, dash_kpi_delivered,
dash_kpi_pending, dash_orders_by_status, dash_drivers, dash_vehicles,
dash_late_orders, dash_alerts, dash_reload, dash_process_title,
dash_step1..dash_step8 (8 back-office steps, short labels),
tower_title, tower_live, tower_board, tower_alerts, tower_reload,
mst_search, mst_all, mst_active, mst_inactive, mst_create, mst_edit,
mst_save, mst_name_en, mst_name_ar, mst_phone, mst_contact, mst_status,
mst_capacity, mst_onboard, mst_docs_ok, mst_docs_expiring, mst_empty_title,
mst_empty_message, mst_error_title, mst_retry,
cust_sites_tab, cust_orders_hint,
site_geofence, site_gate_hours, site_lat, site_lng,
drv_licence, drv_calendar_title, drv_commitments,
veh_balance, veh_calendar_title, veh_defect_block,
cal_today, cal_commitment_days,
depot_hours, depot_products, prod_unit, prod_active,
list_rows (e.g. "{count} rows" with count placeholder).

## 4. Component APIs (already in main — consume as specified)

- `TTMonthCalendar(year, month, commitments, weekdayLabels, selected?,
  onSelectDay?)` — design_system (DONE, P0 commit + this phase).
  Weekday labels: caller passes 7 localized short names, locale-week order.
- `MiniMap` (slice D implements in fleet_ui): constructor takes
  `positions: List<MapPosition>` where
  `class MapPosition { id, lat, lng, style: StatusStyle, label }`
  + `height` from tokens (no literal). Renders stylized bounds-aware dots
  on a theme-colored canvas (CustomPainter gets colors via constructor —
  read `context.colors`/`context.status` at the build site).
- All lists: `TTScaffold` + sticky `TTSearchBar` + `TTFilterPills` +
  virtualized table (`ListView.builder`, 56px rows via ListTileTheme) +
  `TTSkeleton`/`TTEmptyState`/`TTErrorState`. Detail pages: `TTSection`
  blocks + `TTTimeline` where relevant. Forms: `TTTextField` +
  `TTDropdown` + validation via l10n strings.

## 5. Slice file ownership (disjoint)

- **Slice A (domain-data)**: `packages/data/lib/src/masters/**`,
  `packages/data/pubspec.yaml` (assets decl), `packages/data/test/masters_test.dart`.
- **Slice B (l10n-rtl)**: `packages/l10n/lib/arb/*`,
  `packages/l10n/lib/src/gen/*`, `packages/l10n/test/l10n_test.dart`.
- **Slice C (ui-shell)**: `apps/back_office_web/{pubspec.yaml,lib/src/shell/**,lib/src/features/auth/mfa*,lib/src/features/error/**,lib/src/{app,router,providers}.dart,lib/src/data_bootstrap.dart(seed asset load helper),web/**,test/shell_test.dart}`.
  May edit `apps/back_office_web/lib/src/{app,router}.dart` (shared with D
  by contract §1 — C owns them; D must NOT touch).
- **Slice D (ui-ops)**: `apps/back_office_web/lib/src/{data_providers.dart,features/{dashboard,tower,customers,depots,products,drivers,vehicles}/**,test/*_test.dart}`,
  `packages/fleet_ui/lib/src/mini_map.dart` (+ export, + test).
- **Main session only**: `packages/design_system/**` (frozen this phase
  except auditor-driven fixes), `packages/l10n` regen conflicts,
  `docs/plan/*`, `.claude/agents/*`, git ops.
