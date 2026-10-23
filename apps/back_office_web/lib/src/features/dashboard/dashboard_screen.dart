import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:fleet_ui/fleet_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n/l10n.dart';

import '../../data_providers.dart';
import '../../providers.dart';
import '../../routes.dart';
import '../masters/master_list_view.dart';

/// "Today" dashboard (09 map, R1): greeting, [TTSegmentedTabs] with counts,
/// trip/order [TTCarousel] of [TTMediaCard]s, [TTKpiTile] fleet section,
/// [TTStackedBar] fleet status with legend, status cards row, live map card
/// with pills + Show-all, alerts / reload rows.
///
/// Wired to [kpisProvider], [positionsProvider] and [masterDataProvider]
/// (read-only) — no new data seam.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kpis = ref.watch(kpisProvider);
    final orders = ref.watch(ordersTodayProvider);
    final live = ref.watch(positionsProvider);
    if (kpis.isLoading || orders.isLoading || live.isLoading) {
      return const TTScaffold(body: TTSkeletonList());
    }
    final error = kpis.error ?? orders.error ?? live.error;
    if (error != null) {
      return TTScaffold(
        body: TTErrorState(
          title: context.l10n.mst_error_title,
          message: '$error',
          retryLabel: context.l10n.mst_retry,
          onRetry: () {
            ref.invalidate(kpisProvider);
            ref.invalidate(ordersTodayProvider);
          },
        ),
      );
    }
    return _Body(
      kpis: kpis.valueOrNull!,
      orders: orders.valueOrNull!,
      positions: live.valueOrNull!,
    );
  }
}

class _Body extends ConsumerStatefulWidget {
  const _Body({
    required this.kpis,
    required this.orders,
    required this.positions,
  });

  final DashboardKpis kpis;
  final List<OrderSummary> orders;
  final List<VehiclePosition> positions;

  @override
  ConsumerState<_Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<_Body> {
  late int _segment;

  static const _loadingNow = {'assigned', 'loading', 'inProgress'};
  static const _inTransit = {'inTransit', 'delivering', 'atLoading', 'loaded'};
  static const _arrivingSoon = {'atCustomer', 'unloading', 'partial'};
  static const _upcoming = {'draft', 'confirmed', 'unassigned', 'onHold'};

  @override
  void initState() {
    super.initState();
    // Default to the first segment that actually has cards so the carousel
    // is never an empty hero on seed/demo data.
    _segment = _initialSegment();
  }

  int _initialSegment() {
    const groups = [
      _loadingNow,
      _inTransit,
      _arrivingSoon,
      _upcoming,
    ];
    for (var i = 0; i < groups.length; i++) {
      if (widget.orders.any((o) => groups[i].contains(o.status))) return i;
    }
    if (widget.orders.any(_needsAttention)) return 4;
    return 1;
  }

  bool _needsAttention(OrderSummary o) =>
      o.hasVariance || o.status == 'failed' || o.status == 'cancelled';

  List<OrderSummary> _forSegment(int index) {
    final orders = widget.orders;
    return switch (index) {
      0 => orders.where((o) => _loadingNow.contains(o.status)).toList(),
      1 => orders.where((o) => _inTransit.contains(o.status)).toList(),
      2 => orders.where((o) => _arrivingSoon.contains(o.status)).toList(),
      3 => orders.where((o) => _upcoming.contains(o.status)).toList(),
      _ => orders.where(_needsAttention).toList(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final k = widget.kpis;
    final numbers = const NumberFmt();
    final qty = QuantityFmt(numbers: numbers);
    final unit = l10n.unitIg;
    final name = ref.watch(sessionProvider)?.displayName ?? '';
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? l10n.dash_greeting_morning(name)
        : hour < 18
            ? l10n.dash_greeting_afternoon(name)
            : l10n.dash_greeting_evening(name);
    final tabs = [
      TTCountTab(
        label: l10n.seg_loading_now,
        count: widget.orders.where((o) => _loadingNow.contains(o.status)).length,
      ),
      TTCountTab(
        label: l10n.seg_in_transit,
        count: widget.orders.where((o) => _inTransit.contains(o.status)).length,
      ),
      TTCountTab(
        label: l10n.seg_arriving_soon,
        count:
            widget.orders.where((o) => _arrivingSoon.contains(o.status)).length,
      ),
      TTCountTab(
        label: l10n.seg_upcoming,
        count: widget.orders.where((o) => _upcoming.contains(o.status)).length,
      ),
      TTCountTab(
        label: l10n.seg_needs_attention,
        count: widget.orders.where(_needsAttention).length,
      ),
    ];
    final role = ref.watch(sessionProvider)?.role;
    final canTower =
        role != null && routeRoles[AppRoutes.controlTower]!.contains(role);
    return TTScaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const TTGap.lg(),
            Text(greeting, style: context.text.displaySmall),
            const TTGap.xs(),
            Text(l10n.today_next_up, style: context.text.bodyMedium),
            const TTGap.md(),
            TTSegmentedTabs(
              tabs: tabs,
              selected: _segment,
              onSelect: (i) => setState(() => _segment = i),
            ),
            const TTGap.md(),
            LayoutBuilder(
              builder: (context, constraints) {
                final max = constraints.maxWidth;
                // Denser than P1 (review): ~4 cards/row on tablet and up
                // (content width never reaches breakpointDesktop because
                // the scaffold caps at 1280 − gutters — compare against
                // the tablet breakpoint instead), 2.5 mid, 1.5 phones.
                final visible = max >= context.tokens.breakpointTablet
                    ? 4.2
                    : max >= context.tokens.breakpointMobile
                        ? 2.5
                        : 1.5;
                return TTCarousel(
                  itemWidth: max / visible,
                  children: [
                    for (final o in _forSegment(_segment))
                      _OrderCard(order: o, qty: qty, unit: unit),
                  ],
                );
              },
            ),
            const TTGap.lg(),
            TTSectionHeader(title: l10n.fleet_today),
            const TTGap.sm(),
            _KpiGrid(kpis: k, numbers: numbers, qty: qty, unit: unit),
            const TTGap.lg(),
            _FleetStatus(vehicles: ref.watch(vehiclesProvider).valueOrNull),
            const TTGap.lg(),
            TTSectionHeader(
              title: l10n.tower_live,
              actionLabel: canTower ? l10n.map_show_all : null,
              onAction:
                  canTower ? () => context.go(AppRoutes.controlTower) : null,
            ),
            const TTGap.sm(),
            _LiveMapCard(positions: widget.positions),
            const TTGap.lg(),
            TTSectionHeader(title: l10n.dash_alerts),
            const TTGap.sm(),
            _AlertsList(kpis: k),
            const TTGap.lg(),
            TTSectionHeader(title: l10n.dash_reload),
            const TTGap.sm(),
            _ReloadList(kpis: k),
            const TTGap.xxl(),
          ],
        ),
      ),
    );
  }
}

List<double> _spark(int v) => [
      (v - 2).clamp(0, 1 << 30).toDouble(),
      (v - 1).clamp(0, 1 << 30).toDouble(),
      v.toDouble(),
    ];

class _OrderCard extends ConsumerWidget {
  const _OrderCard({
    required this.order,
    required this.qty,
    required this.unit,
  });

  final OrderSummary order;
  final QuantityFmt qty;
  final String unit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final arabic = context.isArabic;
    final sites = ref.watch(sitesProvider).valueOrNull ?? const [];
    final products = ref.watch(productsProvider).valueOrNull ?? const [];
    final site = sites.where((s) => s.id == order.siteId);
    final product = products.where((p) => p.id == order.productId);
    final siteName = site.isEmpty ? order.siteId : site.first.name(arabic: arabic);
    final productName =
        product.isEmpty ? order.productId : product.first.name(arabic: arabic);
    final secondary = '$productName · ${order.window}';
    return TTMediaCard(
      image: SvgPicture.asset(AppAssets.tanker, fit: BoxFit.contain),
      title: siteName,
      subtitle: secondary,
      figure: qty.ig(order.qtyTenths, unit),
      badge: masterStatusLabel(order.status, l10n),
    );
  }
}

class _KpiGrid extends StatelessWidget {
  const _KpiGrid({
    required this.kpis,
    required this.numbers,
    required this.qty,
    required this.unit,
  });

  final DashboardKpis kpis;
  final NumberFmt numbers;
  final QuantityFmt qty;
  final String unit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final requested = qty.ig(kpis.requestedTenths, unit);
    final loaded = qty.ig(kpis.loadedTenths, unit);
    final delivered = qty.ig(kpis.deliveredTenths, unit);
    final pending = qty.ig(kpis.pendingTenths, unit);
    final statuses = [
      for (final e in kpis.ordersByStatus.entries)
        StatusChip(
          style: OrderStatus.values.byName(e.key).style,
          label: '${masterStatusLabel(e.key, l10n)} · ${numbers.integer(e.value)}',
        ),
    ];
    final tiles = [
      (AppIcons.fuelDrop, requested, l10n.dash_kpi_requested,
          l10n.kpi_trend_up, _spark(kpis.requestedTenths ~/ 10)),
      (AppIcons.truck, loaded, l10n.dash_kpi_loaded, l10n.kpi_trend_up,
          _spark(kpis.loadedTenths ~/ 10)),
      (AppIcons.navigation, delivered, l10n.dash_kpi_delivered,
          l10n.kpi_trend_up, _spark(kpis.deliveredTenths ~/ 10)),
      (AppIcons.pending, pending, l10n.dash_kpi_pending, l10n.kpi_trend_down,
          _spark(kpis.pendingTenths ~/ 10)),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final max = constraints.maxWidth;
            final wide =
                max >= context.tokens.breakpointTablet;
            final cols = wide ? 4 : 2;
            final gap = context.tokens.gridGap;
            final cellWidth = (max - gap * (cols - 1)) / cols;
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: [
                for (final t in tiles)
                  SizedBox(
                    width: cellWidth,
                    child: TTCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TTKpiTile(
                            icon: t.$1,
                            value: t.$2,
                            caption: t.$3,
                            trend: t.$4,
                          ),
                          const TTGap.sm(),
                          TTSparkline(values: t.$5),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        const TTGap.md(),
        Wrap(
          spacing: context.tokens.spaceSm,
          runSpacing: context.tokens.spaceSm,
          children: statuses,
        ),
        const TTGap.md(),
        TTCard(
          child: Text(
            numbers.integer(kpis.lateOrders),
            style: context.text.displaySmall,
          ),
        ),
      ],
    );
  }
}

class _FleetStatus extends StatelessWidget {
  const _FleetStatus({required this.vehicles});

  final List<VehicleInfo>? vehicles;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final fleet = vehicles ?? const [];
    final byStatus = <String, int>{};
    for (final v in fleet) {
      byStatus.update(v.status, (c) => c + 1, ifAbsent: () => 1);
    }
    final segments = [
      for (final e in byStatus.entries)
        TTBarSegment(
          label: masterStatusLabel(e.key, l10n),
          value: e.value.toDouble(),
          style: VehicleStatus.values.byName(e.key).style,
        ),
    ];
    // Legend renders inside TTStackedBar.
    return TTStackedBar(segments: segments);
  }
}

class _LiveMapCard extends StatelessWidget {
  const _LiveMapCard({required this.positions});

  final List<VehiclePosition> positions;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final numbers = const NumberFmt();
    final byLive = <String, int>{};
    for (final p in positions) {
      byLive.update(p.status, (c) => c + 1, ifAbsent: () => 1);
    }
    return TTCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: context.tokens.spaceSm,
            runSpacing: context.tokens.spaceSm,
            children: [
              for (final e in byLive.entries)
                StatusChip(
                  style: statusStyleForKey(e.key),
                  label:
                      '${liveStatusLabel(e.key, l10n)} · ${numbers.integer(e.value)}',
                ),
            ],
          ),
          const TTGap.md(),
          MiniMap(
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
        ],
      ),
    );
  }
}

class _AlertsList extends StatelessWidget {
  const _AlertsList({required this.kpis});

  final DashboardKpis kpis;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final a in kpis.alerts.take(5))
          Padding(
            padding: EdgeInsets.only(bottom: context.tokens.spaceSm),
            child: TTCard(
              padding: EdgeInsets.all(context.tokens.spaceSm),
              child: TTListTile(
                leading: Container(
                  width: context.tokens.spaceSm,
                  height: context.tokens.spaceSm,
                  decoration: BoxDecoration(
                    color: statusStyleColor(
                      alertSeverityStyle(a.severity),
                      context.status,
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
                title: alertTitle(a, l10n),
                trailing: StatusChip(
                  style: alertSeverityStyle(a.severity),
                  label: masterStatusLabel(a.severity, l10n),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ReloadList extends ConsumerWidget {
  const _ReloadList({required this.kpis});

  final DashboardKpis kpis;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final fleet = ref.watch(vehiclesProvider).valueOrNull ?? const [];
    final byId = {for (final v in fleet) v.id: v};
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final id in kpis.reloadRequired)
          Padding(
            padding: EdgeInsets.only(bottom: context.tokens.spaceSm),
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
    );
  }
}
