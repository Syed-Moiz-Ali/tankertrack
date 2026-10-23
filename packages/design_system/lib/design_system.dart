/// TankerTrack design system.
///
/// Single source of truth for styling. Feature code must read styling ONLY
/// through [Theme.of] (see `context_ext.dart`) and compose these TT*
/// components — never hard-code colors, text styles, spacing or icons.
/// See `docs/plan/08-ui-centralization.md`.
library;

export 'src/app_surface.dart';
export 'src/components/tt_button.dart';
export 'src/components/tt_calendar.dart';
export 'src/components/tt_card.dart';
export 'src/components/tt_dialog.dart';
export 'src/components/tt_divider.dart';
export 'src/components/tt_dropdown.dart';
export 'src/components/tt_empty_state.dart';
export 'src/components/tt_error_state.dart';
export 'src/components/tt_gap.dart';
export 'src/components/tt_kpi_card.dart';
export 'src/components/tt_scaffold.dart';
export 'src/components/tt_skeleton.dart';
export 'src/components/tt_status_chip.dart';
export 'src/components/tt_stepper.dart';
export 'src/components/tt_switches.dart';
export 'src/components/tt_text_field.dart';
export 'src/components/tt_timeline.dart';
export 'src/context_ext.dart';
export 'src/icons.dart';
export 'src/palette.dart';
export 'src/shadows.dart';
export 'src/status_colors.dart';
export 'src/storybook/design_catalogue.dart';
export 'src/theme.dart';
export 'src/tokens.dart';
