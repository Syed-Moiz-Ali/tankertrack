# 13 — Visual Direction: Calm Control (R3, normative for all UI)

> Replaces the Airbnb-copy parts of `04`/`08`. Keep from Airbnb: whitespace,
> rounded surfaces, clear type hierarchy, calm motion, human tone, big taps.
> Everything else is our own. Content/flows/data come from the Figma
> (`11`, `figma-content/`); its navy-sidebar look is NOT copied.

## 1. Personality
Operations software that feels premium-calm: quiet, spacious, confident.
The map and the key number are each page's heroes. Nothing shouts except
real exceptions.

## 2. Anti-SaaS rules (ui-reviewer FAILs violations)
- No dark navy sidebar, no left rail, no breadcrumbs on top-level pages.
- Max 4 headline numbers per page; the rest behind "More" or side sheets.
- No ALL-CAPS tiny labels, no monospace-everywhere, no table-first pages
  (List/Cards toggle, tables secondary).
- No decorative cartoon illustrations on data cards; no repeated imagery.
- Max one soft shadow layer; otherwise borders + tonal surfaces.
- No fake filters (the Driver/Vehicle/Customer-"All" pill is deleted).
- Every page answers one question in a plain sentence under the title.

## 3. Palette (centralized tokens, light + dark)
- **Ink** `#101F2C` family: text + dark surfaces.
- **Fuel amber** single accent from `#F6B83F`, tuned for contrast:
  light theme uses deeper amber `#B97A1A`-ish for text/icons on white and
  near-black text on amber buttons; dark theme uses `#F6B83F` direct.
  Exact ramps land in `AppPalette` (AA-checked in theme_test).
- Canvas soft off-white `#F4F6F8`-ish; surfaces white; hairlines
  `#DCE4E9`/`#E7EDF1`; secondary text `#627585`.
- Status hues from the Figma, AA-adjusted: green `#16855D`, blue `#2774C7`,
  teal `#168F96`, purple `#8059BA`, orange `#BB7321`, red `#C54143`.

## 4. Shape, type, space
- Canvas soft; cards white; radius **20** large surfaces, **14**
  inputs/buttons, **999** pills; 8-pt grid; content ~1200 centered.
- Plus Jakarta Sans / IBM Plex Sans Arabic. Big confident page titles,
  large tabular numbers, sentence-case labels, grey secondary, ≤3 type
  sizes per card. 150–250 ms fades/slides; skeletons match real layouts.

## 5. Navigation (back office)
Slim top bar: product mark (tanker silhouette SVG, small, mono/amber) +
5–6 items (Today, Orders, Dispatch, Live, Fleet & people, More) + compact
command search (palette: orders/trips/drivers/vehicles/customers, keyboard
shortcut) + bell + profile menu (role, language, theme, demo tools in demo
only). Back arrow on detail pages, never top-level breadcrumbs.

## 6. Page patterns
- **Dashboard (BO-05)**: hero rounded live map (Dubai tankers, selected
  route); floating "Live operations" card (counts + selected tanker
  ETA/distance/remaining + View action); 4-number strip; "Needs attention"
  list; "Latest activity" timeline; rest in "More numbers".
- **Details**: right-side sheet / split pane over list+map + "Open full page".
- **Lists**: avatar/initials rows, primary + secondary line, status pill,
  hover; pill filters with real counts; List/Cards toggle.
- **Dispatch (P2)**: 3-column match + validation sheet + trip builder.
- **Login (BO-01..04)**: split layout, calm brand panel (silhouette mark),
  clean form; demo helper in demo drawer only.
- **Driver (24)**: one decision/screen, pinned amber CTA, shift progress,
  plain-words status, Figma copy verbatim, bottom tabs Home/Tasks/Activity/
  Support, offline/sync indicators everywhere.

## 7. Components (all on `/design`, centralized)
`TTTopBar`, `TTCommandPalette`, `TTSideSheet`, `TTSplitView`, `TTHeroMap`,
`TTStatStrip`, `TTStatusPill`, `TTListRow`, `TTEntityCard`, `TTTimeline`
(keep), `TTMatchColumn`, `TTValidationSheet`, `TTAllocationBar`,
`TTStepProgress`, `TTBottomActionBar`, `TTBottomTabBar` (keep),
`ScreenStateHost` (+ demo switcher), `TTIdleTimeoutDialog`.
DELETE Airbnb-copy: search pill, big-shadow cards, cartoon hero grid.

## 8. Assets
Client tanker silhouette + signature sample → `design_system/assets`
(recolor via tokens). Icons: AppIcons only (add a professional package
through it if a glyph is missing). Photos only licensed + credited
(optional this phase). Delete repeated cartoon tanker from cards. Maps:
real tiles, attribution shown.
