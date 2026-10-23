# 06 — Mock Data Spec (volumes, realism, simulator, scenarios)

> Seeds live in `packages/data/lib/src/mock/seed/*.json` (checked in) + `MockTrackingSimulator` for motion. All quantities reconcile EXACTLY (ledger-tested). Names bilingual (en/ar). Coordinates cluster around one metro area (Riyadh defaults: 24.7136, 46.6753 ±0.25°) so maps/routes look real; rural sites out to ±0.8°.

## 1. Volumes (today + history)

| Entity | Volume | Notes |
|--------|--------|-------|
| Customers | 24 (18 active, 4 on-hold/credit-hold, 2 inactive) | en/ar names (e.g. "Al Noor Contracting / النور للمقاولات"), contacts, credit flags |
| Delivery sites | 48 (1–4 per customer) | coords, geofence 200 m, gate hours, tank notes; 3 with restricted windows (school/hospital quiet hours) |
| Loading points / depots | 5 (Depot A–C + 2 supplier terminals) | coords, 300 m geofence, hours, queue slots, products |
| Products | 4 (Diesel Standard, Diesel Premium, Winter Grade, Off-road) | code, unit IG, active flag |
| Vehicles | 60 | capacities 2,000–6,000 IG; statuses spread: 38 available/reserved/in-transit/loading/at-customer, 6 break, 5 maintenance, 4 breakdown, 7 out-of-service/offline; 6 with doc expiry ≤30 d; 3 with critical open defects (dispatch-blocked); `compartments: []` (flag-off) |
| Drivers | 50 | 34 on-duty spread across statuses, 8 off-duty/leave, 3 suspended, 5 with licence expiry ≤30 d; Arabic + English names, bilingual |
| Orders (today) | 110 | all 10 canonical statuses represented (Draft 6, Confirmed 8, On Hold 4, Unassigned 18, Assigned 16, In Progress 30, Completed 16, Partial 4, Failed 3, Cancelled 5 ≈ 110); requested 500–4,000 IG; priorities; time windows; 12% with variance; PO/contract refs |
| Orders (history, −30 d) | ~1,500 summary rows | for reports/KPIs (aggregates only, generated deterministically, seed 42) |
| Trips/Runs (today) | 34 | multi-drop 2–5 stops; all 11 trip states represented; 3 with breakdown/paused; 4 closed (locked) |
| Tasks | ~260 | load/deliver/return mix; full 9-state spread |
| Ledger entries | per vehicle-day chain | opening + loads − deliveries − returns ± adjustments = closing; zero rounding drift (1-decimal IG) |
| Inspections | 40 | 34 pass, 4 minor defects (open action items), 2 critical (vehicle blocked) |
| Incidents | 12 open/history | breakdown/accident/spill/customer-unavailable/meter-issue/traffic; 2 critical active (for CR takeover demo) |
| Notifications | 60 | assignment/late/ETA-risk/geofence/variance/breakdown/deviation/expiry/stale |
| Audit entries | 200+ | create/edit/assign/reassign/cancel/override/adjust with reason codes + bilingual labels |
| Attachments/POD | 40 | placeholder SVGs (signature squiggle, ticket stub) — real capture in P4 replaces artwork |

## 2. Hero scenario S1 — replayable driver day (FRS §30, exact numbers)

Driver **Khalid Al-Otaibi / خالد العتيبي**, Vehicle **T-214 (4,500 IG)**, date today:
`06:50 login → 07:00 inspection pass → 07:05 Start Day (opening balance 0 IG) → 07:35 arrive Depot A → 07:45–08:05 LOAD 4,000 IG (ticket DA-88213, meter 102400→106400, photo) → on-board 4,000 → 08:50 arrive Customer 1 (Al Noor Site 2) → 08:50–09:10 UNLOAD 1,500 IG + POD (receiver + signature + photo) → on-board 2,500 → 09:15–10:00 Customer 2 UNLOAD 2,000 IG → on-board 500 → 10:05–10:20 break → reload Depot B 3,000 IG → … → 17:30 End Day (closing 250 IG, distance 214 km)`. Every step has timestamps/GPS/attachments; balance column visible in UI proves 4,000−1,500=2,500 live.

## 3. Other scripted scenarios

- **S2 Over-balance block:** order needs 3,000 IG, on-board 2,500 → Complete disabled → supervisor override dialog (reason + audit) → completes.
- **S3 Variance:** planned 2,000 / actual 1,940 (−3%, outside ±2%) → reason sheet mandatory → supervisor approval task.
- **S4 Offline day:** Flaky-mode toggle; 6 events queue (arrive/load/depart/arrive/unload/POD) → Sync-now → zero duplicates, gap-flagged GPS segment.
- **S5 Breakdown takeover:** T-307 breakdown on route → CR alert takeover + map focus; dispatcher pause + rescue trip; customer ETAs recalc.
- **S6 Conflict:** task reassigned while driver offline → conflict sheet on sync (theirs/yours).
- **S7 Closed-trip lock:** closed trip shows lock banner + Request Amendment (no silent edit).

## 4. Simulator behaviour (`MockTrackingSimulator`)

- ≥40 tankers on waypoint polylines (commute corridors + depot↔site spokes), speeds 30–80 km/h with dwell at geofences (loading 20 min, unloading 15 min + noise).
- Tick 2 s (demo) → positions + heading + trail (200 pts) + on-board IG + ETA countdown; scripted injects: 1 delay/5 min, 1 breakdown/15 min, 1 variance/day; jitter ±8% so numbers feel alive but ledger stays consistent (simulator never mutates ledger — only `driverops` events do).
- Deterministic seed (42) + "Reset demo" button; scenario buttons force S5/S6 on demand.
