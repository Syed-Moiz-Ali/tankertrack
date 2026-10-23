import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:fleet_ui/fleet_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l10n/l10n.dart';

import '../../data_providers.dart';
import '../masters/master_list_view.dart';

/// Executive dashboard (slice D): KPI row, orders-by-status, fleet counters,
/// late orders, alerts, reload-required, 8-step process tracker, live MiniMap.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kpis = ref.watch(kpisProvider);
    return kpis.when(
      loading: () => TTScaffold(
        appBar: TTAppBar(title: context.l10n.dash_title),
        body: const TTSkeletonList(),
      ),
      error: (e, _) => TTScaffold(
        appBar: TTAppBar(title: context.l10n.dash_title),
        body: TTErrorState(
          title: context.l10n.mst_error_title,
          message: '$e',
          retryLabel: context.l10n.mst_retry,
          onRetry: () => ref.invalidate(kpisProvider),
        ),
      ),
      data: (k) => _Body(kpis: k),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.kpis});

  final DashboardKpis kpis;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final numbers = const NumberFmt();
    final qty = QuantityFmt(numbers: numbers);
    final unit = l10n.unitIg;
    final kpi = [
      (l10n.dash_kpi_requested, kpis.requestedTenths),
      (l10n.dash_kpi_loaded, kpis.loadedTenths),
      (l10n.dash_kpi_delivered, kpis.deliveredTenths),
      (l10n.dash_kpi_pending, kpis.pendingTenths),
    ];
    final steps = [
      l10n.dash_step1,
      l10n.dash_step2,
      l10n.dash_step3,
      l10n.dash_step4,
      l10n.dash_step5,
      l10n.dash_step6,
      l10n.dash_step7,
      l10n.dash_step8,
    ];
    return TTScaffold(
      appBar: TTAppBar(title: l10n.dash_title),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var r = 0; r < 2; r++)
              Row(
                children: [
                  for (var c = 0; c < 2; c++)
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsDirectional.only(
                          end: c == 0 ? context.tokens.spaceSm : 0,
                          bottom: context.tokens.spaceSm,
                        ),
                        child: TTKpiCard(
                          label: kpi[r * 2 + c].$1,
                          value: qty.ig(kpi[r * 2 + c].$2, unit),
                        ),
                      ),
                    ),
                ],
              ),
            const TTGap.md(),
            TTSection(
              title: l10n.dash_orders_by_status,
              child: Wrap(
                spacing: context.tokens.spaceSm,
                runSpacing: context.tokens.spaceSm,
                children: [
                  for (final e in kpis.ordersByStatus.entries)
                    StatusChip(
                      style: OrderStatus.values.byName(e.key).style,
                      label:
                          '${masterStatusLabel(e.key, l10n)} · ${numbers.integer(e.value)}',
                    ),
                ],
              ),
            ),
            const TTGap.lg(),
            TTSection(
              title: l10n.dash_drivers,
              child: TTCard(
                child: Text(
                  '${numbers.integer(kpis.driversAvailable)} · '
                  '${numbers.integer(kpis.driversBusy)} · '
                  '${numbers.integer(kpis.driversOffline)}',
                  style: context.text.titleMedium,
                ),
              ),
            ),
            const TTGap.lg(),
            TTSection(
              title: l10n.dash_vehicles,
              child: TTCard(
                child: Text(
                  '${numbers.integer(kpis.vehiclesFree)} · '
                  '${numbers.integer(kpis.vehiclesAssigned)} · '
                  '${numbers.integer(kpis.vehiclesBreakdown)} · '
                  '${numbers.integer(kpis.vehiclesMaintenance)}',
                  style: context.text.titleMedium,
                ),
              ),
            ),
            const TTGap.lg(),
            TTSection(
              title: l10n.dash_late_orders,
              child: TTCard(
                child: Text(
                  numbers.integer(kpis.lateOrders),
                  style: context.text.displaySmall,
                ),
              ),
            ),
            const TTGap.lg(),
            TTSection(
              title: l10n.dash_alerts,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final a in kpis.alerts.take(8))
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: context.tokens.spaceSm,
                      ),
                      child: TTCard(
                        padding: EdgeInsets.all(context.tokens.spaceSm),
                        child: TTListTile(
                          title: a.title(arabic: context.isArabic),
                          trailing: StatusChip(
                            style: alertSeverityStyle(a.severity),
                            label: masterStatusLabel(a.severity, l10n),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const TTGap.lg(),
            TTSection(
              title: l10n.dash_reload,
              child: TTCard(
                child: Text(
                  kpis.reloadRequired.join(' · '),
                  style: context.text.bodyMedium,
                ),
              ),
            ),
            const TTGap.lg(),
            TTSection(
              title: l10n.dash_process_title,
              child: TTTimeline(
                entries: [
                  for (var i = 0; i < steps.length; i++)
                    TTTimelineEntry(
                      title: steps[i],
                      color: i == 3 ? context.colors.primary : null,
                    ),
                ],
              ),
            ),
            const TTGap.lg(),
            ref.watch(positionsProvider).when(
                  loading: () => const TTSkeletonBlock(),
                  error: (e, _) => TTErrorState(
                    title: l10n.mst_error_title,
                    message: '$e',
                    retryLabel: l10n.mst_retry,
                  ),
                  data: (positions) => MiniMap(
                    title: l10n.tower_live,
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
                ),
            const TTGap.lg(),
          ],
        ),
      ),
    );
  }
}
