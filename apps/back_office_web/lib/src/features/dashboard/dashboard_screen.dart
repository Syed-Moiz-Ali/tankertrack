import 'package:core/core.dart';
import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:fleet_ui/fleet_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n/l10n.dart';

import '../../data_providers.dart';
import '../../providers.dart';
import '../../routes.dart';
import '../../ui/demo_state.dart';
import '../masters/master_list_view.dart' show alertSeverityStyle;

/// BO-05 Main Dashboard (13 §6, 09 R1): map-led hero (rounded live map +
/// floating Live-operations card + 4-number strip), one-sentence answer
/// under the title (`dash_sentence`), Needs-attention list, Latest activity
/// timeline, and the rest behind a More-numbers expander.
///
/// Max 4 headline numbers (13 §2); Snapshot-A data via providers; no
/// illustrations on cards, no cartoon hero grids.
///
/// NOTE (return): the design_system [TTHeroMap]/[TTLiveOpsInfo] require a
/// distance value + km unit that neither the tracking entity nor the ARB
/// carry — the hero is composed here from [MiniMap] + [_LiveOpsCard] +
/// [TTStatStrip] (same contract shape, ETA/distance rows only when present).
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final kpis = ref.watch(kpisProvider);
    final orders = ref.watch(ordersTodayProvider);
    final live = ref.watch(positionsProvider);
    final forced = ref.watch(demoScreenStateProvider('bo05'));
    final liveKind = kpis.isLoading || orders.isLoading || live.isLoading
        ? ScreenStateKind.loading
        : (kpis.error ?? orders.error ?? live.error) != null
            ? ScreenStateKind.error
            : (orders.valueOrNull ?? const []).isEmpty
                ? ScreenStateKind.empty
                : ScreenStateKind.success;
    final kind = demoKind(forced) ?? liveKind;
    return TTScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const TTGap.lg(),
          Text(l10n.dash_title, style: context.text.displaySmall),
          const TTGap.xs(),
          _Sentence(kpis: kpis, orders: orders),
          const TTGap.md(),
          Expanded(
            child: ScreenStateHost(
              state: kind,
              emptyTitle: l10n.bo05_empty,
              emptyMessage: l10n.mst_empty_message,
              loadingLabel: l10n.bo05_loading,
              errorTitle: l10n.bo05_error,
              errorMessage: kpis.error?.toString() ??
                  orders.error?.toString() ??
                  live.error?.toString() ??
                  l10n.bo05_error,
              retryLabel: l10n.mst_retry,
              onRetry: () {
                ref.invalidate(kpisProvider);
                ref.invalidate(ordersTodayProvider);
              },
              demoTitle:
                  AppFlags.isDemoBuild ? l10n.demo_screen_state : null,
              demoLabels: AppFlags.isDemoBuild ? demoLabels(l10n) : null,
              onDemoSelect: AppFlags.isDemoBuild
                  ? (ScreenStateKind next) => ref
                      .read(demoScreenStateProvider('bo05').notifier)
                      .state = next == demoKind(forced)
                          ? DemoScreenState.live
                          : DemoScreenState.values.firstWhere(
                              (DemoScreenState s) => demoKind(s) == next,
                            )
                  : null,
              child: (kpis.valueOrNull == null ||
                      orders.valueOrNull == null ||
                      live.valueOrNull == null)
                  ? const SizedBox.shrink()
                  : SingleChildScrollView(
                      child: _Body(
                        kpis: kpis.valueOrNull!,
                        orders: orders.valueOrNull!,
                        positions: live.valueOrNull!,
                        forcedSuccess: forced == DemoScreenState.success,
                        successTitle: l10n.bo05_success,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

/// One-sentence answer under the title (contracts §3 `dash_sentence`).
class _Sentence extends StatelessWidget {
  const _Sentence({required this.kpis, required this.orders});

  final AsyncValue<DashboardKpis> kpis;
  final AsyncValue<List<OrderSummary>> orders;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final numbers = const NumberFmt();
    final list = orders.valueOrNull ?? const [];
    var active = 0;
    for (final o in list) {
      if (o.status == 'inProgress' ||
          o.status == 'assigned' ||
          o.status == 'partial') {
        active++;
      }
    }
    final delayed = kpis.valueOrNull?.lateOrders ?? 0;
    return Text(
      l10n.dash_sentence(numbers.integer(active), numbers.integer(delayed)),
      style: context.text.bodyMedium,
    );
  }
}

class _Body extends ConsumerStatefulWidget {
  const _Body({
    required this.kpis,
    required this.orders,
    required this.positions,
    required this.forcedSuccess,
    required this.successTitle,
  });

  final DashboardKpis kpis;
  final List<OrderSummary> orders;
  final List<VehiclePosition> positions;
  final bool forcedSuccess;
  final String successTitle;

  @override
  ConsumerState<_Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<_Body> {
  final List<FleetEvent> _liveEvents = [];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final numbers = const NumberFmt();
    final k = widget.kpis;
    ref.listen<AsyncValue<FleetEvent>>(fleetEventsProvider,
        (_, AsyncValue<FleetEvent> next) {
      final event = next.valueOrNull;
      if (event != null && mounted) {
        setState(() {
          _liveEvents.insert(0, event);
          if (_liveEvents.length > 8) _liveEvents.removeLast();
        });
      }
    });
    final stats = [
      TTStatData(
        label: l10n.dash_kpi_requested,
        value: numbers.integer(widget.orders.length),
      ),
      TTStatData(
        label: l10n.dash_kpi_pending,
        value: numbers.integer(k.ordersByStatus['unassigned'] ?? 0),
      ),
      TTStatData(
        label: l10n.dash_late_orders,
        value: numbers.integer(k.lateOrders),
      ),
      TTStatData(
        label: l10n.dash_alerts,
        value: numbers.integer(k.alerts.length),
      ),
    ];
    final role = ref.watch(sessionProvider)?.role;
    final canTower =
        role != null && routeRoles[AppRoutes.controlTower]!.contains(role);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.forcedSuccess) ...[
          TTBanner(message: widget.successTitle),
          const TTGap.md(),
        ],
        _HeroMap(
          positions: widget.positions,
          title: l10n.tower_live,
          onView: canTower ? () => context.go(AppRoutes.controlTower) : null,
        ),
        const TTGap.md(),
        TTStatStrip(stats: stats),
        const TTGap.lg(),
        TTSectionHeader(
          title: l10n.dash_needs_attention,
          actionLabel: canTower ? l10n.dash_view : null,
          onAction:
              canTower ? () => context.go(AppRoutes.controlTower) : null,
        ),
        const TTGap.sm(),
        _NeedsAttention(kpis: k),
        const TTGap.lg(),
        TTSectionHeader(title: l10n.dash_latest_activity),
        const TTGap.sm(),
        _ActivityTimeline(kpis: k, liveEvents: _liveEvents),
        const TTGap.lg(),
        _MoreNumbers(
          kpis: k,
          orderCount: widget.orders.length,
        ),
        const TTGap.xxl(),
      ],
    );
  }
}

/// Map-led hero: rounded [MiniMap] + floating live-operations card.
/// (Same contract shape as [TTHeroMap]; composed here — see file note.)
class _HeroMap extends StatelessWidget {
  const _HeroMap({
    required this.positions,
    required this.title,
    required this.onView,
  });

  final List<VehiclePosition> positions;
  final String title;
  final VoidCallback? onView;

  @override
  Widget build(BuildContext context) {
    return TTCard(
      radius: context.tokens.radiusLarge,
      padding: EdgeInsets.all(context.tokens.spaceMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          MiniMap(
            title: title,
            positions: [
              for (final p in positions)
                MapPosition(
                  id: p.vehicleId,
                  lat: p.latitude,
                  lng: p.longitude,
                  style: statusStyleForKey(p.status),
                  label: p.vehicleId,
                ),
            ],
          ),
          const TTGap.md(),
          _LiveOpsCard(positions: positions, onView: onView),
        ],
      ),
    );
  }
}

/// Floating Live-operations card (13 §6): live group counts + selected
/// tanker ETA/remaining + View action. ETA renders only when the position
/// carries one; distance needs tracking + l10n support (file note).
class _LiveOpsCard extends StatelessWidget {
  const _LiveOpsCard({required this.positions, required this.onView});

  final List<VehiclePosition> positions;
  final VoidCallback? onView;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final numbers = const NumberFmt();
    final qty = QuantityFmt(numbers: numbers);
    final unit = l10n.unitIg;
    final byStatus = <String, int>{};
    for (final p in positions) {
      byStatus.update(p.status, (c) => c + 1, ifAbsent: () => 1);
    }
    final top = byStatus.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    VehiclePosition? selected;
    for (final p in positions) {
      if (p.status == 'active') {
        selected = p;
        break;
      }
    }
    selected ??= positions.isEmpty ? null : positions.first;
    return TTCard(
      padding: EdgeInsets.all(context.tokens.spaceMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            spacing: context.tokens.spaceSm,
            runSpacing: context.tokens.spaceSm,
            children: [
              for (final e in top.take(3))
                StatusChip(
                  style: statusStyleForKey(e.key),
                  label:
                      '${liveStatusLabel(e.key, l10n)} · ${numbers.integer(e.value)}',
                ),
            ],
          ),
          if (selected != null) ...[
            const TTGap.sm(),
            const TTDivider(),
            const TTGap.sm(),
            Text(selected.vehicleId, style: context.text.titleSmall),
            Text(
              '${l10n.dash_remaining} ${qty.ig(selected.onBoardTenths, unit)}',
              style: context.text.bodySmall,
            ),
            if (selected.etaMinutes != null)
              Text(
                '${l10n.dash_eta} ${numbers.integer(selected.etaMinutes!)}',
                style: context.text.bodySmall,
              ),
            Text(
              '${selected.speedKph.toStringAsFixed(0)} · ${l10n.dash_telemetry_note}',
              style: context.text.bodySmall,
            ),
          ],
          if (onView != null) ...[
            const TTGap.sm(),
            TTButton(
              variant: TTButtonVariant.secondary,
              label: l10n.dash_view,
              onPressed: onView,
            ),
          ],
        ],
      ),
    );
  }
}

class _NeedsAttention extends StatelessWidget {
  const _NeedsAttention({required this.kpis});

  final DashboardKpis kpis;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final items = kpis.alerts.take(5).toList();
    if (items.isEmpty) {
      return TTEmptyState(
        title: l10n.mst_empty_title,
        message: l10n.mst_empty_message,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final alert in items)
          Padding(
            padding: EdgeInsets.only(bottom: context.tokens.spaceSm),
            child: TTListRow(
              title: alertTitle(alert, l10n),
              subtitle: alert.atIdentifier,
              style: alertSeverityStyle(alert.severity),
              pillLabel: masterStatusLabel(alert.severity, l10n),
            ),
          ),
      ],
    );
  }
}

class _ActivityTimeline extends StatelessWidget {
  const _ActivityTimeline({required this.kpis, required this.liveEvents});

  final DashboardKpis kpis;
  final List<FleetEvent> liveEvents;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final entries = <TTTimelineEntry>[
      for (final e in liveEvents)
        TTTimelineEntry(
          title: _eventTitle(e, l10n),
          subtitle: e.vehicleId,
        ),
      for (final a in kpis.alerts.take(5))
        TTTimelineEntry(
          title: alertTitle(a, l10n),
          subtitle: a.atIdentifier,
        ),
    ];
    if (entries.isEmpty) {
      return TTEmptyState(
        title: l10n.mst_empty_title,
        message: l10n.mst_empty_message,
      );
    }
    return TTTimeline(entries: entries);
  }

  String _eventTitle(FleetEvent event, AppLocalizations l10n) => switch (event
      .type) {
    'delay' => l10n.ntf_late_eta,
    'breakdown' => l10n.inc_breakdown,
    _ => l10n.tower_live,
  };
}

/// Rest of the numbers behind the `dash_more_numbers` expander (13 §2).
class _MoreNumbers extends StatelessWidget {
  const _MoreNumbers({required this.kpis, required this.orderCount});

  final DashboardKpis kpis;
  final int orderCount;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final numbers = const NumberFmt();
    final qty = QuantityFmt(numbers: numbers);
    final unit = l10n.unitIg;
    final k = kpis;
    final rows = <String, String>{
      l10n.dash_kpi_requested: numbers.integer(orderCount),
      l10n.dash_kpi_loaded: qty.ig(k.loadedTenths, unit),
      l10n.dash_kpi_delivered: qty.ig(k.deliveredTenths, unit),
      l10n.dash_drivers:
          '${numbers.integer(k.driversAvailable + k.driversBusy)} / ${numbers.integer(k.driversAvailable + k.driversBusy + k.driversOffline)}',
      l10n.dash_vehicles:
          '${numbers.integer(k.vehiclesFree + k.vehiclesAssigned)} / ${numbers.integer(k.vehiclesFree + k.vehiclesAssigned + k.vehiclesBreakdown + k.vehiclesMaintenance)}',
      l10n.dash_reload: numbers.integer(k.reloadRequired.length),
    };
    return TTCard(
      child: ExpansionTile(
        title: Text(l10n.dash_more_numbers, style: context.text.titleSmall),
        children: [
          for (final entry in rows.entries)
            TTListTile(title: entry.key, trailing: Text(entry.value)),
          const TTGap.sm(),
          Wrap(
            spacing: context.tokens.spaceSm,
            runSpacing: context.tokens.spaceSm,
            children: [
              for (final e in k.ordersByStatus.entries)
                StatusChip(
                  style: _orderStyle(e.key),
                  label:
                      '${masterStatusLabel(e.key, l10n)} · ${numbers.integer(e.value)}',
                ),
            ],
          ),
          const TTGap.sm(),
        ],
      ),
    );
  }

  StatusStyle _orderStyle(String key) {
    try {
      return OrderStatus.values.byName(key).style;
    } catch (_) {
      return StatusStyle.waiting;
    }
  }
}
