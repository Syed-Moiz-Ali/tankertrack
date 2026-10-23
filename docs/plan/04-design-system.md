# 04 — Design System (Airbnb-clean, en/ar, light/dark)

> Single source of truth: `packages/design_system`. **No hard-coded colours, radii, spacing, text styles or strings in widgets** (lint-enforced). Status colours reserved for statuses only (never for branding/decoration).
> Normative centralization mechanism + enforcement: see `08-ui-centralization.md` (this doc defines the *values*, `08` defines the *mechanism*).
> Airbnb design language (P1b): the authoritative layout reference is
> `docs/plan/09-airbnb-reference-analysis.md` (images in `docs/reference/airbnb/`).
> Copy Airbnb's layout/spacing/hierarchy/patterns; never its logo, photos or artwork.

## 0. Airbnb layout language (P1b — read 09 for measurements)

- **Web top nav** (no rail): 80px white bar, logo+wordmark start, centered
  icon-over-label tabs (active = bold + underline), search pill center on
  list pages, globe + bell + profile pill cluster end, hairline on scroll.
- **Pages**: white, 1280 centered, gutters 80/40/24, 48px section rhythm,
  22/28 w600 section headers with "Show all" pills, 24px card gaps.
- **Cards**: borderless, no resting shadow, hover lift; 4:3 media r12 with
  white overlay badge + save pin; 15 w600 title, 14 grey secondary, bold figure.
- **Details**: back arrow + H1 + text actions; 1+4 hero grid (8px gaps, r12,
  show-all pill); two-column body with sticky action card (border + float
  shadow + coral CTA); sticky bottom bar on mobile.
- **Mobile**: bottom tab bar (icon + label, accent active); grabber sheets;
  full-width ≥56 primary CTAs; sticky bottom action bars.
- **Micro**: shimmer skeletons, fade-ins, 150–250ms motion, hover/pressed/
  focus states, carousel arrows on hover (desktop only), toasts for confirmations.

## 1. Tokens

- **Accent (one strong):** Teal `#0E7C7B` (primary actions, active nav). Dark theme: `#2DD4BF`-tinted variant for AA on dark surfaces. Accent never doubles as a status colour.
- **Neutrals:** paper `#FAFAF8`, ink `#101828`, greys 50–900 (Airbnb warmth: slight warm undertone). Dark surfaces `#0F1419/#161D24`, borders `white/12`.
- **Status colours (canonical, from Image-1 legend; hue fixed, luminance theme-adjusted):**
  `completed #16A34A` · `active/InProgress #2563EB` · `loading #7C3AED` · `unloading #0D9488` · `waiting/break #F59E0B` · `critical/breakdown #DC2626` · `offline/cancelled #6B7280`. Each has `onStatus` (text-on-fill) AA-passing pair + soft `statusBg` (12% alpha) for chips.
- **Radius:** 12 cards / 16 sheets & map cards / 999 pills. **Elevation:** 0 resting cards (bordered), 1 raised, 2 sheets/dialogs, 3 nav — soft (`blur 16, y 4, black/8`).
- **Spacing:** 8-pt grid (4/8/12/16/24/32/48). Page gutters: mobile 16, tablet 24, desktop 32 (max-width 1280), control-room fluid.
- **Motion:** 150 ms micro (chips/buttons), 250 ms sheets/nav, `easeOutCubic`; reduce-motion respected; CR auto-rotate 20 s fade (no slide to avoid burn-in distraction).
- **Typography:** EN `Inter` + AR `IBM Plex Sans Arabic` (fallback Noto Sans Arabic); AR line-height ×1.12, min 1.6 body; weights 400/500/700 only; tabular numerals for quantities/odometer (`fontFeatures: tnum`). Scale: display 32/40 · title 22/28 · headline 18/24 · body 15/22 (AR 15/24) · caption 12/16.

## 2. Component catalogue (`fleet_ui` + `design_system`)

Core: `TTButton` (primary ≥56 px on driver, 48 web), `TTTextField` (large, localized numeric keyboard for IG), `TTCard`, `TTBottomSheet` (mobile) / `TTDialog` (web), `TTChip` + `StatusChip` (dot + label, en/ar), `QuantityBadge` (IG value + litre sub, tolerance colour), `Timeline` (trip events), `MapCard` (marker+trail slot), `SignaturePad` (RTL-safe), `PhotoSlot` (capture state), `SyncBadge` (Pending/Synced/Failed), `EmptyState` / `ErrorState` / `SkeletonList` (every list has all three), `KPICard`, `AlertBanner` (connection-lost, tracking-active, stale-data), `ConflictSheet`, `ReasonDialog` (reason-code picker, bilingual), `LanguageSwitch` (login + settings, instant, persisted).

## 3. Layout rules per surface

- **Driver mobile (glove-friendly):** one primary action per screen, bottom-anchored ≥56 px; steppers (Start Day 1-2-3, Loading 4 steps) with progress; minimal typing (steppers, pickers, +/- IG stepper + presets 500/1000/1500); persistent tracking + connectivity banner; bottom sheets, never tiny dialogs.
- **Back-office web:** sticky search/filter bar + pill status filters on every list; master-detail (list start / detail end in RTL); dispatch board 3-column (Unassigned | Runs | Fleet strip) with drag/drop + conflict rail; maps docked end-side; tables virtualised, zebra-free, row 56 px, numeric end-aligned (mirrors correctly).
- **Control room (`/control-room`):** 60/40 map/panels; ≥28 px KPI numerals, ≥18 px labels; dark default + light toggle; no hover-dependent actions (all tappable/clickable targets ≥48 px); no page scrollbars (panels auto-rotate); alert-takeover style (flashing 2 px critical border + optional chime, focus map); 1080p→4K fluid type via `clamp()`-equivalent LayoutBuilder buckets; subtle 1 px anti-burn-in drift on static chrome.

## 4. RTL rules (non-negotiable)

`Directionality`-aware only (`EdgeInsetsDirectional`, `AlignmentDirectional`, `MainAxisAlignment.start`, `CrossAxisAlignment.start`, `BorderRadiusDirectional`); `left/right` and `Row(textDirection: ltr)` banned (lint). Directional icons mirrored (back/forward/nav arrows); non-directional (fuel drop, alert triangle) never mirrored. Charts axes + timeline direction flip in RTL; signature strokes stored direction-neutral; PDF/Excel preview templates mirrored (headers start-aligned). Golden suite renders every catalogue component + key screens in en-LTR and ar-RTL.

## 5. Accessibility & themes

AA contrast both themes (checked for status-on-bg pairs); dynamic type to 200% without clipping (AR line-height rule); semantic labels on all icon buttons (en/ar); focus order logical in both directions; keyboard-operable dispatch board (drag via keyboard move commands as fallback).
