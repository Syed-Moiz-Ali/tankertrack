# P1b Airbnb-reference comparison review

Branch: `phase/p1b-airbnb-redesign`. References are PRIMARY
(`docs/reference/airbnb/*.png`); spec in `docs/plan/09-airbnb-reference-analysis.md`.
Tankers-vs-homes CONTENT substitution = acceptable. LAYOUT deviation = must fix.

Composites: SKIPPED — no trivially usable image tool in this environment
(`magick`/MSPaint absent; `convert.exe` is the Windows filesystem tool, not
ImageMagick; a `System.Drawing` nested-shell one-liner failed on quoting).
No composites in `compare/` — the written deviation list below is the deliverable.

---

## 1. Today (desktop) ↔ R1 home — FAIL

- Ours: `docs/plan/screens/p1b/today_en_light_1440.png`
- Ref: `docs/reference/airbnb/home.png`

1. Nav tabs LEFT-aligned (Today/Vehicles/Customers/Menu, icon left of label)
   vs ref CENTERED icon-over-label category tabs with active black underline.
   Ours underline exists but position/pattern differs — LAYOUT.
2. No "Become a host" 14px semibold equivalent; right cluster is
   globe + bell(15) + SA avatar + chevron pill vs avatar + hamburger circle
   button — extra bell/globe, missing circle-button pattern — LAYOUT (minor).
3. Search pill sits BELOW header as filter bar (Driver/Vehicle/Customer|All)
   vs ref pill centered under tabs, max-width ~850, three 12px-w800-over-14px
   segments + 48px circular coral button. Ours button circular coral ✓ but
   bar is wider and detached — LAYOUT.
4. Greeting "Good afternoon, Sara Al-Qahtani" + "Next up" replaces ref
   22px-w600 section header + row-end circular arrow — CONTENT (acceptable)
   but the status strip below (Loading now/In transit/…) is an EXTRA element
   with no ref equivalent — CONTENT (acceptable, flagged only).
5. Cards: ~2 huge tanker illustrations per row vs ref 7/row, gap 24, image
   rounded-12 ~4:3. Ours gaps are far larger, image area unrounded — LAYOUT.
6. Missing card language: no white top-start pill ("Guest favourite" equiv),
   no top-end heart, title is small + grey spec lines vs 15px w500-600 dark
   title + 14px grey secondary — LAYOUT (title weight/size).
7. "Assigned" pills float ABOVE cards detached vs pill-on-image — LAYOUT.
8. Carousel arrows vertically centered over cards vs ref arrows at the
   section-header row end — LAYOUT.
9. "Your fleet today" KPI tiles (icon + big number + sparkline) — CONTENT
   substitution for dashboard, acceptable; tile radius/border look close to
   ref card language. OK.
10. No tofu / raw strings / icon breakage observed on this screen.

## 2. Vehicle detail ↔ R2 list_detail — FAIL

- Ours: `docs/plan/screens/p1b/vehicle_en_light.png`
  (also `vehicle_en_dark.png`, `vehicle_ar_light.png` spot-checked — same layout)
- Ref: `docs/reference/airbnb/list_detail.png`

1. Back arrow + "RYD-5091" + red "Edit / Assign" text actions ≈ ref H1 26px
   w600 + Share/Save — GOOD mapping, CONTENT substitution acceptable.
2. Hero echoes 1-large + 4-small but 3 of 4 cells are EMPTY grey placeholders
   with camera icons (one has a barrels glyph) vs ref full-bleed photos —
   LAYOUT (placeholder, must fill or use image-grid pattern).
3. Cell gaps visibly larger than ref 8px; no outer rounded-12 container —
   LAYOUT.
4. Missing "Show all photos" white pill bottom-end of last cell — LAYOUT.
5. Body is SINGLE column (Overview panel full width) vs ref two-column with
   RIGHT sticky booking card — LAYOUT. A floating card top-right duplicates
   the Overview content ("In transit" pill + "Documents valid" in both) —
   EXTRA/duplication, must fix.
6. Sticky card has coral "Edit" CTA ✓ (equiv. of ref coral CTA) but price line
   "200.0 IG / Capacity 5,200.0 IG" is right-aligned small vs ref bold price
   line — LAYOUT (minor).
7. "Overview" / "Availability" headers read ~18px vs ref H2 22px w600 —
   LAYOUT (type size).
8. Calendar boxed dates ≈ ref boxed date fields — GOOD.
9. Dark variant (`vehicle_en_dark.png`): same deviations; placeholder cells
   dark navy, no new faults.

## 3. Driver home (mobile 390) ↔ R3 profile + mobile patterns — FAIL (vs profile language)

- Ours: `docs/plan/screens/p1b/driver_home_en_light_390.png`
- Ref: `docs/reference/airbnb/profile.png`

1. No avatar card (avatar + name + stat column, radius ~24, float shadow) —
   screen shows only greeting + tanker icon + "Next up / Items you create…"
   empty state — LAYOUT/MISSING (mapping gap: driver home ≠ profile screen).
2. No icon + 15px detail rows, no grey "Show all" pill, no "Edit" pill —
   MISSING vs R3 language.
3. Bottom tab bar (Today/Tasks/Messages/Profile, Today = pink pill active) is
   the prompt-§3.4 mobile pattern (no mobile ref image) — acceptable as shell;
   empty state only, nothing else to compare.
4. Greeting wraps to two lines ("Good afternoon, Khalid Al- / Otaibi") —
   acceptable responsive wrap, minor.
5. No tofu / raw strings on this screen.

## 4. Login (web) ↔ modal language — PASS (with notes)

- Ours: `docs/plan/screens/p1b/login_en_light_1440.png`
- Ref language: R2 modal + prompt §3.5 (centered card r16 + shadow, TTLogoMark,
  globe button, demo-details helper)

1. Centered card radius-16 + soft shadow ✓, logo pin ✓, "Welcome to
   TankerTrack / Diesel Delivery & Fleet Tracking" ✓.
2. "Sign in", Company email, Password + eye, full-width coral Sign In ✓.
3. Demo-accounts helper present as separate card below ("Demo:
   dispatch@demo.sa / demo1234") ✓ (placement below vs inside — acceptable).
4. Language switch is a "🌐 العربية" text link BELOW the helper vs a globe
   button — minor LAYOUT note, acceptable.
5. No tofu / raw strings.

## 5. Driver login AR dark 390 — PASS

- Ours: `docs/plan/screens/p1b/driver_login_ar_dark_390.png`

1. RTL mirroring correct: title/inputs right-aligned, eye icon on LEFT ✓,
   CTA full-width, demo card right-aligned, "English 🌐" toggle ✓.
2. No tofu / missing glyphs observed; Arabic strings render fully.
3. Dark card/border readable; coral CTA preserved. No faults.

## 6. Today AR dark 1440 (RTL + dark) — PASS (with minor notes)

- Ours: `docs/plan/screens/p1b/today_ar_dark_1440.png` (vs R1 for mirroring)

1. Header mirrored: nav tabs right, icon cluster left ✓. Search pill mirrored
   (coral button LEFT) ✓. Greeting + "التالي" right-aligned ✓.
2. Card order S-39 → S-37 right-to-left ✓; carousel arrows mirrored ✓.
3. Arabic labels render, no tofu observed.
4. MINOR: S-39 time reads clipped ("08:00-09:00" first glyph cut) — truncation,
   must fix.
5. Dark wall uses dark navy surfaces, tanker illustration readable — per
   §3.5b same-tokens allowance. OK.

## 7. Today EN light 390 (responsive) — FAIL

- Ours: `docs/plan/screens/p1b/today_en_light_390.png` (vs R1 responsive 2→6)

1. Status strip OVERFLOWS: tab labels truncated with ellipsis ("Lo…", "In
   tr…", "Arr…") and a clipped "Assi…" pill at the edge — LAYOUT, must fix
   (scrollable tabs or compact pattern).
2. Second card truncated mid-viewport ("S-38 / DSL-S… / 3,300.(…") — carousel
   clipping without clear affordance — LAYOUT.
3. KPI numbers wrap badly ("266,000. / 0 IG") — unit split across lines —
   LAYOUT (type/nowrap).
4. Carousel arrows overlap card edges at 390px — LAYOUT (minor).
5. Header compresses acceptably (logo + Today + icons). OK.

## 8. Control Tower ↔ §3.5b dark-wall tokens — FAIL

- Ours: `docs/plan/screens/p1b/tower_en_light.png` (tower_* variants same)

1. RAW UNLOCALIZED STRINGS: rows read "breakdown", "accident", "spill",
   "customer_unavailable", "meter_issue", "late_eta", "geofence" — lowercase
   snake_case — must fix (Title Case / localized labels).
2. Rows are bare bordered rectangles with no icon, timestamp, or action vs
   ref card/pill language — LAYOUT.
3. Status pills (Live 42 / Active 16 / …; In transit 20 / …) follow pill
   language ✓ — GOOD.
4. Excessive vertical whitespace between rows vs ref 48px rhythm — LAYOUT
   (minor).

---

## Verdicts

| Screen | Verdict |
|---|---|
| Today desktop EN light ↔ R1 home | FAIL |
| Vehicle detail ↔ R2 list_detail | FAIL |
| Driver home 390 ↔ R3 profile | FAIL (mapping gap + missing profile language) |
| Login web EN ↔ modal language | PASS |
| Driver login AR dark 390 | PASS |
| Today AR dark 1440 (RTL/dark) | PASS (1 minor truncation) |
| Today EN light 390 (responsive) | FAIL |
| Control Tower | FAIL (raw strings) |

## 5 most important deviations overall

1. Today grid density + carousel pattern (§1.5, §1.8): 2 oversized cards with
   mid-card arrows vs 7/row, gap 24, row-end arrows.
2. Vehicle hero placeholders + missing "Show all photos" + single-column body
   with duplicated sticky card (§2.2–§2.5).
3. Mobile-390 overflow: status strip ellipsis + card clipping + KPI number wrap
   (§7.1–§7.3).
4. Tower raw snake_case strings (`customer_unavailable`, `meter_issue`, …) —
   unlocalized (§8.1).
5. Driver home has none of the R3 profile language (avatar card, icon rows,
   Show-all pill) — mapping gap (§3.1–§3.2).

---

## Re-verification (date 2026-10-23)

Re-shot sources in `docs/plan/screens/p1b/` vs refs in `docs/reference/airbnb/`
(`home.png` = R1, `list_detail.png` = R2, `profile.png` = R3) + spec
`docs/plan/09-airbnb-reference-analysis.md`. Per-point verdicts below.

### 1. Today density/carousel (`today_en_light_1440.png` vs `home.png`) — STILL-OPEN
- Card size/count: ~2.5 huge tanker illustrations per viewport vs ref 7/row,
  gap 24, image rounded-12 ~4:3. No change — STILL-OPEN (§1.5).
- Overlay pills on image: "Assigned" pills still float ABOVE cards detached,
  no white top-start pill on image, no top-end heart — STILL-OPEN (§1.6–§1.7).
- Title weight: `S-37 / DSL-STD · 06:00-07:00 / 1,100.0 IG` still small title +
  grey spec lines vs ref 15px w500-600 dark title + 14px grey secondary —
  STILL-OPEN (§1.6).
- Carousel arrows still vertically centered over cards vs ref row-end circular
  arrow at section header — STILL-OPEN (§1.8).
- Verdict: Today desktop stays FAIL (no movement on this point).

### 2. Vehicle hero + body (`vehicle_en_light.png` vs `list_detail.png`) — PARTIAL (still FAIL)
- 5 filled cells: 1-large + 4-small grid present, but all 5 cells still grey
  placeholders with small centered glyphs (tanker / barrels / map / driver /
  truck-warning) vs ref full-bleed photos — STILL-OPEN (§2.2).
- Gaps: now tight (~8px white dividers) vs prior wide gaps — FIXED (§2.3 part).
- Outer rounding: hero container now shows rounded outer corners — FIXED
  (§2.3 part).
- Show-all pill: white "Show all photos" pill now bottom-end of last cell —
  FIXED (§2.4).
- Two-column + sticky card: hero row is now two-column (hero left + sticky
  card top-right) with coral "Edit" CTA ✓; BUT ref pattern is hero full-width
  then two-column body (content left + sticky right). Ours Overview/Availability
  below hero remain single-column full-width-left — STILL-OPEN (§2.5 part).
- No duplication: sticky ("In transit" + "Documents valid" + Edit) vs Overview
  (`RYD-5091 / T-214 / Capacity 5,200.0 IG`) no longer duplicate each other —
  FIXED (§2.5 part).
- Section type sizes: "Overview" / "Availability" still read ~16-18px vs ref
  H2 22px w600 — STILL-OPEN (§2.7).
- Price line still right-aligned small "200.0 IG / Capacity 5,200.0 IG" vs ref
  bold price line — STILL-OPEN minor (§2.6).
- Verdict: Vehicle stays FAIL (3 sub-fixes: gaps, outer rounding, show-all
  pill + de-duplication; hero-fill + two-column body + type sizes still open).

### 3. Mobile 390 (`today_en_light_390.png`) — PARTIAL (still FAIL)
- Segmented tabs scroll (no ellipsis truncation): strip still overflows
  viewport — reads "Loading now 46 / In transit 0 / Arrivir" hard-clipped at
  right edge with no scroll affordance. Ellipsis "…" gone but clipping
  remains — STILL-OPEN (§7.1).
- Card clipping: second card still truncated mid-viewport
  (`S-38 / DSL-STD · 07:0(…` clipped, arrow overlaps card edge) without clear
  carousel affordance — STILL-OPEN (§7.2 + §7.4).
- KPI nowrap: numbers now single-line ("266,000.0 IG", "122,800.0 IG") with
  sparkline, no "266,000. / 0 IG" wrap — FIXED (§7.3).
- Verdict: Today 390 stays FAIL (KPI fixed; tabs + clipping still open).

### 4. Tower labels (`tower_en_light.png`) — PARTIAL (still FAIL, downgraded)
- No raw snake_case anywhere: rows now read "Breakdown / Accident / Spill /
  Customer unavailable / Meter issue / Late ETA risk / Geofence event" Title
  Case — FIXED (§8.1). Pills also clean ("Live · 42", "In transit · 20", …).
- Alert rows dot+title+severity: each row now title-left + severity pill-right
  with dot ("● Critical" red / "● High" blue / "● Info") — pill-dot part FIXED.
  BUT rows still bare bordered rectangles: no leading dot/icon before title,
  no timestamp or action, tall whitespace vs ref card/pill language —
  STILL-OPEN (§8.2 + §8.4).
- Verdict: Tower stays FAIL (raw-strings blocker cleared; row-pattern
  enrichment still open).

### 5. Driver home/profile (`driver_home_en_light_390.png`) — STILL-OPEN
- Avatar card (avatar + name + stat column, radius ~24, float shadow): absent —
  screen still greeting + tanker icon + "Next up / Items you create will appear
  in this list." empty state only — STILL-OPEN (§3.1).
- Icon rows (icon + 15px detail rows), grey "Show all" pill, "Edit" pill:
  absent — STILL-OPEN (§3.2).
- Bottom tab bar shell (Today/Tasks/Messages/Profile) unchanged, acceptable
  per §3.4 — no change.
- Verdict: Driver home stays FAIL (mapping gap unchanged).

### 6. TopNav centering (1440 shots vs `home.png` header) — FIXED (partial scope)
- `today_en_light_1440.png` now shows tabs CENTERED with icon-over-label
  (Today/Vehicles/Customers/Menu, active black underline) vs prior LEFT-aligned
  icon-left-of-label — FIXED (§1.1).
- Search pill still sits below header as Driver/Vehicle/Customer filter bar vs
  ref centered-under-tabs max-width ~850 three-segment pill — out of scope for
  this point, still open per §1.3.
- Right cluster still globe + bell(15) + SA avatar + chevron pill vs ref avatar
  + hamburger circle + "Become a host" — out of scope, still open minor per
  §1.2.
- Verdict: centering sub-point FIXED; Today overall still FAIL per point 1.

### 7. AR dark today + vehicle AR shots (mirroring + no tofu) — FIXED
- `today_ar_dark_1440.png`: header mirrored (tabs right, icon cluster left) ✓,
  search pill mirrored (coral button LEFT) ✓, greeting + "التالي" right-aligned
  ✓, card order mirrored (S-37 rightmost → S-39 leftmost) ✓, carousel arrows
  mirrored ✓. Arabic renders fully, no tofu. Prior minor S-39 time clipping
  ("08:00-09:00" cut) now fully visible — FIXED (closes §6.4 minor).
- `vehicle_ar_light.png` / `vehicle_ar_dark.png`: full mirror — hero large cell
  RIGHT, sticky card LEFT, "نظرة عامة / التوافر" right-aligned, "عرض كل الصور"
  pill at mirrored end, Edit/Assign ("تعديل / إسناد") mirrored, calendar
  weekday headers Arabic, no tofu, dark surfaces readable — FIXED.
- Verdict: Today AR dark moves PASS (with minor notes) → PASS; vehicle AR
  mirroring PASS.

### Updated verdicts

| Screen | Old | New |
|---|---|---|
| Today desktop EN light ↔ R1 home | FAIL | FAIL (TopNav centering fixed; density/pills/titles/arrows still open) |
| Vehicle detail ↔ R2 list_detail | FAIL | FAIL (gaps/rounding/show-all/de-dup fixed; hero-fill + 2-col body + type still open) |
| Driver home 390 ↔ R3 profile | FAIL | FAIL (no change) |
| Login web EN ↔ modal language | PASS | PASS (not re-shot) |
| Driver login AR dark 390 | PASS | PASS (not re-shot) |
| Today AR dark 1440 (RTL/dark) | PASS (1 minor) | PASS (truncation fixed) |
| Today EN light 390 (responsive) | FAIL | FAIL (KPI fixed; tabs + clipping still open) |
| Control Tower | FAIL (raw strings) | FAIL (strings fixed; row pattern still open) |

---

## Final verification (2026-10-23)

Re-shot AFTER all main-session fixes. Files viewed directly in
`docs/plan/screens/p1b/`: `today_en_light_1440.png`,
`vehicle_en_light.png`, `today_en_light_390.png`, `tower_en_light.png`,
`driver_home_en_light_390.png`, `driver_home_en_light_1440.png`,
`login_en_light_390.png`, `login_ar_light_390.png`,
`driver_login_en_light_390.png`, `today_ar_light_1440.png`,
`today_ar_light_390.png`. Glob for `**/*profile*.png` finds only
`docs/reference/airbnb/profile.png` (the R3 ref) — NO profile/tab shot in
`p1b/`, so driver-Profile claims are evidence-unverifiable (noted honestly
in point 5).

### 1. Today desktop (`today_en_light_1440.png`) — FIXED
- Density: 4 full cards/row (S-37, S-38, S-39, S-40) + 5th peeking at right
  edge. Tablet-breakpoint comparison holds — FIXED (closes §1.5).
- Overlay pills: "Assigned" white pills sit ON-image top-start on every card —
  FIXED (closes §1.6–§1.7). No detached floating pills.
- Titles: `S-37 / DSL-STD · 06:00–07:00 / 1,100.0 IG` two-line title + grey
  spec, consistent across row — acceptable content substitution, FIXED.
- TopNav: tabs CENTERED icon-over-label (Today/Vehicles/Customers/Menu,
  active underline) ✓; search pill below header as filter bar (out of scope,
  per prior §6 note).
- Arrows: left/right chevrons over cards on desktop present — desktop-only
  pattern as specified.
- Verdict: FIXED.

### 2. Vehicle detail (`vehicle_en_light.png`) — FIXED (with minor notes)
- 5 cells, all FILLED: 1-large + 4-small grid, each a light-grey well with a
  centered line illustration (tanker / barrels / map-pin / driver /
  truck-warning). Zero empty camera-placeholder cells — FIXED (closes §2.2).
- Gaps tight (~8px white dividers), outer container rounded — FIXED (§2.3).
- White "Show all photos" pill bottom-end of last cell — FIXED (§2.4).
- Two-column hero row (hero left + sticky card top-right with "In transit"
  pill, "Documents valid", coral "Edit" CTA) ✓; Overview below slimmed to
  `RYD-5091 / T-214 / Capacity 5,200.0 IG` only — no duplication with sticky
  card — FIXED (§2.5).
- Minor non-blocking: wells are illustrations, not photos (by design — no
  photo assets in repo); "Overview"/"Availability" headers still read ~18px
  vs R2 22px w600; price line right-aligned small. Noted, not failed.
- Verdict: FIXED.

### 3. Mobile 390 (`today_en_light_390.png`) — FIXED
- Segmented tabs: single row `Loading now 46 / In transit 0 / Arriving soon…`
  with edge fade/peek at right — scrollable strip, NO ellipsis truncation
  ("Lo…"/"Assi…" gone) — FIXED (closes §7.1).
- KPI nowrap: "266,000.0 IG", "122,800.0 IG" each single-line with sparkline —
  FIXED (§7.3).
- Arrows: absent at 390px — FIXED (§7.4).
- Cards: S-37 full + S-38 peeking = correct horizontal-scroll affordance, not
  accidental clipping — FIXED (§7.2).
- Verdict: FIXED.

### 4. Control Tower (`tower_en_light.png`) — FIXED (blocker cleared)
- Zero raw snake_case anywhere: rows read "Breakdown / Accident / Spill /
  Customer unavailable / Meter issue / Late ETA risk / Geofence event" Title
  Case; pills clean ("Live · 42", "In transit · 20", …) — FIXED (§8.1).
- Severity dots: every alert row has a leading dot (red Critical, blue High,
  blue Info) PLUS a matching `● Critical/High/Info` pill at row end — FIXED.
- Remaining minor (non-blocking): rows still bare bordered rectangles with no
  timestamp/action and tall vertical rhythm vs ref card language — accepted as
  dashboard substitution, not failed.
- Verdict: FIXED.

### 5. Driver home + profile (`driver_home_en_light_390.png`, `..._1440.png`) — PARTIAL / STILL-OPEN (evidence gap)
- Today tab is honestly a DAY view: greeting + "Next up / Items you create
  will appear in this list." empty state + bottom tabs
  (Today/Tasks/Messages/Profile) — correct per shell, no tofu, greeting wraps
  cleanly on 1440 one-liner. Stating what I see: NO avatar card and NO icon
  rows on the Today tab — by design, since R3 profile language lives on the
  Profile tab.
- Profile tab: NO shot exists in `p1b/` (glob confirms). The claimed
  avatar-card/icon-rows fix is therefore UNVERIFIABLE from current files —
  STILL-OPEN as an evidence gap (not necessarily a code gap).
- Verdict: Today-day-view FIXED/acceptable; Profile-language STILL-OPEN
  (missing shot — follow-up: capture Profile tab).

### 6. Login + AR spot-check — PASS
- `login_en_light_390.png`: centered r16 card + shadow, pin logo, Sign in /
  Company email / Password + eye / coral CTA / demo-accounts card /
  globe + "العربية" toggle — clean, PASS.
- `login_ar_light_390.png`: full RTL mirror (right-aligned title/inputs, eye
  LEFT, coral CTA, right-aligned demo card, "English + globe") — no tofu,
  PASS.
- `driver_login_en_light_390.png`: Driver ID / Driver PIN + eye, demo
  `DRV-001 / 1234` — clean, PASS.
- `today_ar_light_1440.png` + `today_ar_light_390.png`: header/search/cards/
  KPI fully mirrored (coral button LEFT, S-37 rightmost → S-40 leftmost),
  Arabic labels render fully, KPI single-line Arabic, no tofu — PASS.

### Corrections to my earlier reviews (owned)
1. Vehicle "placeholders": my re-verification labelled the grey illustration
   wells "EMPTY placeholders … STILL-OPEN". Wrong read of intent — the
   5-illustration grid IS the fixed filled state (no photo assets exist in
   this repo; camera-icon empties are gone). Correction: §2.2 is FIXED.
2. Mobile tabs "hard-clipped, no affordance": the right-edge fade/peek I
   dismissed as clipping IS the scrollable-strip affordance (ellipsis gone,
   strip scrolls). Correction: §7.1 is FIXED.
3. Density "2.5 huge cards": current 1440 file shows 4 + peek — the fix
   (tablet-breakpoint comparison) landed after my re-verification look, so
   that verdict was accurate at the time, not a misread. No correction owed
   beyond noting the new file state.

### Overall P1b visual acceptance — CONDITIONAL PASS (counts as PASS on shipped evidence)
- Blocking defects cleared: density 4/row, on-image pills, scrollable tabs,
  KPI nowrap, desktop-only arrows, 5-illustration hero + show-all, slimmed
  no-dup overview, localized alert titles, severity dots, login/AR mirroring
  with zero tofu.
- One non-blocking follow-up: capture the driver Profile tab shot to evidence
  the avatar-card/icon-rows claim (point 5). Nothing in current files
  contradicts the claim — the evidence is simply absent.
