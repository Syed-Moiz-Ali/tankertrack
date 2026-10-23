# 09 — Airbnb Reference Analysis (P1b primary design source)

> Images in `docs/reference/airbnb/` override the written P1b prompt wherever
> they differ. Copy layout/spacing/hierarchy/patterns only — never Airbnb's
> name, logo, photos, icons or Cereal font. Our mark stays "TankerTrack".

## R1 — home.png (Airbnb search/home, desktop ~1900px)

- **Header ~80px, white.** Left: coral-red logo + wordmark. CENTER: category
  tabs — icon (~30px) over 14px semibold label, active = black text + 2-3px
  black underline; inactive grey. Right: "Become a host" 14 semibold +
  avatar circle + hamburger circle button. Hairline #EBEBEB under header.
- **Search pill**: centered, max-width ~850, fully rounded, white, soft
  shadow `0 6px 16px rgba(0,0,0,.12)`. Three segments: 12px w800 label over
  14px grey value, hairline dividers. End: circular coral button (~48px)
  with white magnifier.
- **Content**: near-full-bleed, 24px gutters. Section header: 22px w600
  title + circular arrow button at the row end. **7 cards/row at 1900px**
  (responsive 2→6). Card gap 24.
- **Card**: image rounded-12, ~4:3; white pill top-start ("Guest
  favourite", 12-13px w600); heart top-end; title 15px w500-600 one-line
  ellipsis; grey 14px secondary line (price · rating). No resting shadow
  or border; hover lifts.
- **Colors sampled**: bg #FFFFFF, text #222222, grey #717171, accent
  coral #FF385C, hairline #EBEBEB, surface #F7F7F7.
- **Maps to**: our top nav (TTTopNav + tabs), search pill (TTSearchPill),
  dashboard sections + carousels (TTCarousel), fleet grid (TTMediaCard),
  KPI tiles language, section headers (TTSectionHeader).
- **Requires**: new TTTopNav/TTNavTab/TTSearchPill/TTCategoryBar/
  TTProfileMenu/TTIconCircleButton/TTMediaCard/TTStatusOverlayBadge/
  TTCarousel/TTSectionHeader/TTLogoMark; tokens: header 80, gutters
  80/40/24, grid gap 24, radius 8/12/16/999, float shadow, accent coral.

## R2 — list_detail.png (listing page, content max-width ~1120 centered)

- **Compact header**: same logo left; CENTER compact pill ("Anywhere |
  Anytime | Add guests", 14px w600 segments + small coral button); right
  profile cluster. Used on all non-home pages.
- **H1 26px w600** + right-aligned Share/Save underline text actions.
- **Hero grid**: 1 large (2 rows) + 4 small, 8px gaps, outer rounded-12;
  "Show all photos" white pill bottom-end of the last cell.
- **Two-column body**: left content (H2 22px w600, grey spec lines,
  bordered rating panel radius-12); RIGHT **sticky booking card**
  (1px #DDDDDD border, radius 12, float shadow): bold price line, boxed
  date fields, full-width coral CTA. 48px section rhythm, #EBEBEB dividers.
- **Maps to**: vehicle/driver/customer/depot detail pages (TTImageGrid +
  TTStickyActionCard + TTStickyBottomBar on mobile; back arrow; Share/Save
  equivalents = Edit/Assign text actions).
- **Requires**: new TTImageGrid/TTStickyActionCard/TTStickyBottomBar;
  detail layouts rebuilt per this structure.

## R3 — profile.png (profile + sidebar pattern)

- Same compact header. **Left sidebar**: H1 32px w800 + nav list
  (icon + 15px label rows, selected = #F7F7F7 pill radius-12).
- **Content**: "About me" H2 ~28-32px w700 + grey "Edit" pill button;
  profile card (avatar + name + stat column, radius ~24, float shadow);
  icon + 15px detail rows; grey "Show all" pill; dividers; bio 15-16px;
  huge whitespace, nothing cramped.
- **Maps to**: driver detail/profile sections (avatar card + licence/
  compliance icon rows), masters detail rhythm, "Show all" pattern
  (TTSectionHeader), sidebar pattern (kept for admin/settings only —
  NOT for primary nav, which follows R1 top tabs).
- **Requires**: TTSectionHeader (title + Show-all pill), avatar-card
  composition from TTCard + TTAvatar, icon-row pattern (TTListTile).

## Reference map (our screen → image → components)

| Our screen | Ref | Components |
|---|---|---|
| Top nav (all web pages) | R1 header, R2 compact | TTTopNav, TTNavTab, TTSearchPill, TTProfileMenu, TTIconCircleButton, TTLogoMark |
| Dashboard "Today" | R1 sections/carousel/cards | TTSegmentedTabs, TTCarousel, TTMediaCard, TTKpiTile+TTSparkline, TTStackedBar+legend, map card |
| Fleet grid (vehicles/drivers) | R1 grid + TTCategoryBar tabs | TTMediaCard grid, TTCategoryBar pills |
| Vehicle/driver/customer/depot detail | R2 (+ R3 sections) | back arrow, TTImageGrid, TTStickyActionCard/BottomBar, TTTimeline, TTMonthCalendar |
| Driver profile blocks | R3 | avatar card, icon rows, Show-all |
| Login (both apps) | R2 modal language + prompt §3.5 | centered card r16 + shadow, TTLogoMark, globe button, demo-details helper |
| Driver mobile shell | Prompt §3.4 (no mobile ref image) | TTBottomTabBar, TTGrabberSheet, sticky bottom bar |
| Control room | Prompt §3.5b (dark wall, same tokens) | same pills/cards, dark surface |

## Token deltas locked from references

Page #FFFFFF · ink #222222 · grey #717171 · hairline #EBEBEB/#DDDDDD ·
surface #F7F7F7 · accent coral-red (CTA) + teal secondary · radii
8/12/16/999 · float shadow `0 6px 16px rgba(0,0,0,.12)` · header 80 ·
content 1280 centered · gutters 80/40/24 · grid gap 24 · section rhythm 48.
Type: page 32/40 w800 −0.5 tracking; section 22/28 w600; card 15-16 w600;
secondary 14 grey; caption 12.
