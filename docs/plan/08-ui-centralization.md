# 08 — UI Centralization (non-negotiable rule, all phases)

> **Principle:** a screen contains zero styling decisions. Change one token or one theme entry and the entire product (driver app, back office, control room, light/dark, EN/AR) updates. Widgets read styling ONLY through `Theme.of(context)` (and its extensions). Screens only compose shared components from `design_system` / `fleet_ui`.
>
> This document is the normative spec. `04-design-system.md` defines the *values*; this document defines the *mechanism and enforcement*. In case of conflict, this document wins on mechanism.

## 1. Where things live (single sources of truth, all in `packages/design_system`)

| Concern | Single source | How widgets access it |
|---|---|---|
| Colors | `ColorScheme` built from one `AppPalette` (light + dark) | `Theme.of(context).colorScheme.primary` etc. Never `Color(0x…)`, never `Colors.red`. |
| Status colors, tolerance colors, map-marker colors | `StatusColors` `ThemeExtension` (completed, active, loading, unloading, waiting, critical, offline + `on*` + `*Bg`) | `Theme.of(context).extension<StatusColors>()!` wrapped by `context.status` |
| Text styles | `TextTheme` built once (EN Inter / AR IBM Plex Sans Arabic, locale-aware height, tabular figures variants) | `Theme.of(context).textTheme.titleLarge` etc. Never `TextStyle(...)`, never `fontSize:`/`fontWeight:` in widgets. Only `.copyWith(color: scheme.x)` from theme colors if truly needed, and prefer adding a named style. |
| Spacing, radii, elevation, durations, curves, icon sizes, breakpoints, touch-target sizes | `AppTokens` `ThemeExtension` (`space.xs…xxl`, `radius.card/sheet/pill`, `motion.micro/sheet`, `size.touchDriver=56`, `size.touchWeb=48`, `breakpoints`) | `context.tokens.space.md`, `context.tokens.radius.card` |
| Component looks | Component themes inside `ThemeData`: `ElevatedButtonTheme`, `OutlinedButtonTheme`, `TextButtonTheme`, `FilledButtonTheme`, `InputDecorationTheme`, `CardTheme`, `ChipTheme`, `DialogTheme`, `BottomSheetTheme`, `AppBarTheme`, `NavigationBarTheme`, `NavigationRailTheme`, `DataTableTheme`, `TabBarTheme`, `SnackBarTheme`, `TooltipTheme`, `SwitchTheme`, `CheckboxTheme`, `ProgressIndicatorTheme`, `DividerTheme`, `ListTileTheme`, `PageTransitionsTheme`, `ScrollbarTheme` | Use the plain Material widget; its look comes from the theme. No per-widget `style:`/`decoration:` overrides. |
| Surface variants (driver vs web vs control-room density/size) | Three theme builders from the same palette: `AppTheme.driver()`, `AppTheme.web()`, `AppTheme.controlRoom()` (bigger type scale, dark default). Each = same tokens, different scale + component sizing. | Set once at the app root; screens never branch on platform for styling. |
| Strings | `l10n` ARB (en/ar) | `context.l10n.xyz` only |
| Icons | `AppIcons` (one file, semantic names like `AppIcons.fuelDrop`, `AppIcons.breakdown`, with directional flag for RTL mirroring) | `AppIcons.x` only — no `Icons.xyz` in feature code |
| Images / SVG / fonts | `AppAssets` generated (flutter_gen) | `AppAssets.x` |
| Routes | `AppRoutes` typed constants | never string literals |
| Durations / timeouts / thresholds / intervals | `AppConfig` + `AppTokens.motion` | never magic numbers in widgets |
| Reusable UI | `TT*` components (§2) | screens import components, not raw Material for anything styled |

## 2. Required shared components (built in P0; screens must not roll their own)

`TTScaffold` (page chrome, gutters, max-width, safe areas, banners slot), `TTAppBar`, `TTSection` (title + content), `TTCard`, `TTListTile`, `TTButton` (primary/secondary/tertiary/destructive, sizes by surface), `TTIconButton`, `TTTextField`, `TTNumberStepperField` (IG), `TTDropdown`, `TTSearchBar`, `TTFilterPills`, `TTChip`, `StatusChip`, `QuantityBadge`, `SyncBadge`, `TTBottomSheet`, `TTDialog`, `ReasonDialog`, `ConflictSheet`, `TTDataTable` (virtualized, RTL-correct), `TTEmptyState`, `TTErrorState`, `TTSkeleton*`, `TTKpiCard`, `TTTimeline`, `TTStepper`, `TTBanner` (offline / tracking-active / stale), `TTToast`, `TTAvatar`, `TTMapCard`, `TTSignaturePad`, `TTPhotoSlot`, `TTLanguageSwitch`, `TTThemeSwitch`, `TTGap` (spacing via tokens, replaces raw SizedBox), `TTDivider`.
Each component is shown on the `/design` storybook route in all 4 variants (light/dark × LTR/RTL) and in the driver/web/control-room themes.

## 3. Access helpers (one file, `design_system/lib/src/context_ext.dart`)

`context.colors` (= `Theme.of(context).colorScheme`), `context.text` (= `Theme.of(context).textTheme`), `context.status`, `context.tokens`, `context.l10n`, `context.isRtl`, `context.surface` (driver/web/controlRoom). Every one resolves through `Theme.of(context)` or an inherited theme extension — no globals, no static colors, so theme switching and per-subtree overrides always work.

## 4. BANNED in `apps/*` and `fleet_ui` feature code (enforced, not "by convention")

`Color(`, `Colors.`, `TextStyle(`, `fontSize`, `fontWeight`, `fontFamily`, `BorderRadius.circular(` with literals, `EdgeInsets.*` with numeric literals, `SizedBox(width|height: <number>)`, `Duration(milliseconds|seconds: <number>)` in UI, `Icons.` / `CupertinoIcons.`, raw string literals in `Text(`, `left/right` directional APIs, `MediaQuery` size checks for styling (use token breakpoints), `Theme(data: ThemeData(...))` ad-hoc local themes (use named theme variants or component props).
Allowed only inside `packages/design_system` (where tokens are defined).

## 5. Enforcement (must exist before P0 is "done")

1. `custom_lint` rules (package `tankertrack_lints`) for every banned pattern above, failing `melos analyze`.
2. A CI script `tool/check_centralization.sh` (ripgrep) as a second net, run in `melos analyze`.
3. Golden tests rendering the `/design` catalogue in: light/dark × LTR/RTL × driver/web/controlRoom themes.
4. A **"theme proof" test**: swap the accent color in `AppPalette` and re-run goldens → every screen's primary color changes; swap font → every text changes. Document the result in `progress.md`. This is the acceptance test for centralization.
5. Code review checklist item in each phase summary: "0 violations from check_centralization".

## 6. Theme switching & runtime

Light/dark/system toggle, language toggle (EN/AR), and surface theme are all Riverpod providers feeding a single `MaterialApp.router(theme:, darkTheme:, themeMode:, locale:)`. Control room forces `AppTheme.controlRoom()` with dark default and a light toggle. Theme/locale persist locally.

## 7. Backend centralization (same spirit)

Java side: one `ErrorCodes` catalog (en/ar messages), one `ReasonCode` table, one `ConfigKeys` enum, one constants/units class (IG/litre conversion), one OpenAPI `components` section for shared schemas — no duplicated literals across modules.

## 8. Per-phase acceptance (applies to P0–P9)

Every phase exit requires: **0 violations from `check_centralization` + custom_lint; all new components appear on `/design` in 4 variants × 3 surface themes.** (Mirrored in `05-phase-plan.md` per phase.)
