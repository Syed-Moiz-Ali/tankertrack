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
