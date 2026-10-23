# P1b Contracts (frozen; slices implement exactly these APIs)

## 1. Fonts & theme (main session DONE)
- Families: `'Plus Jakarta Sans'` (EN, variable `fonts/PlusJakartaSans-Variable.ttf`
  in back_office_web + driver_app), `'IBM Plex Sans Arabic'` (AR statics),
  fallback `['Noto Sans Arabic']` ALWAYS (both locales).
- Accent coral `#FF385C` (CTA), secondary teal. Page white, ink `#222222`,
  grey `#717171`, hairlines `#DDDDDD/#EBEBEB`, surface `#F7F7F7`.
- New tokens: `radiusField 8`, `radiusLarge 16`, `headerHeight 80`,
  `gridGap 24`, `sectionSpacing 48`, gutters 24/40/80. New `AppShadows`
  extension (`float`, `hover`) + `context.shadows` accessor.
- Type: display 32/40 w800 track-0.5; section 22/28 w600; card 15-16 w600.

## 2. Freezed (slice: domain-data)
- Packages: domain + data (+ fleet_ui `MapPosition`). Deps per package:
  `freezed_annotation`, `json_serializable` (deps) + `build_runner`,
  `freezed` (dev).
- Every entity freezed: Customer, DeliverySite, Depot, Product, DriverInfo,
  VehicleInfo, OrderSummary, AlertItem, DashboardKpis, MapPosition, Session.
  Keep ALL existing field names + `fromJson` seed-key compat via
  `@JsonKey(name: 'customer_id')` etc. Keep custom getters (`name()`,
  `title()`) as methods on the freezed classes. Keep `QuantityIG`
  hand-written + add `QuantityTenthsConverter` (int tenths ⇄ QuantityIG).
- `AppError`: stays hand-written (add ==/hashCode) — documented exception.
- States: keep AsyncValue/providers (no new unions without value).
- `melos.yaml` scripts: `gen` = exec build_runner build
  --delete-conflicting-outputs; `gen:watch` = watch. Policy (also in 02):
  COMMIT `*.freezed.dart` + `*.g.dart`.
- Tests: update existing (construction APIs unchanged by design) + add
  `json_test.dart` round-trips for every model (fromJson→toJson→==, seed
  row decode for each entity).

## 3. Assets (slice: asset-designer)
- `packages/design_system/assets/brand/logo_mark.svg` (fuel-drop+pin mark,
  currentColor-friendly) + `assets/illustrations/{tanker,depot,driver,
  empty_tasks,empty_map,breakdown}.svg` (flat geometric, accent+ink+surface).
- `lib/src/assets.dart` `AppAssets` with full
  `packages/design_system/assets/...` URI strings; `flutter_svg` dep in
  design_system (+fleet_ui/apps as needed); `test/assets_test.dart`.
- `TTLogoMark({super.key, this.size})` in design_system (SvgPicture via
  AppAssets, size defaults to tokens.iconLg; semantic label param).

## 4. Components (slice: ui-components, ALL in design_system except MiniMap)
Signatures (all const, all strings via params, zero styling inside):
- `TTTopNav({tabs: List<TTNavTabData>, selectedIndex, onSelect, center, trailing})`
  + `TTNavTabData({label, icon: AppIcon, badgeCount})`; height
  `tokens.headerHeight`; white + bottom hairline; `elevated` bool for
  scroll shadow (BoxShadow via context.shadows.float when true).
- `TTSearchPill({segments: List<TTSearchSegment(label,value)>, onTapSegment, onSearch, searchLabel, compact})`
  + compact bool (single-line + round accent button).
- `TTCategoryBar({items: List<TTCategoryItem(icon: AppIcon,label)>, selected, onSelect})`
- `TTSegmentedTabs({tabs: List<TTCountTab(label,count)>, selected, onSelect})`
- `TTProfileMenuButton({avatarLabel, sheetTitle, themeMode, onTheme, lightLabel, darkLabel, systemLabel, locale, onLocale, englishLabel, arabicLabel, roleEntries: List<TTMenuRole(value,label)>, currentRole, onRole, demoRoleLabel, signOutLabel, onSignOut, profileLabel})`
  → opens grabber sheet with theme/language/role/sign-out rows.
- `TTIconCircleButton({icon: AppIcon, onPressed, badgeCount, semanticLabel, tooltip})`
  40px circle (spaceXxxl−spaceSm), surface bg + hairline border.
- `TTMediaCard({image, title, subtitle, figure, badge, saved, onSave, onTap})`
  4:3 image r12, overlay badge top-start, pin top-end, 15 w600 title, grey
  lines, bold figure; hover lift via MouseRegion+AnimatedContainer(shadows.hover).
- `TTStatusOverlayBadge({label})` white pill.
- `TTImageGrid({images: List<Widget>, showAllLabel, onShowAll})` 1+4, 8px gaps.
- `TTStickyActionCard({child})` bordered r12 + float shadow.
- `TTStickyBottomBar({number, caption, ctaLabel, onCta})`
- `TTBottomTabBar({tabs: List<TTBottomTab(icon: AppIcon,label)>, index, onTap})`
- `TTGrabberSheet` via `showTTGrabberSheet(context, child)`.
- `TTCarousel({children, itemWidth})` hover arrows, RTL-safe.
- `TTKpiTile({icon: AppIcon, value, caption, trend})` + `TTSparkline({values: List<double>})`
  (painter takes plain colors via ctor).
- `TTStackedBar({segments: List<TTBarSegment(label,value,style: StatusStyle)>})`
  + legend; `TTDonut({segments})` same model.
- `TTSectionHeader({title, actionLabel, onAction})`.
- Every component added to DesignCatalogue (+DesignStrings fields — coordinate
  keys with Main: catalogue uses literal demo strings, lint-exempt) and to
  golden suite (regen at end by main).

## 5. Web rebuild (slice: ui-web) — files owned: back_office_web lib/src/{shell/**,features/**,routes,router,app}.dart + tests
- Shell → TTTopNav tabs Today/Orders/Dispatch/Fleet/Customers/Menu
  (role-filtered; Orders/Dispatch routes DON'T exist yet → tabs navigate to
  dashboard with a toast? NO — tabs for P2 routes are DISABLED with
  "P2" tooltip? NO TODO-feel: Menu popover holds Control Tower/Depots/
  Products/Reports-stub?— only EXISTING routes: dashboard, control-tower,
  customers(+detail), depots(+detail), products, drivers(+detail),
  vehicles(+detail), design, control-room-stub? — do NOT invent routes.
  Tabs: Today→dashboard, Fleet→vehicles, Customers→customers,
  Menu→(Control Tower, Depots, Products, Drivers, Design catalogue).
  Orders/Dispatch tabs OMITTED until P2 (no dead UI).
- Dashboard "Today" per 09 map (greeting via loginSignedInAs? add ARB
  keys through MAIN: dash_greeting_morning/afternoon/evening with {name},
  tower_* reuse, seg_* tab labels with counts, fleet_today, map_show_all,
  kpi_trend_* — main session adds keys BEFORE slices start; slices use exact names).
- Fleet pages (vehicles/drivers lists) → media-card grids + category pills;
  table view dropped (P1b: grid only).
- Details → R2 structure (back arrow, image grid w/ SVG+MiniMap snapshots,
  sticky action card, sections).
- Login → centered modal card + TTLogoMark + globe button + demo-details
  helper (AppFlags-guarded).

## 6. Driver (slice: ui-driver) — files owned: driver_app/**
- Login restyle via shared fleet_ui LoginScreen (fleet_ui owned by MAIN —
  driver slice must NOT edit fleet_ui; request changes via return message).
- Shell: TTBottomTabBar (Today/Tasks/Messages/Profile) + illustrated empty
  states (AppAssets) for Tasks/Messages; Today shows greeting + next-task
  style card from mock? NO — Today shows greeting + demo day-summary card
  (seed-driven, read-only). Profile shows driver card + theme/language rows.

## 7. ARB keys (main session adds BEFORE slices — exact names)
dash_greeting_morning/afternoon/evening ({name}), seg_loading_now,
seg_in_transit, seg_arriving_soon, seg_upcoming, seg_needs_attention,
fleet_today, map_show_all, kpi_trend_up/down, menu_title, menu_control_tower,
menu_depots, menu_products, menu_drivers, menu_design, menu_theme,
menu_language, menu_demo_role, menu_sign_out, menu_profile,
search_order/driver/vehicle/customer, detail_share/save→ use edit/assign:
detail_edit, detail_assign, detail_block, detail_overview, detail_location,
detail_availability, detail_documents, detail_activity, detail_show_all,
detail_photos, login_welcome, login_demo_accounts, login_continue? (reuse
loginSignIn), tab_today/tasks/messages/profile, today_next_up,
err_enum_leak (unused — test-only).
Forms keep existing mst_* keys.

## 8. Enum-leak test (slice ui-web adds)
`test/enum_leak_test.dart`: pumps dashboard+tower+all master lists+details
in en, collects every Text/RichText string, fails on /\b(onHold|inProgress|unassigned|credit_hold|inTransit|atCustomer|onBreak|outOfService|completedDay|enRoute|atLoading|delivering)\b/ (+ role names dispatcher etc. lowercase).
