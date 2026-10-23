# progress.md — Phase Progress Log

> Updated at the end of every phase with: what was built, verification
> results, screenshots, review checklist, what's next. Then STOP for approval.

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
