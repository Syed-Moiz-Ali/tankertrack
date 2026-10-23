# 00 — Open Questions, Conflicts, Gaps & Assumptions

> Source of truth: `docs/requirements/Diesel_Delivery_Fleet_Management_Functional_Requirements.md` (FRS, 34 sections).
> Cross-checked against: Image 1 "Complete Flow" + Image 2 "End-to-End Flow Chart".
> Rule applied: **FRS wins on conflict**. All conflicts below are resolved in favour of the FRS and the UI is built configurably so the decision can change later.
> Status date: 2026-10-23 (Step 0). This file is living — every new assumption/conflict discovered in later phases is appended here with date + phase.

---

## A. Source Conflicts (FRS wins)

### C1 — Order status sets differ across all 4 sources
- **FRS §6 (data requirements):** Draft, Confirmed, Unassigned, Assigned, Accepted, En route to loading, Loading, Loaded, En route customer, Arrived, Unloading, Completed, Partial, Failed, Cancelled, On hold (16 states, very granular — mixes order + execution states).
- **FRS §17 (status model):** Draft, Confirmed, On Hold, Unassigned, Assigned, In Progress, Completed, Partial, Failed, Cancelled (10 states, cleaner).
- **Image 1 "Status Flow / Order":** Draft, Confirmed, En-route/Loading (partially legible), In Progress, Delivered, Cancelled.
- **Image 2 "Order Status Flow":** Draft, Confirmed, Unassigned, Assigned, Scheduled, In Progress, Delivered, Partial, Failed, Cancelled (introduces **Scheduled** and **Delivered**, neither in FRS §17).
- **Decision (FRS wins, reconciled):** Canonical `SalesOrderStatus` = FRS §17's 10 states, plus `Scheduled` kept as a **display alias** for `Assigned` with a planned date (configurable, default ON), plus `Delivered` treated as synonymous with `Completed` for single-drop orders (kept for image-2 familiarity, mapped to `Completed`). The granular §6 transit states (En route to loading, Loading, …) are **derived display states** computed from the linked Trip/Task statuses, NOT stored on the order. State machine enforces the §17 transitions; derived states are read-only projections.
- **UI impact:** Order list filter chips show canonical 10 + Scheduled toggle; order detail shows "execution phase" timeline derived from trip/tasks. All behind `FeatureFlags.orderScheduledAlias`, `FeatureFlags.orderDeliveredAlias`.

### C2 — Trip/Run status sets differ
- **FRS §17 Trip:** Planned, Assigned, Accepted, Started, At Loading, Loaded, Delivering, Paused, Breakdown, Completed, Closed (11).
- **Image 1 Trip strip:** Planned, Loading, (Leaving/Loaded — low-res), Delivering, Returning, Completed.
- **Decision:** Canonical = FRS §17 (11 states). `Returning` (empty/back-to-depot leg) modelled as a Task type (`Return`), not a trip state. `Closed` = post-reconciliation lock (critical fields frozen, FRS §23). State machine unit-tested.

### C3 — Task status vs Driver status vs Vehicle status conflated in images
- **FRS §17** defines three SEPARATE machines: Task (9: Pending, Accepted, En Route, Arrived, Started, Completed, Skipped, Failed, Cancelled), Vehicle (9: Available, Reserved, Loading, In Transit, At Customer, Break, Breakdown, Maintenance, Out of Service), Driver (9: Offline, Available, Assigned, Driving, Working, Waiting, Break, Breakdown/Incident, Completed Day).
- **Image 1 "Driver/Vehicle" strip** merges them into one list (Available, Assigned, Loading, In Transit, At Customer, Break/Breakdown).
- **Image 2** shows separate Driver Status Flow (Offline, Available, Assigned, Inspection, Driving, Loading, Unloading, Waiting, Break, Breakdown, Completed) and Vehicle Status Flow (Available, Assigned, Loading, Loaded, In Transit, At Customer, Break, Breakdown, Maintenance, Offline) — both differ slightly from FRS §17.
- **Decision:** Three separate typed state machines exactly per FRS §17. Image-2 extras (`Inspection`, `Unloading`, `Loaded`, `Offline` for vehicle) become **derived/composite display badges** (driver activity + vehicle ledger/position), not stored states. Driver §12 event list (15 events incl. Lunch, Inspection, Offline/No GPS, Day Completed) is the **event log vocabulary**; the 9-state machine is the aggregate status. Mapping table lives in `packages/domain` docs and is unit-tested.

### C4 — Driver day step order differs
- **FRS §8.3:** Sign in → Confirm vehicle/shift → Pre-trip inspection → Start Day → Start Journey per task …
- **Image 1 (13 steps):** Login → Start Day (confirm vehicle, odometer, photo) → Pre-Trip Inspection (step 3) → View tasks …
- **Image 2:** Login → Welcome & Today's Tasks → Start Day (Confirm) → Vehicle Inspection → Navigate …
- **Decision:** Canonical flow = FRS §8.3 (inspection BEFORE Start Day tap, so a critical defect can block duty start). UI implements as a guided stepper that visually matches Image 1 (Start Day card shows vehicle confirm, then inspection card) but enforces the FRS gate: `Start Day` button disabled until inspection submitted with no blocking defect (or supervisor override with reason + audit). Configurable via `Config.requireInspectionBeforeStartDay` (default true).

### C5 — Back-office 8 steps vs 12-step onboarding vs 20+ screen inventory
- Image 1 lists 8 back-office steps; Image 2 lists a 12-step one-time onboarding wizard + 12-step back-office flow; FRS §22 lists ~20 back-office screens.
- **Decision:** No conflict — three different views. Onboarding wizard (12 steps, Image 2 §1) becomes its own route `/onboarding` (P8). The 8-step Image-1 strip becomes the dashboard's "process tracker" widget. FRS §22 is the authoritative screen inventory (used in the requirements matrix).

### C6 — Colour legend vs status colours
- Image 1 colour legend: Completed=green, Active/In Progress=blue, Loading=purple/teal, Unloading=teal, Waiting/Break=orange, Critical/Breakdown=red, Offline/Cancelled=grey.
- **Decision:** Adopted as the canonical status-colour mapping (design-system tokens `status*`). Reserved-status-colours-only rule enforced. Exact hex values defined in `04-design-system.md`; both light/dark themes keep hue, adjust luminance for AA contrast.

### C7 — "Accepted" state missing from images
- FRS has order `Accepted` (driver accepted) and trip `Accepted`; images never show an accept step (Image 2 jumps Assigned → Trip Created → Driver Starts).
- **Decision:** Keep `Accepted` in the state machines (FRS wins). For demo simplicity, mock auto-accepts after N seconds OR driver taps Accept in task list — both paths unit-tested. Config `requireDriverAccept` (default true, demo can toggle).

---

## B. Gaps in the FRS (assumptions recorded, UI built configurably)

| # | Gap | Assumption (built into UI-first) | Config flag |
|---|-----|----------------------------------|-------------|
| G1 | No field-level required/optional matrix for POD | POD requires receiver name + (signature OR photo) by default; OTP OFF; meter/ticket optional. All four independently toggleable | `podRequireName/Signature/Photo/Otp` |
| G2 | No tolerance numbers | Default ±2% or ±20 IG (whichever greater) for loading; ±1% or ±10 IG for delivery; supervisor approval above threshold | `toleranceLoadPct/Abs`, `toleranceDeliverPct/Abs` |
| G3 | No GPS interval numbers | Default: 15 s moving / 60 s stationary / 5 s control-room demo; stale threshold 5 min; configurable per FRS §11/§27 | `gpsMovingSecs/StationarySecs/StaleSecs` |
| G4 | No geofence radius | Default 300 m depot, 200 m customer site | `geofenceDepotM/SiteM` |
| G5 | No session/auth specifics beyond "PIN/password/biometric" | Driver: PIN + optional biometric; Back office: email+password + TOTP MFA for admin/supervisor; JWT 15 min + refresh 12 h driver / 8 h office | `auth.*` |
| G6 | No multi-branch/company scoping rules | `branchId` on orders/trips/users; role scope = own branch unless `crossBranch` permission; demo seeds 2 branches | — |
| G7 | No exact inspection 13 items | Taken from FRS §15 examples in order: tyres, lights, brakes, leaks, hoses, valves, tanker integrity, fire extinguisher, spill kit, PPE, documents, reverse alarm, mirrors/camera, emergency equipment (=14; merge mirrors/camera as one → 13 to match Image 1) | `inspectionChecklistV1` (versioned, per vehicle type) |
| G8 | No notification channel matrix | Assignment/reassign/breakdown = push + in-app mandatory; customer ETA SMS/email optional OFF in MVP | `notify.*` |
| G9 | No retention numbers | GPS raw 13 months, POD/photos 7 years, audit immutable 10 years — shown as config defaults, not enforced in UI-first | `retention.*` |
| G10 | Shift/overtime rules undefined | Single `shift` label + start/end timestamps; no overtime math in UI-first; Day Summary shows raw durations | — |
| G11 | Currency/tax for commercial fields | Commercial block (rate/tax/contract) captured as free-form reference fields only; no money math in UI-first | — |
| G12 | Language default | Device locale default; login-screen switcher; persisted; numerals Western default with Arabic-Indic option | `locale.*` |

---

## C. FRS §32 Decisions — recommended defaults

| # | FRS §32 decision | Recommendation + rationale | UI-first implementation |
|---|------------------|----------------------------|-------------------------|
| D1 | Is one Sales Order always one customer delivery? | **YES for MVP** (1 order = 1 site visit). Partial delivery allowed on the single visit (status Partial). Multi-drop = multiple orders grouped in one Trip/Run. Keeps ledger + POD per order clean. | Data model enforces 1:1 order:delivery-task; bulk-create wizard for multi-drop runs |
| D2 | Can one tanker load serve multiple Sales Orders? | **YES** (core to the business; FRS §7/§30 example: load 4,000 IG → deliver 1,500 + balance). Ledger is vehicle-level, allocation is per-task capped by on-board balance. | Dispatch board cumulative-allocation bar; driver "proceed vs reload" advisor |
| D3 | Compartments? | **NO for MVP** (total-tanker balance only), but schema + UI carry `compartments[]` (empty/disabled) behind flag so Phase-2 per-compartment ledger needs no rewrite. | `FeatureFlags.compartments` default OFF; vehicle profile shows "Single-compartment accounting" note |
| D4 | What proves quantity? | **Manual entry + ticket/meter photo** for MVP; meter start/end numeric fields optional; IoT auto-import designed (interface) not built. | Loading/Unloading forms: actual IG mandatory + ticket no. + photo; meter fields collapsible |
| D5 | GPS interval + duty-only tracking? | **Duty-only tracking** (privacy, FRS §11/§26): tracking starts at Start Day, stops at End Day, with explicit in-app "TRACKING ACTIVE" indicator. Intervals per G3. | Driver persistent tracking banner; settings shows policy text (en/ar) |
| D6 | Which ERP? | **None for UI-first** — build `ErpSyncStatus` fields + export CSV/Excel/PDF as the integration seam; OpenAPI reserves `/erp/*` stubs. | Reports have Export buttons (mock download); order shows ERP ref free text |
| D7 | Signature compulsory? OTP? Photo? | **Receiver name + signature OR photo** compulsory; OTP optional OFF (per G1). Rationale: gloves/outdoor — photo fallback keeps flow moving. | POD screen enforces rule with clear error; config toggles visible in Configuration screen |
| D8 | Variance tolerance? | Per G2 defaults. | Quantity widgets show green/amber/red vs tolerance; variance reason sheet mandatory outside tolerance |
| D9 | Auto route optimisation in Phase 1? | **NO — "suggest sequence" only.** Manual drag/drop + "Suggest best order" button (mock heuristic: distance + time-window + priority). Full optimiser is Phase-2 (FRS §29). | Dispatch board has Suggest button with explanation sheet; no auto-reorder without user confirm |
| D10 | Company vs personal devices? | **Assume company Android phones** (kiosk-friendly, permissions granted). UI still handles denied-permission states gracefully for personal-device fallback. | Permission-rationale sheets (location/camera/storage) in en/ar; MDM-remote-disable stub in user admin |

---

## D. Blocking questions for the client (only true blockers)

1. **D3 compartments:** confirm single-balance MVP is acceptable (per-compartment UI stays hidden). If any live tanker has physical compartments that MUST be tracked separately on day one, say so — it changes the ledger + loading forms.
2. **D7 POD rule:** confirm "name + (signature OR photo), OTP off" is acceptable as the launch rule.
3. **Map provider for launch:** FRS says Google Maps or equivalent; UI-first ships `flutter_map`/OSM abstraction. Confirm Google Maps licence exists for production (affects backend ETA/routing line items only, not UI-first screens).
4. **Arabic numerals + Hijri:** confirm Western numerals + Gregorian primary with Hijri optional display is acceptable (vs Arabic-Indic numerals primary).
5. No other blockers — everything else proceeds on the assumptions above, each behind a config flag.

---

## F. Figma-vs-FRS conflicts (R3 — FRS wins on rules, Figma wins on screens/flow/content)

| # | Conflict | Resolution |
|---|---|---|
| C8 | Figma BO-16 shows per-compartment ledger (C1/C2/C3 + seals) vs D3 single-balance MVP | Single-balance MVP stands; `compartments[]` stays in schema behind flag; compartment UI hidden. Revisit post-MVP. |
| C9 | Figma DR-04 has 8 inspection items vs G7 13-item list | Figma's 8 win as client-approved content; checklist is versioned config (`inspectionChecklistV1`), expandable later. |
| C10 | Figma timezone GST Asia/Dubai vs `Asia/Riyadh` default | Default changed to `Asia/Dubai`; map center Dubai 25.2048, 55.2708; configurable. |
| C11 | Figma geography/clients (Dubai, ENOC, Jebel Ali…) vs Riyadh seeds; volumes 28/24/87 vs 50/60/110 | Seeds realigned to Figma (Dubai, 28 drivers, 24 vehicles, 87 orders today, Snapshot-A KPIs). |
| C12 | Figma BO-09 match→validate→confirm→trip-builder flow vs our drag-drop board concept | Board replaced by the Figma flow (FRS conflict rules kept); drag/drop kept as visual intent + keyboard commands. |
| C13 | Figma 24 driver screens vs our DR-01..18 list | 24-screen flow adopted (§2.4); old list retired. |
| C14 | Figma product "Diesel 10ppm" vs 4 mock products | Primary product = Diesel 10ppm (active); others retained inactive unless Figma lists more. |
| C15 | Figma internal collisions (variance 125 IG twice; UAT 38/40 vs 18; Rashid Ali ≠ Rashid Kareem) | Per `12-figma-data-and-scenarios.md` §11 resolutions; designer-confirmed items flagged. |

## E. Assumption log (append-only)

| Date | Phase | Author | Assumption / change |
|------|-------|--------|---------------------|
| 2026-10-23 | Step 0 | Architect | File created; all C/G/D rows above baselined. |
| 2026-10-23 | Step 0 fixes | Architect | Client answers recorded: (1) single-tanker balance MVP confirmed, compartments flag OFF; (2) POD rule = receiver name + (signature OR photo), OTP off, all toggles in Configuration; (3) maps = flutter_map/OSM abstraction for UI-first, Google Maps licence TBC with client (not a UI blocker); (4) numerals = Western + Gregorian primary, Hijri optional display, Arabic-Indic as a setting. |
