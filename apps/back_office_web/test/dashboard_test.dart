import 'package:back_office_web/src/data_providers.dart';
import 'package:back_office_web/src/features/dashboard/dashboard_screen.dart';
import 'package:back_office_web/src/providers.dart';
import 'package:back_office_web/src/ui/demo_state.dart';
import 'package:core/core.dart';
import 'package:data/data.dart';
import 'package:fleet_ui/fleet_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:l10n/l10n.dart';
import 'package:l10n/src/gen/app_localizations_en.dart';

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
      userId: 'dispatch@demo.ae',
      displayName: 'Sara Al-Qahtani',
      role: Role.dispatcher,
      driverId: null,
    );

void main() async {
  // Real async zone: dart:io never completes inside testWidgets (FakeAsync).
  final bundle = await loadTestBundle();
  final svc = MockMasterDataService(bundle);
  final kpis = await svc.dashboardKpis();
  final orders = await svc.ordersToday();

  List<Override> live() => [
        sessionProvider.overrideWith((_) => _sara()),
        positionsProvider.overrideWith((ref) => Stream.value(_live())),
      ];

  testWidgets('Today renders sentence, hero map, strip and sections',
      (tester) async {
    final l10n = AppLocalizationsEn();
    final numbers = const NumberFmt();

    await tester.pumpWidget(
      p1TestApp(
        bundle: bundle,
        home: const DashboardScreen(),
        overrides: live(),
      ),
    );
    await tester.pumpAndSettle();

    // H1 + one-sentence answer under the title.
    expect(find.text(l10n.dash_title), findsOneWidget);
    var active = 0;
    for (final o in orders) {
      if (o.status == 'inProgress' ||
          o.status == 'assigned' ||
          o.status == 'partial') {
        active++;
      }
    }
    expect(
      find.text(
        l10n.dash_sentence(
          numbers.integer(active),
          numbers.integer(kpis.lateOrders),
        ),
      ),
      findsOneWidget,
    );
    // Map-led hero + floating live-ops card + 4-number strip.
    expect(find.byType(MiniMap), findsOneWidget);
    expect(find.byType(TTStatStrip), findsOneWidget);
    expect(find.text(l10n.dash_kpi_requested), findsWidgets);
    expect(find.text(l10n.dash_kpi_pending), findsWidgets);
    expect(find.text(l10n.dash_late_orders), findsWidgets);
    expect(find.text(l10n.dash_alerts), findsWidgets);
    // Sections.
    expect(find.text(l10n.dash_needs_attention), findsOneWidget);
    expect(find.text(l10n.dash_latest_activity), findsOneWidget);
    expect(find.text(l10n.dash_more_numbers), findsOneWidget);
    // Live-ops card shows the selected tanker + remaining + view.
    expect(find.text('T-214'), findsWidgets);
  });

  testWidgets('counts match seeds: chips, more numbers, activity',
      (tester) async {
    final l10n = AppLocalizationsEn();
    final numbers = const NumberFmt();
    final qty = QuantityFmt(numbers: numbers);

    await tester.pumpWidget(
      p1TestApp(
        bundle: bundle,
        home: const DashboardScreen(),
        overrides: live(),
      ),
    );
    await tester.pumpAndSettle();

    // More-numbers expander reveals the rest (13 §2: max 4 headlines).
    await tester.ensureVisible(find.text(l10n.dash_more_numbers));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.dash_more_numbers));
    await tester.pumpAndSettle();
    expect(
        find.text(qty.ig(kpis.loadedTenths, l10n.unitIg)), findsOneWidget);
    expect(
        find.text(qty.ig(kpis.deliveredTenths, l10n.unitIg)), findsOneWidget);
    // Orders-by-status chips carry every seed bucket.
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

    // Late orders headline.
    expect(find.text(numbers.integer(kpis.lateOrders)), findsWidgets);

    // Alerts + activity rows.
    final firstAlert = kpis.alerts.first;
    expect(
      find.text(alertTitle(firstAlert, l10n)),
      findsWidgets,
    );

    // MiniMap renders the stubbed positions.
    expect(find.byType(MiniMap), findsOneWidget);
  });

  testWidgets('demo switcher forces bo05 companion states', (tester) async {
    final l10n = AppLocalizationsEn();
    final container = ProviderContainer(
      overrides: [
        seedBundleProvider.overrideWith((ref) => bundle),
        // Never start the tracking simulator here: its periodic timer
        // outlives the widget tree and fails the binding's pending-timer
        // check. Live positions arrive via the positionsProvider override.
        fleetEventsProvider
            .overrideWith((ref) => const Stream<FleetEvent>.empty()),
        ...live(),
      ],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: AppTheme.build(
            surface: AppSurface.web,
            brightness: Brightness.light,
            arabic: false,
          ),
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const DashboardScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    Future<void> force(DemoScreenState forced, {bool settle = true}) async {
      container
          .read(demoScreenStateProvider('bo05').notifier)
          .state = forced;
      if (settle) {
        await tester.pumpAndSettle();
      } else {
        await tester.pump();
      }
    }

    await force(DemoScreenState.empty);
    expect(find.text(l10n.bo05_empty), findsOneWidget);

    // The loading spinner animates forever: single pump, never settle.
    await force(DemoScreenState.loading, settle: false);
    expect(find.text(l10n.bo05_loading), findsOneWidget);

    await force(DemoScreenState.error);
    expect(find.text(l10n.bo05_error), findsWidgets);

    await force(DemoScreenState.success);
    expect(find.text(l10n.bo05_success), findsOneWidget);
  });
}
