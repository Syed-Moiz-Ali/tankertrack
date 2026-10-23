# 05 — Phase Plan (UI-first → backend scaffold)

> One phase at a time. End of each phase: `flutter analyze` + tests + RTL goldens green, `docs/plan/progress.md` updated, summary + screenshots + "what's next", then STOP for approval. No TODO screens in a finished phase. Contract changes logged in `docs/plan/changes.md`.
> Centralization rule: every phase exit additionally requires **0 violations from `check_centralization` + custom_lint; all new components appear on `/design` in 4 variants × 3 surface themes** (see `08-ui-centralization.md`).

## P0 — Foundations (est. 2–3 wks)
- **Goal:** monorepo boots; design tokens live; en/ar RTL harness; routing + role guards; 5 state machines + ledger math unit-tested; mock data seeds; tracking simulator (≥40 tankers).
- **Screens:** Login (both apps, language switch), demo role switcher, Connectivity/GPS banners, SyncBadge/StatusChip/QuantityBadge catalogue page (storybook route `/design`).
- **Deliverables:** Melos workspace, `gen-l10n` en/ar, domain package 100% unit-tested, mock JSON seeds (per `06`), `TrackingStream` simulator, golden harness (1 pilot screen × 4 combos).
- **Acceptance:** analyze/test/goldens green; Arabic RTL pilot verified; ledger example (4000−1500=2500) test passes; simulator shows 40 moving markers in storybook map.

## P1 — Back-office shell + Dashboard/Control Tower + masters (2–3 wks)
- **Screens:** App shell (nav, role guard), Login/MFA, Executive Dashboard, Operations Control Tower, Customer/Site master, Loading Point master, Product master, Driver list/profile/calendar, Vehicle list/profile/calendar.
- **Acceptance:** §31-a (create order → assign to available driver/vehicle — smoke pass with seeded data); calendars show commitments; RBAC hides disallowed nav; RTL verified.

## P2 — Orders + Dispatch + Trip creation (3 wks)
- **Screens:** Order list/create/bulk/view, Dispatch Planning Board (drag/drop, conflicts, suggest-sequence), Trip/Run creation + detail (creation half; full timeline in P6).
- **Acceptance:** dispatch guards fire (capacity/overlap/maintenance/expired-docs/missing-inspection); override requires reason + audit entry; bulk import 100 orders <5 s render (virtualised).

## P3 — Driver app A (2–3 wks)
- **Screens:** DR-01 Login, 02 Vehicle Confirm, 03 Start Day, 04 Pre-Trip (13 items), 05 Task List, 06 Today Dashboard, 07 Task Detail, 08 Navigation hand-off, 09 Arrived, 10 Loading Form.
- **Acceptance:** guided flow completable with ≥56 px targets, minimal typing; inspection critical-fail blocks Start Day (override path audited); loading posts ledger + timeline event.

## P4 — Driver app B (2–3 wks)
- **Screens:** DR-11 Unloading, 12 POD (name+sig/photo, OTP optional), next/reload advisor, 13 Break/Lunch/Waiting, 14 Breakdown/Incident, 15 Photo/Doc capture, 16 Messages, 17 Day Summary, 18 End Day/Post-trip.
- **Acceptance:** §31-b/d/f/h (full load→delivery→POD on phone; balances exact; POD present); over-balance delivery blocked w/o override; variance reason enforced.

## P5 — Offline engine (2 wks)
- **Work:** Drift DB + outbox + sync engine + conflict UI + GPS buffer wired into P3/P4 flows; demo Online/Offline/Flaky panel; back-office degraded banner.
- **Acceptance:** airplane-mode day fully executable → reconnect syncs with zero duplicates (idempotency test); conflict sheet shown on server-reject; photo uploads after txn; gap-flagged replay.

## P6 — Live map + Trip timeline + Incidents + Notifications (2–3 wks)
- **Screens:** BO-MAP-01 Live Fleet Map, BO-TRP-01 full detail (timeline/replay/closure lock + amendment request), BO-INC-01 Incident Board, BO-NOT-01 centre, DR Messages wired.
- **Acceptance:** §31-c/g/j (live map + full day reconstruction); alert rules fire (deviation/stale/prolonged-stop); manual status change needs reason + audit.

## P7 — Control Room (1–2 wks) ⭐ client-critical
- **Route `/control-room`:** 60% map (status markers, heading, trails, labels, clustering, alert auto-focus), order queue, active trips + progress, driver/vehicle counters, alerts ticker, KPI strip, takeover style for breakdown/emergency, dark default, auto-rotate, kiosk-friendly, EN/AR mirrored, 1080p→4K.
- **Acceptance:** readable from 3 m on 55" (type sizes per `04`); stale vehicles flagged; alert→map-focus <2 s; RTL mirror verified; perf: 40–100 markers smooth.

## P8 — Money-truth + governance screens (2–3 wks)
- **Screens:** BO-FIN-01 Reconciliation (ledger, variance approvals), BO-POD-01 Viewer, BO-QA-01 Defect Board, BO-REP-01 (14 reports + export previews), BO-ADM (Users/Roles, Configuration incl. all `00` flags, Audit Log), Onboarding 12-step wizard.
- **Acceptance:** §31-e/i/k (reconciliation exact; exceptions auditable; reports reconcile plan vs actual); closed-trip fields locked (amendment flow only).

## P9 — Polish (1–2 wks)
- Motion, empty/error states, a11y pass (AA, 200% type, semantics), perf budgets (100-row lists, 100-marker map), full RTL review (every screen en+ar screenshots), demo rehearsal fixes.

## P10 — Backend scaffold (2 wks, parallelisable after P2)
- **Deliverables:** Gradle modules compile, `/health` via compose (PG/PostGIS, Redis, MinIO), Flyway V1, `openapi.yaml` + generated stubs, ArchUnit boundary test, DTO-key parity check vs Flutter.
- **Acceptance:** per `03` §8. Zero UI rewrites needed (verified by switching `DataConfig.source` to remote-stub and running P3 flow against 501-with-shape responses).

## P11 — Backend implementation + cutover (after client approval; NOT UI-first)
- Real logic, auth, GPS ingest, push, ERP/telematics/meter integrations, migration from mock. Separate plan.

### Effort roll-up (UI-first, 1 senior Flutter + 1 Java/backend + part-time design/QA)
P0–P9 ≈ 19–27 weeks single-threaded; with two engineers in parallel (frontend phases + P10) ≈ **12–16 calendar weeks**. Estimates re-baselined after P0.
