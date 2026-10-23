# R3 Contracts (frozen; slices implement exactly these)

Content source: `docs/plan/figma-content/<ID>.md` (exact Figma copy).
Visual spec: `docs/plan/13-visual-direction.md`. Reference map: `09`.

## 1. Routes (back_office_web router.dart/routes.dart — slice ui-shell owns)
Existing: /login /mfa /design /dashboard /control-tower /customers[/:id]
/depots[/:id] /products /drivers[/:id] /vehicles[/:id] /403 /404.
ADD: `/forgot-password` (BO-02), `/otp` (BO-03, replaces /mfa flow for
everyone — TOTP/MFA concept stays for admin/supervisor/finance, same screen),
`/role-select` (BO-04: role cards → sets session role → dashboard).
Role guards per 11-map §BO roles. Idle timeout: shell 15-min timer →
TTIdleTimeoutDialog (countdown + Stay signed in) → sign out.

## 2. Data (slice domain-data owns packages/data/** + seeds)
- Realign seeds to Figma: Dubai geography (Dubai Depot, Jebel Ali,
  Industrial City/Delta, Investment Park, ENOC terminals, E11, Al Quoz,
  Marina; regs "Dubai A 12345"; emails `.ae`), GST Asia/Dubai default,
  volumes **28 drivers / 24 vehicles / 87 orders today**, Snapshot-A KPIs
  (orders 87, deliveries 74, completed 31, active 28, pending 15, drivers
  22/28, vehicles 19/24, loaded 78,500 IG, delivered 46,250 IG, variance
  125 IG, breakdowns 1, delayed 4; live Loading 3 / In transit 9 /
  At customer 5 / Break 1 / Delayed 4 subset / Breakdown 1).
- Scenarios as first-class seeds (doc 12): A (SO-260145, Tanker 07, Ahmed
  Khan DRV-0028, ABC 3,520 IG telemetry, ETA 10:42, 16.4 km), B (TRIP-260021:
  5,000 → ABC 1,500 → 3,500 → XYZ 2,000 → 1,500 → Delta 1,500 → 0, 126 km),
  C (23 Oct 06:00–17:15, 182 km), I (Rashid Kareem, Tanker 04, pump
  failure), R-27 (4,950 − 4,700 − 200 = 50 unexplained + owner/approval),
  Reporting (16–22 Oct aggregates, separate from live).
- Demo clock: fixed "now" = 23 Oct 2026 10:30 GST + Reset-demo control
  (seed constant DEMO_NOW_UTC).
- Product primary = Diesel 10ppm; inspection checklist = Figma 8 items
  (versioned); keep ledger math exact (B and R-27 reconcile to the digit).
- Keep all existing repository interfaces; extend, don't break callers.

## 3. ARB keys (main session adds BEFORE slices — exact names)
Shell: nav_today/orders/dispatch/live/fleet/more, cmd_search_hint,
cmd_no_results, idle_title/idle_message/idle_stay/idle_signout,
menu_about/about_title/about_photos. Auth: auth_forgot_title/hint/send/
sent, auth_otp_title/hint/verify/resend/invalid, auth_role_title/hint.
Dashboard BO-05: dash_sentence (one-line page answer, {active} {delayed}
placeholders), dash_more_numbers, dash_needs_attention, dash_latest_activity,
dash_view, dash_remaining, dash_eta, dash_distance, dash_telemetry_note.
Lists: list_cards, list_list, common_show_all (exists detail_show_all — reuse),
sheet_open_full. Driver DR-02/03: dr_verify_title/hint, dr_good_morning
({name}), dr_confirm_vehicle, dr_odometer, dr_odometer_error (no-decrease),
dr_location_consent, dr_start_shift, dr_ready_online. Companion states per
screen: <screen>_empty/_loading/_error/_success for every rebuilt screen
(main adds the full list; slices use exact names).
Demo: demo_reset, demo_state_empty/loading/error/success, demo_screen_state.

## 4. Components (slice ui-components; ALL on /design)
TTTopBar (mark + 5-6 items + command search + bell + profile), TTCommandPalette
(filter + keyboard shortcut), TTSideSheet (+ Open-full-page action),
TTSplitView, TTHeroMap (rounded hero + floating Live-ops card + 4-number
TTStatStrip), TTStatusPill, TTListRow (avatar + 2 lines + pill), TTEntityCard
(typographic), TTMatchColumn, TTValidationSheet (animated check rows),
TTAllocationBar, TTStepProgress, TTBottomActionBar, ScreenStateHost
(Empty/Loading/Error/Success + demo switcher), TTIdleTimeoutDialog,
TTAboutDialog (photo credits). DELETE from catalogue+code: search pill,
big-shadow cards, cartoon hero grid usages (keep components available but
unused? NO — delete TTSearchPill/TTImageGrid-with-cartoon usages; keep the
components only if reused, else remove to avoid dead code).

## 5. Screens (slices ui-web + ui-driver; cite 09 reference per screen)
- ui-web: shell (TTTopBar etc.), BO-01/02/03/04, BO-05 (map-led + sentence +
  More numbers), BO-15/16/17/18/26 rebuilds (typographic lists + sheets),
  depots/products simplified, error pages, About dialog, idle dialog,
  ScreenStateHost wiring + demo state switcher (demo panel).
- ui-driver: shell tabs Home/Tasks/Activity/Support, DR-02, DR-03
  (benchmark quality), companion states, offline/sync indicators.
- l10n-rtl: new keys en+ar + parity; Arabic for ALL Figma copy.

## 6. Ownership (disjoint)
- domain-data: packages/data/**, packages/domain/** (if needed), seeds, tests.
- ui-components: packages/design_system/** (components + catalogue + goldens).
- ui-web: apps/back_office_web/** (no design_system, no data).
- ui-driver: apps/driver_app/**.
- l10n-rtl: packages/l10n/** only.
- Main: contracts, ARB keys, docs, integration, reviewer loop, release.
