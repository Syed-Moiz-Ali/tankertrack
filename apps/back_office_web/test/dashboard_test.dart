import 'package:back_office_web/src/data_providers.dart';
import 'package:back_office_web/src/features/dashboard/dashboard_screen.dart';
import 'package:back_office_web/src/providers.dart';
import 'package:core/core.dart';
import 'package:data/data.dart';
import 'package:fleet_ui/fleet_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:l10n/l10n.dart';

import 'test_helpers.dart';

List<VehiclePosition> _live() => [
      VehiclePosition(
        vehicleId: 'T-214',
        latitude: 24.63,
        longitude: 46.72,
        heading: 0,
        speedKph: 40,
        status: 'active',
        onBoardTenths: 9000,
        updatedAt: DateTime.utc(2026, 10, 23, 4, 0),
      ),
      VehiclePosition(
        vehicleId: 'T-215',
        latitude: 24.71,
        longitude: 46.85,
        heading: 90,
        speedKph: 0,
        status: 'critical',
        onBoardTenths: 2000,
        updatedAt: DateTime.utc(2026, 10, 23, 4, 0),
      ),
    ];

Session _sara() => const Session(
      userId: 'dispatch@demo.sa',
      displayName: 'Sara Al-Qahtani',
      role: Role.dispatcher,
      driverId: null,
    );

String _expectedGreeting(AppLocalizations l10n) {
  final hour = DateTime.now().hour;
  const name = 'Sara Al-Qahtani';
  return hour < 12
      ? l10n.dash_greeting_morning(name)
      : hour < 18
          ? l10n.dash_greeting_afternoon(name)
          : l10n.dash_greeting_evening(name);
}

void main() async {
  // Real async zone: dart:io never completes inside testWidgets (FakeAsync).
  final bundle = await loadTestBundle();
  final svc = MockMasterDataService(bundle);
  final kpis = await svc.dashboardKpis();
  final orders = await svc.ordersToday();

  testWidgets('Today renders greeting, segments, carousel and KPIs',
      (tester) async {
    final qty = QuantityFmt(numbers: const NumberFmt());

    await tester.pumpWidget(
      p1TestApp(
        bundle: bundle,
        home: const DashboardScreen(),
        overrides: [
          sessionProvider.overrideWith((_) => _sara()),
          positionsProvider.overrideWith((ref) => Stream.value(_live())),
        ],
      ),
    );
    await tester.pumpAndSettle();
    final l10n = AppLocalizations.of(tester.element(find.byType(MiniMap)))!;

    expect(find.text(_expectedGreeting(l10n)), findsOneWidget);
    // Segment labels also appear on order badges (e.g. in-transit cards),
    // so duplicates are expected and fine.
    expect(find.text(l10n.seg_loading_now), findsWidgets);
    expect(find.text(l10n.seg_in_transit), findsWidgets);
    expect(find.text(l10n.seg_arriving_soon), findsWidgets);
    expect(find.text(l10n.seg_upcoming), findsWidgets);
    expect(find.text(l10n.seg_needs_attention), findsWidgets);
    expect(find.text(l10n.fleet_today), findsOneWidget);
    expect(find.byType(TTCarousel), findsOneWidget);
    expect(find.byType(TTMediaCard), findsWidgets);
    expect(find.byType(TTKpiTile), findsNWidgets(4));
    expect(find.byType(TTSparkline), findsNWidgets(4));
    expect(find.byType(TTStackedBar), findsOneWidget);
    expect(
        find.text(qty.ig(kpis.requestedTenths, l10n.unitIg)), findsOneWidget);
    expect(find.text(qty.ig(kpis.loadedTenths, l10n.unitIg)), findsOneWidget);
    expect(
        find.text(qty.ig(kpis.deliveredTenths, l10n.unitIg)), findsOneWidget);
    expect(
        find.text(qty.ig(kpis.pendingTenths, l10n.unitIg)), findsOneWidget);
  });

  testWidgets('counts match seeds: orders chips, fleet, reload, map',
      (tester) async {
    final numbers = const NumberFmt();

    await tester.pumpWidget(
      p1TestApp(
        bundle: bundle,
        home: const DashboardScreen(),
        overrides: [
          sessionProvider.overrideWith((_) => _sara()),
          positionsProvider.overrideWith((ref) => Stream.value(_live())),
        ],
      ),
    );
    await tester.pumpAndSettle();
    final l10n = AppLocalizations.of(tester.element(find.byType(MiniMap)))!;

    // Orders-by-status chips carry every status bucket from the seeds.
    for (final e in kpis.ordersByStatus.entries) {
      expect(
        find.text(
            '${masterStatusLabel(e.key, l10n)} · ${numbers.integer(e.value)}'),
        findsOneWidget,
        reason: e.key,
      );
    }
    expect(kpis.ordersByStatus.values.fold(0, (a, b) => a + b),
        orders.length);

    // Late orders card.
    expect(find.text(numbers.integer(kpis.lateOrders)), findsOneWidget);

    // Fleet stacked bar carries localized vehicle statuses.
    expect(find.byType(TTStackedBar), findsOneWidget);

    // Live MiniMap renders the stubbed positions.
    expect(find.byType(MiniMap), findsOneWidget);

    // Alerts + reload rows.
    final firstAlert = kpis.alerts.first;
    expect(
      find.text(alertTitle(firstAlert, l10n)),
      findsWidgets,
    );
    for (final id in kpis.reloadRequired) {
      expect(find.textContaining(id), findsWidgets);
    }
  });
}
