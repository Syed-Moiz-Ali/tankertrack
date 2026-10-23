# 10 — Illustration Style Guide (P1c, normative for all SVG assets)

> All product illustration comes from these hand-polished files (plus the
> wordmark). No downloads, no external sets. Improve — never replace.

## 1. One style
- Flat vector, rounded geometry (stroke-linejoin/linecap round everywhere;
  rect rx ≥ 6, circles/ellipses preferred over polygons).
- Outlines: none, EXCEPT structural strokes that are part of the style
  (rails, ladders, fences: 3px round strokes in `neutral500`).
- Shading: soft 2–3 tones = lighter + darker tint of the SAME hue
  (`accentLight`/`accentDark` pattern per hue family, never gray gradients).
- Every scene sits on: background blob (`accentLight` at 35% feel — use the
  `blob` token below) + ground shadow ellipse (`neutral900` at 12%).
- Generous whitespace: subject occupies ≤ 70% of canvas in both axes.
- Same detail level in every file: if the tanker has ribs + hatch + hubs,
  the depot gets ladders + pipes + windows (no minimal outlier, no ornate
  outlier).

## 2. Canvas & files
- Scenes: **400×300** viewBox. Objects (driver avatar art): **240×240**.
- Weight: each file **< 30 KB**, no `<image>`, no base64, no unused `<defs>`,
  no editor metadata. Optimized with the committed `svgo.config.mjs`
  (`npx svgo --config svgo.config.mjs`), multipass on.
- Shared motifs (tanker body, pin, drop) are drawn per-file from the SAME
  proportions spec (§4) — SVG `<use>` across files is impossible for
  standalone assets, so consistency is enforced by the contact sheet,
  not by includes.

## 3. Theme tokens (NO real hex except structural near-blacks — see table)
Author fills with THESE placeholders only; `ThemedSvg` string-replaces them
at load time from the active Theme (light/dark + accent change recolor
everything; zero ColorFilter; check_centralization scans the loader):

| Placeholder | Light maps to | Dark maps to |
|---|---|---|
| `#TT_ACCENT` | `colors.primary` | `colors.primary` |
| `#TT_ACCENT_DARK` | primary darkened 15% | primary lightened 15% |
| `#TT_ACCENT_LIGHT` | `primaryContainer` | `primaryContainer` |
| `#TT_BLOB` | `primaryContainer` @ ~40% alpha blend on surface | same, dark container |
| `#TT_N100..#TT_N700` | `surfaceContainerHighest → onSurfaceVariant` ramp | dark ramp equivalents |
| `#TT_INK` | `#222222` (structural ink: wheels, tires, text-like marks) | `#F2F4F7` |
| `#TT_CRITICAL` | `status.critical` | dark critical |
| `#TT_OK` | `status.completed` | dark completed |
| `#TT_SKIN_1..4` | 4 neutral skin tones (fixed, NOT themed — see §5) | same fixed |

Rules: white `#FFFFFF` allowed ONLY for specular highlights; anything else
must be a placeholder. Unit test fails any other `#[0-9a-fA-F]{6}` fill.

## 4. Motif proportions (shared spec — every file follows it)
- **Tanker** (side view, faces reading direction; flip in RTL): tank body
  300×90 rounded-45 capsule + elliptical end cap (rx 18 overlay, darker
  tint); 3 ribs (8px bands, darker tint); top hatch (24×10 + walkway rail:
  3px line with 4 posts); rear valve cabinet (28×34 + hose curve);
  cab 70×78 with windshield (rounded trapezoid, `#TT_N100` glass),
  side window, door handle (8×3), grille (3 slats), bumper, round
  headlight; 3 axles: tires r22 `#TT_INK`, hubs r9 `neutral300`,
  mudguards (arcs over rear two); ground shadow ellipse 320×20.
- **Pin**: teardrop path 44×60 + inner circle r12 surface.
- **Drop**: 36×48 teardrop + white specular dot.
- **Triangle**: rounded triangle + `!` bar+dot in `#TT_CRITICAL`.
- **Clipboard**: 120×150 r12 board + clip + 3 tick rows (ticks `#TT_OK`).
- **Bell / lock / sign / cloud / magnifier**: Phosphor-geometry lookalikes
  drawn geometric (no copied paths): bold round strokes, 45° terminals.

## 5. Driver avatar (240×240, used by TTAvatar art mode)
- Half-body geometric person: hi-vis vest (`accent` body + `#TT_OK`? no —
  vest yellow? NO new hues: vest = `accent`, reflective stripes =
  `accentLight`), cap/helmet (`neutral700`), plain tinted-circle background
  (`accentLight`).
- 4 fixed skin tones: `#8D5524`, `#C68642`, `#E0AC69`, `#F1C27D` (+1
  gender-neutral option: same construction, no gendered markers).
  Skin tones are the ONLY fixed hues allowed besides white highlights.

## 6. Per-file checklist (legibility at 48 / 120 / 400 px)
- Silhouette readable at 48px (no <4px details carrying meaning).
- No strokes thinner than 3px at authoring scale.
- Test renders: light + dark, 1x + 2x, en + ar (flip where directional).

## 7. New set (same style)
`no_results` (magnifier + drop), `error` (cracked pipe + cloud),
`offline` (cloud + slash + small tanker), `no_notifications` (bell),
`forbidden_403` (lock + barrier), `not_found_404` (road sign + tanker).
Semantic l10n keys `ill_*` en/ar; `flipForRtl` on tanker/offline/not_found.
