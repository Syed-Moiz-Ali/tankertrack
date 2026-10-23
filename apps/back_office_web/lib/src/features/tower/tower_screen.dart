import 'package:domain/domain.dart';
import 'package:fleet_ui/fleet_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l10n/l10n.dart';

import '../../data_providers.dart';
import '../masters/master_list_view.dart';

/// Control tower (slice D): live counters, status board, alerts, reload list.
class ControlTowerScreen extends ConsumerWidget {
  const ControlTowerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final kpis = ref.watch(kpisProvider);
    final vehicles = ref.watch(vehiclesProvider);
    final live = ref.watch(positionsProvider);
    final loading =
        kpis.isLoading || vehicles.isLoading || live.isLoading;
    if (loading) {
      return TTScaffold(
        appBar: TTAppBar(title: l10n.tower_title),
        body: const TTSkeletonList(),
      );
    }
    final error = kpis.error ?? vehicles.error ?? live.error;
    if (error != null) {
      return TTScaffold(
        appBar: TTAppBar(title: l10n.tower_title),
        body: TTErrorState(
          title: l10n.mst_error_title,
          message: '$error',
          retryLabel: l10n.mst_retry,
          onRetry: () {
            ref.invalidate(kpisProvider);
            ref.invalidate(vehiclesProvider);
          },
        ),
      );
    }
    final k = kpis.valueOrNull!;
    final fleet = vehicles.valueOrNull!;
    final positions = live.valueOrNull!;
    final numbers = const NumberFmt();
    final byLive = <String, int>{};
    for (final p in positions) {
      byLive.update(p.status, (v) => v + 1, ifAbsent: () => 1);
    }
    final byVehicle = <String, int>{};
    for (final v in fleet) {
      byVehicle.update(v.status, (c) => c + 1, ifAbsent: () => 1);
    }
    final byId = {for (final v in fleet) v.id: v};
    return TTScaffold(
      appBar: TTAppBar(title: l10n.tower_title),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TTSection(
              title: l10n.tower_live,
              child: Wrap(
                spacing: context.tokens.spaceSm,
                runSpacing: context.tokens.spaceSm,
                children: [
                  StatusChip(
                    style: StatusStyle.active,
                    label:
                        '${l10n.tower_live} · ${numbers.integer(positions.length)}',
                  ),
                  for (final e in byLive.entries)
                    StatusChip(
                      style: statusStyleForKey(e.key),
                      label:
                          '${liveStatusLabel(e.key, l10n)} · ${numbers.integer(e.value)}',
                    ),
                ],
              ),
            ),
            const TTGap.lg(),
            TTSection(
              title: l10n.tower_board,
              child: Wrap(
                spacing: context.tokens.spaceSm,
                runSpacing: context.tokens.spaceSm,
                children: [
                  for (final e in byVehicle.entries)
                    StatusChip(
                      style: VehicleStatus.values.byName(e.key).style,
                      label:
                          '${masterStatusLabel(e.key, l10n)} · ${numbers.integer(e.value)}',
                    ),
                ],
              ),
            ),
            const TTGap.lg(),
            TTSection(
              title: l10n.tower_alerts,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final a in k.alerts)
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
              title: l10n.tower_reload,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final id in k.reloadRequired)
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: context.tokens.spaceSm,
                      ),
                      child: TTCard(
                        padding: EdgeInsets.all(context.tokens.spaceSm),
                        child: TTListTile(
                          title: byId[id]?.registration ?? id,
                          subtitle: id,
                          trailing: StatusChip(
                            style: StatusStyle.waiting,
                            label: l10n.dash_reload,
                          ),
                        ),
                      ),
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
