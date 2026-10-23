import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l10n/l10n.dart';

/// Forced companion state for one screen (R3 demo switcher). `live` renders
/// the real provider state; the rest force the matching companion state so
/// reviewers can inspect every state's Figma copy without seed surgery.
///
/// Rendered through the design_system [ScreenStateHost] (state enum +
/// demo labels); this file owns only the per-screen override provider and
/// the auth-screen panel (list screens pass the labels straight through).
enum DemoScreenState { live, empty, loading, error, success }

/// Per-screen demo override. Absent == live.
final demoScreenStateProvider =
    StateProviderFamily<DemoScreenState, String>((_, __) => DemoScreenState.live);

/// Maps a [DemoScreenState] onto the design_system [ScreenStateKind].
/// Returns null for [DemoScreenState.live] (caller resolves from providers).
ScreenStateKind? demoKind(DemoScreenState forced) => switch (forced) {
      DemoScreenState.live => null,
      DemoScreenState.empty => ScreenStateKind.empty,
      DemoScreenState.loading => ScreenStateKind.loading,
      DemoScreenState.error => ScreenStateKind.error,
      DemoScreenState.success => ScreenStateKind.success,
    };

/// Demo labels for [ScreenStateHost.demoLabels] (generic `demo_state_*`
/// keys; forced states render the screen's own `boXX_*` Figma copy).
Map<ScreenStateKind, String> demoLabels(AppLocalizations l10n) => {
      ScreenStateKind.empty: l10n.demo_state_empty,
      ScreenStateKind.loading: l10n.demo_state_loading,
      ScreenStateKind.error: l10n.demo_state_error,
      ScreenStateKind.success: l10n.demo_state_success,
    };

/// Demo-only companion-state switcher panel: tapping the active pill returns
/// the screen to live. Used directly by auth screens; list screens wire the
/// same provider through [ScreenStateHost.demoLabels]/`onDemoSelect`.
class DemoStatePanel extends ConsumerWidget {
  const DemoStatePanel({super.key, required this.screenId});

  final String screenId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!AppFlags.isDemoBuild) return const SizedBox.shrink();
    final l10n = context.l10n;
    final current = ref.watch(demoScreenStateProvider(screenId));
    final pills = demoLabels(l10n);
    return TTCard(
      padding: EdgeInsets.all(context.tokens.spaceSm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.demo_screen_state,
            style: context.text.labelMedium,
          ),
          const TTGap.xs(),
          Wrap(
            spacing: context.tokens.spaceXs,
            runSpacing: context.tokens.spaceXs,
            children: [
              for (final entry in pills.entries)
                FilterChip(
                  label: Text(entry.value),
                  selected: demoKind(current) == entry.key,
                  onSelected: (_) => ref
                      .read(demoScreenStateProvider(screenId).notifier)
                      .state = demoKind(current) == entry.key
                          ? DemoScreenState.live
                          : DemoScreenState.values.firstWhere(
                              (DemoScreenState s) =>
                                  demoKind(s) == entry.key,
                            ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
