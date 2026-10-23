import 'package:back_office_web/src/data_providers.dart';
import 'package:back_office_web/src/features/dashboard/dashboard_screen.dart';
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

void main() async {
  // Real async zone: dart:io never completes inside testWidgets (FakeAsync).
  final bundle = await loadTestBundle();
  final svc = MockMasterDataService(bundle);
  final kpis = await svc.dashboardKpis();
  final orders = await svc.ordersToday();

  testWidgets('KPIs render and match slice-A seed math', (tester) async {
    final qty = QuantityFmt(numbers: const NumberFmt());

    await tester.pumpWidget(
      p1TestApp(
        bundle: bundle,
        home: const DashboardScreen(),
        overrides: [
          positionsProvider.overrideWith((ref) => Stream.value(_live())),
        ],
      ),
    );
    await tester.pumpAndSettle();
    final l10n =
        AppLocalizations.of(tester.element(find.byType(MiniMap)))!;

    expect(find.text(l10n.dash_title), findsOneWidget);
    expect(
        find.text(qty.ig(kpis.requestedTenths, l10n.unitIg)), findsOneWidget);
    expect(find.text(qty.ig(kpis.loadedTenths, l10n.unitIg)), findsOneWidget);
    expect(
        find.text(qty.ig(kpis.deliveredTenths, l10n.unitIg)), findsOneWidget);
    expect(
        find.text(qty.ig(kpis.pendingTenths, l10n.unitIg)), findsOneWidget);
  });

  testWidgets('counts match seeds: orders chips, drivers, vehicles, reload',
      (tester) async {
    final numbers = const NumberFmt();

    await tester.pumpWidget(
      p1TestApp(
        bundle: bundle,
        home: const DashboardScreen(),
        overrides: [
          positionsProvider.overrideWith((ref) => Stream.value(_live())),
        ],
      ),
    );
    await tester.pumpAndSettle();
    final l10n =
        AppLocalizations.of(tester.element(find.byType(MiniMap)))!;

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

    // Driver / vehicle counters.
    expect(
      find.text(
        '${numbers.integer(kpis.driversAvailable)} · '
        '${numbers.integer(kpis.driversBusy)} · '
        '${numbers.integer(kpis.driversOffline)}',
      ),
      findsOneWidget,
    );
    expect(
      find.text(
        '${numbers.integer(kpis.vehiclesFree)} · '
        '${numbers.integer(kpis.vehiclesAssigned)} · '
        '${numbers.integer(kpis.vehiclesBreakdown)} · '
        '${numbers.integer(kpis.vehiclesMaintenance)}',
      ),
      findsOneWidget,
    );
    // Late orders card.
    expect(find.text(numbers.integer(kpis.lateOrders)), findsOneWidget);

    // Live MiniMap renders the stubbed positions.
    expect(find.byType(MiniMap), findsOneWidget);

    // Process tracker shows all 8 back-office steps.
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
    expect(find.byType(TTTimeline), findsOneWidget);
    for (final s in steps) {
      expect(find.text(s), findsOneWidget);
    }
  });
}
