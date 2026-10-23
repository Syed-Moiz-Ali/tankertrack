# changes.md — Contract & Plan Change Log

> Per working rules §5: never change an earlier phase's contract silently. Every change to a frozen doc/contract is logged here with date, reason, and impact.

| Date | Phase | Change | Reason | Impact |
|------|-------|--------|--------|--------|
| 2026-10-23 | Step 0 fixes | `05-phase-plan.md` P1 acceptance: removed stray non-English words ("служебный проход") → "smoke pass" | Client review fix | Docs only |
| 2026-10-23 | Step 0 fixes | `02-architecture-frontend.md` §4 Quantity: replaced ambiguous double-vs-int paragraph with ONE decision — IG stored as integer tenths of a gallon (`int tenthGallons`), exact integer ledger math, 1-decimal display, litres display-only | Client review fix | Domain implementation + ledger tests follow integer-tenths |
| 2026-10-23 | Step 0 fixes | `02-architecture-frontend.md` §7 timezone: clarified — UTC stored, display in configured tz, default `Asia/Riyadh` until client confirms | Client review fix | l10n DateFmt + Configuration screen |
| 2026-10-23 | Step 0 fixes | Added `08-ui-centralization.md` (FULL UI CENTRALIZATION rule); referenced from `02`, `04`, `05`; added per-phase acceptance (0 violations + `/design` 4 variants × 3 surfaces) | New non-negotiable client rule | All phases P0–P9; P0 scope extended (lints + check script + theme-proof test before feature code) |
| 2026-10-23 | Step 0 fixes | `00-open-questions.md` §E: recorded client answers (single-balance MVP, POD rule, OSM abstraction, Western/Gregorian primary) | Client answers to 4 blockers | Flags configured accordingly in P0 AppConfig |
| 2026-10-23 | P0 | Added `AppTokens.contentNarrow` (420, auth cards) — new token, no existing value changed | Login screens need a narrow form width; literals banned | Additive only; goldens regenerated |
| 2026-10-23 | P0 | `AppTheme.build` gained optional `accentOverride` (white-label seam; used by theme-proof test) | Theme-proof test needs palette-level swap | Backward compatible (optional param) |
| 2026-10-23 | P0 | Enforcement scope fixed: Duration/spacing custom_lint + script nets apply to UI layers (`apps/*`, `fleet_ui`) only | Data/core/domain/l10n own legitimate numeric math | Documented in 08-spirit; probe still fires |
| 2026-10-23 | P0 | Removed `flutter: generate: true` from l10n (auto-wipe of `lib/src/gen` on pub get); generation explicit + committed | melos bootstrap wiped gen files, broke app compilation | `melos gen` remains the regen path |
| 2026-10-23 | P1 | `AppRoutes` extracted to `routes.dart` (re-exported from router) so features navigate without import cycle | Detail screens need typed routes | Additive; all call sites use AppRoutes.* |
| 2026-10-23 | P1 | `tool/check_centralization.ps1` matching switched to `-cmatch` (was case-insensitive `-match` flagging sanctioned `context.colors`) | False positives on mandated accessor | Nets agree; auditor verified |
| 2026-10-23 | P1 | Font fallback (`Noto Sans Arabic`) applies in ALL locales, not just Arabic | Arabic glyphs rendered as tofu in EN locale (native names, master data) | Verified in EN screenshots |
| 2026-10-23 | P1 | Status/role/severity/duty labels fully localized (67 keys); per-enum switches (Arabic gender differs across enums) | Auditor observation: raw status strings in UI | `masterStatusLabel` falls back to raw for unknown future values |
| 2026-10-23 | P1b | Accent teal → coral `#FF385C` (CTA), teal kept as secondary; palette neutrals to 09 values; all goldens regenerated | Airbnb reference spec | One-token accent rule preserved |
| 2026-10-23 | P1b | Fonts Inter → Plus Jakarta Sans (EN); fallback now always-on | Reference spec + EN-locale tofu | Verified in screenshots |
| 2026-10-23 | P1b | Freezed for all entities; codegen committed; `melos gen`/`gen:watch` | Prompt §2.1 | Exceptions (QuantityIG/AppError) logged in 02 |
| 2026-10-23 | P1b | NavigationRail shell deleted → TTTopNav; breadcrumbs removed on top-level pages | Reference R1 | Detail pages keep back arrows |
| 2026-10-23 | P1b | Alert titles localized (15 inc/ntf keys) + severity dots; form/dropdown/role labels localized | Reviewer FAIL items | Raw fallback retained for unknown values |
