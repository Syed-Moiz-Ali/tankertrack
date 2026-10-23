# 01 — Requirements Traceability Matrix

> Every FRS section / rule → app screen(s) / component(s) → build phase → status.
> Legend — Phase: P0–P11 per `05-phase-plan.md`. Status in UI-first: `planned` (all rows start here).
> Screen keys — BO = Back Office web, DR = Driver app, CR = Control Room (`/control-room`).
> FRS = Functional Requirements Specification (34 sections).

## §2 End-to-End Business Flow (12 steps)

| FRS ref | Requirement | Screen / Component | Phase | Status |
|---------|-------------|--------------------|-------|--------|
| §2.1 | Record inquiry: customer, site, product, qty IG, date/time, refs | BO Sales Order Create (`BO-ORD-02`), bulk import wizard | P2 | planned |
| §2.2 | Unique order number + validation | BO Order list/detail; `domain` OrderValidator | P0/P2 | planned |
| §2.3 | Planning: select source, driver, vehicle, sequence; capacity + availability checks | BO Dispatch Board (`BO-DSP-01`), conflict engine | P2 | planned |
| §2.4 | Driver notified (push + task list) | DR Task List (`DR-05`), Messages (`DR-16`); BO Notifications | P3/P6 | planned |
| §2.5 | Start day: inspection + vehicle/odometer/fuel confirm + duty start | DR Vehicle Confirm (`DR-02`), Pre-Trip (`DR-04`), Start Day (`DR-03`) | P3 | planned |
| §2.6 | Travel to loading: GPS trip, ETA, distance visible | DR Navigation (`DR-08`); BO Live Map (`BO-MAP-01`); CR map | P3/P6/P7 | planned |
| §2.7 | Loading record: actual qty, meter/ticket, photos, departure | DR Loading Form (`DR-10`); BO Trip Detail timeline | P3/P6 | planned |
| §2.8 | Travel to customer: live track, ETA, stops, deviations | DR Navigation; BO Live Map; CR; alerts | P3/P6/P7 | planned |
| §2.9 | Arrival + unloading + POD + variance | DR Arrived (`DR-09`), Unloading (`DR-11`), POD (`DR-12`) | P4 | planned |
| §2.10 | Next task / reload logic | DR Next-task advisor card; BO dispatch re-plan | P4/P2 | planned |
| §2.11 | Exceptions: break/lunch/wait/inspection/breakdown/closure/unavailable/partial/reject | DR Break (`DR-13`), Incident (`DR-14`); BO Incident Board | P4/P6 | planned |
| §2.12 | Day closure: summary of distance/times/quantities/tasks | DR Day Summary (`DR-17`), End Day + Post-trip (`DR-18`) | P4 | planned |

## §4 Roles & Permissions (RBAC)

| FRS ref | Requirement | Screen / Component | Phase | Status |
|---------|-------------|--------------------|-------|--------|
| §4 Admin | Users, roles, config, masters, integrations, audit | BO Users/Roles (`BO-ADM-01`), Configuration (`BO-ADM-03`), Audit (`BO-ADM-04`) | P8 | planned |
| §4 Sales | Create/edit orders, view status | BO Orders; role guard `sales` | P2 | planned |
| §4 Dispatcher | Assign/reassign, sequence, live board, exceptions, ETA | BO Dispatch, Control Tower, Incident Board; guard `dispatcher` | P1/P2/P6 | planned |
| §4 Fleet Controller | Availability, inspection, breakdown, maintenance, utilisation | BO Vehicle profile/calendar, Defect Board | P1/P8 | planned |
| §4 Driver | Own tasks + permitted capture only | DR app (all); guard `driver`; no commercial edit | P3/P4 | planned |
| §4 Supervisor | Dashboard, approvals, overrides, KPI, audit | BO Dashboard, Reconciliation approvals, Reports; guard `supervisor` | P1/P8 | planned |
| §4 Finance | Completed quantities, invoice-ready, reconciliation; restricted ops edit | BO Reconciliation (`BO-FIN-01`), Reports; guard `finance` | P8 | planned |
| §4 Customer (opt) | Own order/ETA/POD only | Designed, NOT built (route stub + flag) | P11+ | planned |

## §5 Back-Office Modules (15 rows)

| Module | Screens | Phase |
|--------|---------|-------|
| Dashboard / Control Tower | `BO-DASH-01` Executive Dashboard, `BO-OPS-01` Operations Control Tower | P1 |
| Customer Master | `BO-MST-01` Customers + sites (list/profile, geofence editor) | P1 |
| Delivery Site Master | part of `BO-MST-01` (sites tab, gate timing, tank details) | P1 |
| Product Master | `BO-MST-03` Products | P1 |
| Sales/Delivery Order | `BO-ORD-01..04` list/create/bulk/view | P2 |
| Dispatch Planning Board | `BO-DSP-01` board (drag/drop, conflicts, suggest sequence) | P2 |
| Driver Management | `BO-MST-04` Drivers list/profile/calendar | P1 |
| Vehicle Management | `BO-MST-05` Vehicles list/profile/calendar + on-board balance | P1 |
| Loading Point Master | `BO-MST-02` Depots (hours, slots, products, geofence) | P1 |
| Live Fleet Tracking | `BO-MAP-01` Live Fleet Map + `BO-OPS-01` tower | P6 |
| Trip/Journey Mgmt | `BO-TRP-01` Trip/Run Detail (timeline, replay, closure lock) | P2/P6 |
| Quantity on Vehicle | `BO-FIN-01` Reconciliation + ledger widgets | P8 |
| Inspection & Compliance | `BO-QA-01` Defect Board | P8 |
| Exception & Incident | `BO-INC-01` Incident/Breakdown Board | P6 |
| Notifications | `BO-NOT-01` Notification centre | P6 |
| POD Repository | `BO-POD-01` POD Viewer | P8 |
| Reports & Analytics | `BO-REP-01` Reports (14 FRS §19 reports) | P8 |
| Configuration & Security | `BO-ADM-03` Configuration (flags, tolerances, GPS, reason codes) | P8 |

## §6 Order Data (9 groups) → BO Order Create + Detail

All groups mapped to sections of `BO-ORD-02` (create wizard) and `BO-ORD-04` (view): Identity, Customer, Site, Delivery Requirement (IG, window, priority), Loading Requirement, Assignment, Commercial/Reference, Status (state machine chip + history), Actuals. Phase P2.

## §7 Dispatch Logic (7 rules)

| Rule | Component | Phase |
|------|-----------|-------|
| Mandatory coords/product/qty/date gate | OrderValidator + dispatch guard | P0/P2 |
| Availability + no double-booking w/o override | Availability calendar + override dialog (reason + audit) | P1/P2 |
| Capacity check incl. multi-drop cumulative | Allocation bar + `LedgerRule.cumulativeCheck` | P0/P2 |
| Group orders → Trip/Run + sequence | Trip builder | P2 |
| Reassign with audit | Reassign dialog (reason, old/new, user, time) | P2 |
| Conflict highlighting (7 types) | Conflict engine + badges | P2 |
| Suggest-sequence (optimise-lite) | `SuggestSequence` mock heuristic + explainer | P2 |

## §8 Driver App (§8.1–8.3)

| Widget / step | Screen | Phase |
|---------------|--------|-------|
| Day Summary, Quantity Summary, Current Task, Task List, Duty Controls, Connectivity/GPS | `DR-06` Today Dashboard (composite) | P3 |
| Login (PIN/password/biometric) | `DR-01` Login | P3 |
| Vehicle + shift confirm | `DR-02` | P3 |
| Pre-trip inspection (13 items, Pass/Fail/N/A + photo) | `DR-04` | P3 |
| Start/End Day, journey start, geofence auto-Arrived suggest | `DR-03`, `DR-05/08/09` | P3 |
| Loading / Depart / Navigate / Arrive / Unload / POD / Next-task / Break / Incident / Return / Post-trip / Logout | `DR-08..18` | P3/P4 |

## §9 Loading Transaction (9 fields) → `DR-10` + `BO-TRP-01` timeline. Phase P3.
## §10 Delivery/Unloading (12 fields) → `DR-09/11/12`. Phase P4.
## §11 GPS & Maps (7 bullets) → `TrackingStream`, `BO-MAP-01`, CR, trip replay, alert rules. Phases P0/P6/P7.
## §12 Driver Status/Events (15 rows) → DR duty controls + status chip + event log; BO tower counters. Phases P3/P6.
## §13 Availability Calendars → `BO-MST-04/05` calendars + dispatch availability strip. Phase P1.
## §14 Quantity Ledger (6 txn types + formula) → `domain` ledger math + `BO-FIN-01` + DR balance card. Phases P0/P8.

## §15 Inspection → `DR-04/18` + `BO-QA-01` defect lifecycle (action item, owner, target date, closure evidence, critical-block). Phases P3/P4/P8.
## §16 Breakdown/Incident (7 steps) → `DR-14` + `BO-INC-01` (pause orders, rescue/transfer, ETA recalc, authorised close). Phases P4/P6.
## §17 Status Machines (5 objects) → `domain` state machines + chips + transitions, unit-tested. Phase P0; surfaced P1–P6.

## §18 Notifications (11 triggers) → `BO-NOT-01`, DR Messages, CR ticker, mock push. Phase P6.

## §19 Reports (14) → `BO-REP-01` (tabbed, export Excel/PDF/CSV preview). Phase P8. Mapping: Daily Ops, Driver Activity, Vehicle Utilisation, Fulfilment, Loading, Delivery, Reconciliation, Delay/Waiting, Break/Stop, Breakdown/Incident, Route/GPS History, Inspection Compliance, POD, Exception Audit.

## §20 KPIs (12) → Dashboard + CR KPI strip + Reports. Phases P1/P7/P8.

## §21 Entities (18) → domain entities + mock data + ER diagram (`03-architecture-backend.md`). Phase P0 spec, P1+ UI.

## §22 Screen Inventory → verified: 20 BO screens + 19 DR screens + CR route, all present in matrix above. No screen missing.

## §23 Business Rules (12)

| Rule | Enforcement | Phase |
|------|-------------|-------|
| Unique numbers | ID generator + validator | P0 |
| Audit on 7 action types | Audit service + reason dialogs + `BO-ADM-04` | P0/P8 |
| No delivery w/o qty+POD policy | POD gate per config | P4 |
| No over-capacity/balance w/o override | Ledger guard + override dialog | P0/P4 |
| Tolerance %/IG configurable | Config + variance UI | P0/P8 |
| Block maintenance/breakdown/critical-defect vehicle | Dispatch guard | P2 |
| Block off-duty/suspended/expired driver | Dispatch guard | P2 |
| Lock after trip closure (amendment flow) | Trip Closed state + Request Amendment sheet | P6 |
| Server timestamps; device time kept separately | Sync protocol (outbox keeps both) | P5 |
| Offline keeps capture + sync time | Outbox schema | P5 |
| Photo/POD keeps source/time/coords | Attachment model | P4 |
| Manual status change needs reason + audit | Reason-code dialog | P2/P6 |

## §24 Offline (6 bullets) → `offline_sync` package: read-only day plan offline, outbox queue, idempotent retry, GPS buffer + gap flags, background photo upload, sync badges + Sync-now + conflict UI; demo Online/Offline/Flaky panel. Phase P5 (DB + engine foundations in P0).

## §25 Integrations (8) → abstractions now, implementations later: Maps, Push, ERP stubs, Telematics (optional), Meter/IoT (optional), SMS/Email, Storage, SSO (optional). Map/nav/push faces in P0; ERP export preview in P8; rest P11.

## §26 Security (8) → RBAC guards, MFA screen, TLS/at-rest notes, device disable (admin), audit immutability, retention config, duty-tracking privacy banner, backup/health (backend doc). Phases P0/P8/P10.

## §27 NFRs → 100+ orders/day lists virtualised; map without full refresh (stream diff); ≥56 px driver targets; degraded banners; near-real-time sync; full traceability keys; exports; timezone/date + en/ar. Cross-phase acceptance.

## §28 MVP scope → P0–P8 + P10-scaffold cover exactly the MVP list (masters, orders, dispatch, driver day, GPS/map+ETA, reconciliation, notifications, reports, RBAC+audit).
## §29 Phase-2 → explicitly NOT built; seams reserved (flags, stubs, schema placeholders). See `05-phase-plan.md` P11.
## §30 Example Timeline → replayable mock driver day (`06-mock-data-spec.md` scenario S1: 4,000 IG load → 1,500 IG delivery → 2,500 IG balance). Phase P0 data, P3/P4 flows.

## §31 Acceptance (10) → each becomes a phase-exit check in `05-phase-plan.md` + demo-script beat in `07-demo-script.md`.
## §32 Decisions (10) → resolved in `00-open-questions.md` §C; each behind a config flag.
## §33 Architecture → `02-` + `03-architecture-*.md`.
## §34 Scope statement → the 7 demo questions become the CR + dashboard IA (pending? assigned? where? loaded? delivered? remaining? why delayed? full record?).

---

### Coverage check
- FRS functional sections (§2–§27): 100% mapped above. Image-1 8+13 steps + Image-2 12+12+~18+5+5+7 steps/flows: all mapped to the same screens (see `00` §A for reconciliations).
- Zero unmapped FRS requirements known at Step 0. New discoveries → append row + log in `changes.md` per working rules.
