import 'package:flutter/material.dart';

import '../components/tt_button.dart';
import '../components/tt_card.dart';
import '../components/tt_dropdown.dart';
import '../components/tt_empty_state.dart';
import '../components/tt_error_state.dart';
import '../components/tt_gap.dart';
import '../components/tt_kpi_card.dart';
import '../components/tt_scaffold.dart';
import '../components/tt_skeleton.dart';
import '../components/tt_status_chip.dart';
import '../components/tt_stepper.dart';
import '../components/tt_text_field.dart';
import '../components/tt_timeline.dart';
import '../context_ext.dart';
import '../icons.dart';
import '../status_colors.dart';

/// Localized labels for the catalogue. The hosting app passes
/// `context.l10n` values — the catalogue itself holds zero strings.
class DesignStrings {
  const DesignStrings({
    required this.components,
    required this.buttons,
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.fields,
    required this.searchHint,
    required this.chips,
    required this.quantities,
    required this.sync,
    required this.cards,
    required this.banners,
    required this.states,
    required this.emptyTitle,
    required this.emptyMessage,
    required this.errorTitle,
    required this.errorMessage,
    required this.retry,
    required this.flow,
  });

  final String components;
  final String buttons;
  final String primary;
  final String secondary;
  final String tertiary;
  final String fields;
  final String searchHint;
  final String chips;
  final String quantities;
  final String sync;
  final String cards;
  final String banners;
  final String states;
  final String emptyTitle;
  final String emptyMessage;
  final String errorTitle;
  final String errorMessage;
  final String retry;
  final String flow;
}

/// Storybook catalogue: every TT* component on one scrollable page.
/// Rendered in goldens across light/dark × LTR/RTL × driver/web/controlRoom.
class DesignCatalogue extends StatelessWidget {
  const DesignCatalogue({super.key, required this.strings});

  final DesignStrings strings;

  @override
  Widget build(BuildContext context) {
    return TTScaffold(
      appBar: TTAppBar(title: strings.components),
      body: ListView(
        children: [
          const TTGap.lg(),
          TTSection(
            title: strings.buttons,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TTButton(label: strings.primary, onPressed: () {}),
                const TTGap.sm(),
                TTButton(
                  label: strings.secondary,
                  variant: TTButtonVariant.secondary,
                  onPressed: () {},
                ),
                const TTGap.sm(),
                TTButton(
                  label: strings.tertiary,
                  variant: TTButtonVariant.tertiary,
                  onPressed: () {},
                ),
                const TTGap.sm(),
                Row(
                  children: [
                    TTIconButton(
                      icon: Icon(
                        AppIcons.iconFor(AppIcons.add, context),
                      ),
                      onPressed: () {},
                    ),
                    const TTChip(label: 'Demo'),
                  ],
                ),
              ],
            ),
          ),
          const TTGap.xl(),
          TTSection(
            title: strings.fields,
            child: Column(
              children: [
                const TTTextField(),
                const TTGap.md(),
                TTSearchBar(hint: strings.searchHint),
                const TTGap.md(),
                const TTFilterPills(
                  options: ['A', 'B', 'C'],
                  selected: 'A',
                  onSelected: _noop,
                ),
                const TTGap.md(),
                TTNumberStepperField(
                  label: 'IG',
                  value: 1500,
                  onChanged: (_) {},
                  display: '1,500.0 IG',
                ),
                const TTGap.md(),
                TTDropdown<String>(
                  label: 'Demo',
                  value: 'A',
                  items: const [
                    TTDropdownItem(value: 'A', label: 'A'),
                    TTDropdownItem(value: 'B', label: 'B'),
                  ],
                  onChanged: (_) {},
                ),
              ],
            ),
          ),
          const TTGap.xl(),
          TTSection(
            title: strings.chips,
            child: Wrap(
              spacing: context.tokens.spaceSm,
              runSpacing: context.tokens.spaceSm,
              children: const [
                StatusChip(style: StatusStyle.completed, label: 'Completed'),
                StatusChip(style: StatusStyle.active, label: 'Active'),
                StatusChip(style: StatusStyle.loading, label: 'Loading'),
                StatusChip(style: StatusStyle.unloading, label: 'Unloading'),
                StatusChip(style: StatusStyle.waiting, label: 'Waiting'),
                StatusChip(style: StatusStyle.critical, label: 'Critical'),
                StatusChip(style: StatusStyle.offline, label: 'Offline'),
              ],
            ),
          ),
          const TTGap.xl(),
          TTSection(
            title: strings.quantities,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                QuantityBadge(primary: '4,000 IG', secondary: '18,184 L'),
                QuantityBadge(
                  primary: '2,500 IG',
                  state: QuantityState.warn,
                ),
                QuantityBadge(
                  primary: '−120 IG',
                  state: QuantityState.breach,
                ),
              ],
            ),
          ),
          const TTGap.xl(),
          TTSection(
            title: strings.sync,
            child: const Row(
              children: [
                SyncBadge(state: SyncState.pending, label: 'Pending'),
                SyncBadge(state: SyncState.synced, label: 'Synced'),
                SyncBadge(state: SyncState.failed, label: 'Failed'),
              ],
            ),
          ),
          const TTGap.xl(),
          TTSection(
            title: strings.cards,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TTKpiCard(
                        label: 'Orders',
                        value: '110',
                        sub: '+12%',
                        icon: Icon(
                          AppIcons.iconFor(AppIcons.report, context),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TTKpiCard(label: 'IG', value: '48.2K'),
                    ),
                  ],
                ),
                const TTGap.md(),
                TTCard(
                  child: TTListTile(
                    leading: const TTAvatar(initials: 'KA'),
                    title: 'Khalid Al-Otaibi',
                    subtitle: 'T-214 · 4,000 IG',
                    trailing: Icon(
                      AppIcons.iconFor(AppIcons.forward, context),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const TTGap.xl(),
          TTSection(
            title: strings.banners,
            child: Column(
              children: [
                TTBanner(message: strings.states, kind: TTBannerKind.info),
                TTBanner(message: strings.states, kind: TTBannerKind.warning),
                TTBanner(message: strings.states, kind: TTBannerKind.offline),
                TTBanner(
                  message: strings.states,
                  kind: TTBannerKind.tracking,
                ),
              ],
            ),
          ),
          const TTGap.xl(),
          TTSection(
            title: strings.states,
            child: Column(
              children: [
                TTEmptyState(
                  title: strings.emptyTitle,
                  message: strings.emptyMessage,
                ),
                const TTGap.md(),
                TTErrorState(
                  title: strings.errorTitle,
                  message: strings.errorMessage,
                  retryLabel: strings.retry,
                ),
                const TTGap.md(),
                const TTSkeleton(rows: 3),
              ],
            ),
          ),
          const TTGap.xl(),
          TTSection(
            title: strings.flow,
            child: const Column(
              children: [
                TTStepper(steps: ['One', 'Two', 'Three'], current: 1),
                TTTimeline(
                  entries: [
                    TTTimelineEntry(title: 'Start Day', subtitle: '07:00'),
                    TTTimelineEntry(title: 'Loaded', subtitle: '08:05'),
                  ],
                ),
              ],
            ),
          ),
          const TTGap.xxxl(),
        ],
      ),
    );
  }
}

void _noop(String _) {}
