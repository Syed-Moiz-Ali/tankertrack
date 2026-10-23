# 07 — Demo Script (10-minute client walkthrough)

> One story, 7 beats (answers FRS §34's 7 questions). Run order below. Reset: storybook `/design` → "Reset demo (seed 42)". Language: run once EN, flip to AR at beat 6 (RTL mirror is a selling point). Timings assume pre-seeded S1 + simulator live.

| # | Time | Beat (question it answers) | Click path | What the client SEES |
|---|------|----------------------------|------------|----------------------|
| 1 | 0:00–1:30 | **What orders are pending?** | BO → Dashboard → Orders (filter Unassigned) → Create one order (500 IG, pick site on map) → Bulk row appears | KPI cards (requested vs loaded vs delivered IG), status pills, order count 110→111; Arabic customer names render correctly |
| 2 | 1:30–3:30 | **Who + which tanker + from where?** | Dispatch Board → drag new order onto Run R-09 (T-214/Khalid) → conflict engine flashes over-capacity on another run (S2) → Suggest-sequence → Dispatch | Allocation bar, availability strip, override-with-reason dialog + audit toast; driver push notification badge |
| 3 | 3:30–5:30 | **Load → deliver, live?** | Driver app (mirror phone): Start Day → inspection (13 items) → navigate → Arrive → Load 4,000 IG → depart → map shows T-214 moving, on-board 4,000 → Arrive C1 → Unload 1,500 + POD signature → balance 2,500 | Ledger card ticks 4,000→2,500 live (§30 numbers); BO trip timeline appends events with GPS+timestamps |
| 4 | 5:30–6:30 | **Offline? No problem.** | Demo panel → Offline → driver completes next delivery + break (queued, Pending badges, banner red) → Flaky → Sync-now → all ACK, zero duplicates | Outbox sheet (UUIDs, captured vs synced time), gap-flagged trail segment, last-sync "just now" |
| 5 | 6:30–8:00 | **Exceptions handled?** | Inject Breakdown (T-307) → Incident Board alert → pause order → create rescue trip → ETA recalc toast | Driver incident form (photo), BO map alert pin, audit entries for pause/reassign |
| 6 | 8:00–9:00 | **Control room wow** | Open `/control-room` (F11) → flip EN→AR → trigger critical alert | 60% map, 40 tankers, KPI strip, ticker, dark theme, RTL mirror, breakdown TAKEOVER (flashing border + map focus) |
| 7 | 9:00–10:00 | **Verifiable record?** | Trip Detail → timeline + replay (S1 day) → Reconciliation (Opening 0 + 4,000 − 1,500 − … = Closing, variance −3% flagged S3) → Reports → export preview → Audit Log | Closed-trip lock + amendment request; POD viewer with signature/photo; Excel/PDF buttons; §34's "complete verifiable record" on one screen |

**Fallbacks (if live demo gods frown):** pre-recorded screenshots per beat in `docs/plan/demo-shots/`; S-scenario buttons force each inject deterministically; second browser profile holds the AR mirror ready.
