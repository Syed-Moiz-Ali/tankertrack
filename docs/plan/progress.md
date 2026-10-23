# progress.md — Phase Progress Log

> Updated at the end of every phase with: what was built, verification
> results, screenshots, review checklist, what's next. Then STOP for approval.

## P1b — Airbnb Redesign ✅ DONE (honest account below)

### What P1 got wrong (admitted)
P1 passed every automated gate but looked like a generic Material admin
panel: NavigationRail, overloaded top bar, raw-number cards ("17 · 17 · 16"),
flat KPI boxes, TT-circle logo, bland login. Root cause: docs 04/08
specified TOKENS only — no layout language to copy. The "raw enum names"
complaint was partly stale screenshots (P1 had localized chips; the user
reviewed old shots) but exposed real gaps (alert titles, form dropdowns,
role names were raw). Fixed properly in P1b instead of argued.

### Built
- **Reference system**: `09-airbnb-reference-analysis.md` + 3 reference
  images; reference map (screen → image → components); 04/08 updated.
- **Freezed everywhere**: domain + data + MapPosition + Session; committed
  codegen; `melos gen`/`gen:watch`; JSON round-trip tests (18); policy in 02.
  Exceptions documented: QuantityIG, AppError (manual ==/hashCode).
- **Fonts/tokens**: Plus Jakarta Sans (EN) + IBM Plex Sans Arabic (AR) +
  always-on Noto fallback (kills tofu); coral `#FF385C` CTA + teal
  secondary; white page/ink/grey/hairlines; radii 8/12/16/999; float/hover
  shadows; header 80, gutters 80/40/24, grid gap 24, rhythm 48; display
  32/40 w800 type scale.
- **20 new TT* components** + 7 original SVGs (logo mark, tanker, depot,
  driver, 3 empty states) + TTLogoMark + AppAssets.
- **Web rebuild**: top nav (centered tabs, search pill, globe/bell/profile,
  demo only in profile menu), Today (greeting, count tabs, 4-col carousel,
  KPI tiles+sparklines, stacked bars, status cards, map card, alerts),
  media-card fleet grids, R2 details (hero grid + gallery + sticky card),
  modal login, restyled 403/404, enum-leak test.
- **Driver**: bottom tabs (Today/Tasks/Messages/Profile), R3 profile card +
  icon rows, persisted theme/language, restyled shared login.
- **Screenshots**: 64 PNGs (web 32 + driver 16 + catalogue 12→regen) across
  1440/1024/390 × en/ar × light/dark in docs/plan/screens/p1b/ (+compare/).

### Sub-agents
Main: 09, fonts/tokens, contracts, ARB keys, integration + all review
fixes. asset-designer: 7 SVGs + tests. domain-data(freezed): models +
46 tests. ui-components: 15 files + 7 tests. ui-web: shell/Today/grids/
details/login + enum-leak test. ui-driver: tabs/profile/login + 8 tests.
ui-reviewer: 2 rounds (8 verdicts → conditional PASS; owned 2 misreads).
No qa-tester run (main ran the sweep directly — flot).

### Verification
| Check | Result |
|---|---|
| analyze ×8 | 0 issues |
| custom_lint ×8 | 0 violations |
| check_centralization | 0 violations |
| Tests | **232/232** (48+4+21+46+5+12+32+64) |
| Goldens | 12 catalogue compare-green; 48 docs shots |
| Web builds | both succeed |
| Reviewer | conditional PASS (all blocking defects cleared) |

### Git
- Branch `phase/p1b-airbnb-redesign` merged --no-ff. Tag `p1b-airbnb-redesign`.
- Screenshots in this summary are approved-or-STOP per instructions.

### Next (P2 — needs "continue")
Orders + dispatch board + trip creation on the new component language.

---

## P1 — Back-Office Shell + Dashboard + Masters ✅ DONE

### Built (scope per 05-phase-plan, nothing more)
- **App shell**: NavigationRail (≥1024) / Drawer, TopBar (search, bell,
  sign-out, compact language + full theme switches persisted via AppPrefs,
  localized role chip, demo-only role switcher behind `AppFlags.isDemoBuild`),
  localized breadcrumbs, banner slot, role-guarded ShellRoute, 403/404 pages.
- **Login/MFA**: demo TOTP (any 6-digit in demo builds) for
  admin/supervisor/finance; other roles skip.
- **Dashboard**: requested/loaded/delivered/pending IG KPIs, orders-by-status
  chips with counts, driver/vehicle counters, late orders, alerts, reload
  list, 8-step process tracker (Image-1), live MiniMap (simulator).
- **Control Tower**: live counters, vehicle-status board, alerts, reload.
- **Masters** (list + detail + validated create/edit, bilingual): customers
  (+sites tab, geofence/gate-hours), depots, products, drivers (+licence +
  commitments calendar), vehicles (+balance badge, defect block banner,
  calendar). List pattern: sticky search + pill filters + virtualized rows +
  skeleton/empty/error. Forms persist in-memory over seeds (demo).
- **Data**: MasterDataService + Mock (673 seeds), DashboardKpis math,
  rootBundle asset loading (`packages/data` assets), deterministic simulator.
- **l10n**: 58 → 216 keys en/ar (nav, shell, MFA, dashboard, tower, masters,
  calendars, 60 status + 5 severity + 4 duty + 8 role labels), parity-tested.
- **Shared UI**: TTMonthCalendar, MiniMap, role/status label helpers
  (gender-correct Arabic per enum), font fallback always-on (kills tofu for
  Arabic-in-EN), Inter + IBM Plex Sans Arabic + Noto fallback bundled.
- **Screenshots**: 8 real-font PNGs (login/dashboard × en/ar × light/dark)
  in docs/plan/screens/p1/.

### Sub-agents (per rule B)
- Main session: contracts (`p1-contracts.md`), AppFlags, font fallback,
  TTMonthCalendar, integration (router wiring, breadcrumb/role/status/
  tofu fixes), screenshots, release.
- Slice A (domain-data): entities, MasterDataService, KPI math, 28 tests.
- Slice B (l10n-rtl): 89+ keys en+ar, regen, parity.
- Slice C (ui-shell): shell/nav/MFA/errors/router, 11 shell tests.
- Slice D (ui-ops): dashboard/tower/5 masters/MiniMap/providers, 11 tests.
- centralization-auditor: PASS, 0 violations (+1 observation fixed:
  status labels localized).
- qa-tester: 128/128 green in compare mode (no --update-goldens).
- Fixes after review (main): localized breadcrumbs/roles/statuses/forms,
  always-on fallback, deterministic shots, ps1 `-cmatch` fix.

### Verification (all green)
| Check | Result |
|---|---|
| analyze ×8 | 0 issues |
| custom_lint ×8 | 0 violations |
| check_centralization | 0 violations |
| Tests | **131/131** (24+4+19+28+5+12+4+35) |
| Goldens | 12 catalogue compare-green; 8 docs shots |
| Web build | `√ Built build\web` |
| RBAC | nav filtered per role; deep links → /403; MFA gate |
| RTL | every new screen en+ar (tests + shots) |
| Perf | 110-row lists virtualized; 42-marker MiniMap |

### Git
- Branch `phase/p1-backoffice-shell` merged --no-ff to main.
- Tags: `p0-foundations` (P0), `p1-backoffice-shell` (this).
- Pre-commit hook installed (centralization + per-package analyze).

### Screenshots
- docs/plan/screens/p1/{login,dashboard}_{en,ar}_{light,dark}.png (8)

### Next (P2 — needs "continue")
Sales Orders (list/create/bulk/view) + Dispatch Planning Board (drag/drop,
conflicts, suggest-sequence) + Trip/Run creation per 05-phase-plan.

---

## P0 — Foundations ✅ DONE (2026-10-23)

### Built
- **Monorepo**: `melos.yaml` + 8 members
  (`apps/driver_app`, `apps/back_office_web`,
  `packages/design_system|core|domain|data|l10n|fleet_ui`).
- **design_system**: AppPalette (single accent teal), light/dark
  ColorSchemes, StatusColors extension (image-legend hues), AppTokens
  extension (8-pt grid, radii, motion, touch targets, breakpoints,
  `contentNarrow`), full ThemeData (all 20 component themes),
  driver/web/controlRoom builders, context helpers, AppIcons (RTL twin
  map), 30+ TT* components, DesignCatalogue storybook.
- **Enforcement BEFORE feature code**: `tankertrack_lints` (5 custom_lint
  rules, all ERROR) + `tool/check_centralization.{sh,ps1}` (14 patterns).
  Negative control `tool/lint_probe` proves all 5 rules fire (11 hits).
  Scope lesson learned: Duration/spacing rules apply to UI layers only
  (08 §4) — data/core/domain/l10n own legitimate numeric math; script nets
  scan `apps/*` + `fleet_ui` only. Analyzer-7 lesson: `constructorName.type`
  stringifies with the named ctor (`EdgeInsets.all`) — rules split on '.'.
- **l10n**: 58 keys en/ar (ARB parity test fails CI on missing key),
  NumberFmt (Western/Arabic-Indic), QuantityFmt (integer-tenths IG,
  display-only litres), DateFmt (UTC stored, +03:00 Asia/Riyadh display,
  optional Hijri), `context.l10n`.
- **core**: Result, AppError, AppConfig (all 00 §G/D defaults),
  RBAC matrix (FRS §4), AppLog ring.
- **domain**: QuantityIG (integer tenths — exact ledger math), 5 typed
  state machines (Order 10, Trip 11, Task 9, Vehicle 9, Driver 9) with
  every edge unit-tested, DerivedStatus aliases (Scheduled/Delivered/§6
  phases), LedgerRule (S1 4000−1500=2500 exact; over-balance block;
  3-tier variance), OrderValidator, PodPolicy (name + sig/photo, OTP off),
  bilingual ReasonCodes.
- **data**: 673 seed records (24/48/5/4/60/50/110/34/40/12/60/200/30 —
  exact 06 volumes incl. order-status spread), MockAuthRepository
  (8 demo users), MockTrackingSimulator (42 deterministic tankers,
  scripted delay/breakdown, S5 inject).
- **fleet_ui**: domain→StatusStyle maps (exhaustive test), shared
  LoginScreen + SignedInScreen (TT-only, zero strings inside).
- **Apps**: driver (driver surface, PIN login, driver-role gate) +
  back-office (web surface, email login, rejects driver creds), both with
  /login + /design + /home, role-guarded go_router, persisted
  theme/locale, crash-safe zoned startup. `flutter build web` green both.

### Verification (all green)
| Check | Result |
|---|---|
| `flutter analyze --no-fatal-infos` × 8 | 0 issues |
| `tool/run_custom_lint` × 7 pkgs | 0 violations |
| `tool/check_centralization` | 0 violations |
| Tests | **74/74 pass** (design_system 23 incl. 12 goldens + theme-proof 3; core 4; domain 19; data 9; l10n 5; fleet_ui 5; driver 4; office 5) |
| Goldens | 12/12 catalogue variants pass in compare mode |
| Theme proof | accent swap → button + chip colors change; surface swap → 56/48px heights; documented in `theme_proof_test.dart` |
| Web builds | both `√ Built build\web` |

### Review checklist
- [x] 0 violations from check_centralization + custom_lint
- [x] All new components on /design (catalogue covers 30+ TT* incl. switches, stepper, dropdown, dialogs' siblings)
- [x] RTL verified (ar-RTL goldens + login AR tests both apps)
- [x] No TODO screens (SignedIn home is a complete P0 landing; P1/P3 replace bodies)

### Screenshots
- `packages/design_system/test/goldens/goldens/catalogue_{driver,web,controlRoom}_{light,dark}_{ltr,rtl}.png` (12)
- Live demo: `flutter run -d chrome` in either app → `/login`, `/design`

### Known deferrals (not defects)
- Font files (Inter / IBM Plex Sans Arabic) bundle in P1 app shells; theme
  family names fall back cleanly; test goldens render with Ahem (layout/
  color proof — P9 does device glyph review).
- Melos runs via `dart run melos` (local install, bootstrapped, 9 members);
  the global binary's stdin prompt was a sandbox quirk only.
- AnimatedTheme lesson: widget tests must `pumpAndSettle()` after theme
  changes (documented in theme_proof comments).
- l10n lesson: `flutter: generate: true` auto-wipes `lib/src/gen` on
  `pub get` — removed; generation is explicit (`flutter gen-l10n`,
  committed files).

### Next (P1 — needs "continue")
Back-office shell + Dashboard/Control Tower + masters (customers, sites,
products, loading points, drivers, vehicles, calendars) per 05-phase-plan.
