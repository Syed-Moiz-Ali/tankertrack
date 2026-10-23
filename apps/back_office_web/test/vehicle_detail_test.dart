import 'package:back_office_web/src/features/drivers/driver_screens.dart';
import 'package:back_office_web/src/features/vehicles/vehicle_screens.dart';
import 'package:data/data.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:l10n/l10n.dart';

import 'test_helpers.dart';

void main() async {
  // Real async zone: dart:io never completes inside testWidgets (FakeAsync).
  final bundle = await loadTestBundle();
  final svc = MockMasterDataService(bundle);
  final vehicles = await svc.vehicles();
  final drivers = await svc.drivers();
  final bad = vehicles.firstWhere((e) => e.criticalDefect);
  final good = vehicles.firstWhere((e) => !e.criticalDefect);
  const bannerKind = TTBannerKind.critical;

  testWidgets('vehicle detail shows IG balance + calendar', (tester) async {
    final v = vehicles.firstWhere((e) => e.id == 'T-201');
    final qty = QuantityFmt(numbers: const NumberFmt());

    await tester.pumpWidget(
      p1TestApp(
          bundle: bundle, home: const VehicleDetailScreen(vehicleId: 'T-201')),
    );
    await tester.pumpAndSettle();
    final l10n =
        AppLocalizations.of(tester.element(find.byType(TTMonthCalendar)))!;

    expect(find.text(v.registration), findsWidgets);
    // On-board figure renders in the overview timeline and the narrow
    // sticky bottom bar.
    expect(
      find.text(qty.ig(v.onBoardTenths, l10n.unitIg)),
      findsWidgets,
    );
    // Calendar renders in the availability section.
    expect(find.byType(TTMonthCalendar), findsOneWidget);
    // R2 hero grid + narrow sticky bottom bar (800px test viewport).
    expect(find.byType(TTImageGrid), findsOneWidget);
    expect(find.byType(TTStickyBottomBar), findsOneWidget);
  });

  testWidgets('defect banner shows iff criticalDefect', (tester) async {
    await tester.pumpWidget(
      p1TestApp(bundle: bundle, home: VehicleDetailScreen(vehicleId: bad.id)),
    );
    await tester.pumpAndSettle();
    expect(find.byWidgetPredicate((w) => w is TTBanner && w.kind == bannerKind),
        findsOneWidget);

    await tester.pumpWidget(
      p1TestApp(bundle: bundle, home: VehicleDetailScreen(vehicleId: good.id)),
    );
    await tester.pumpAndSettle();
    expect(find.byWidgetPredicate((w) => w is TTBanner && w.kind == bannerKind),
        findsNothing);
  });

  testWidgets('driver detail shows licence + commitments calendar',
      (tester) async {
    final d = drivers.first;

    await tester.pumpWidget(
      p1TestApp(bundle: bundle, home: DriverDetailScreen(driverId: d.id)),
    );
    await tester.pumpAndSettle();
    final l10n =
        AppLocalizations.of(tester.element(find.byType(TTMonthCalendar)))!;

    expect(find.textContaining(d.phone), findsWidgets);
    // Licence line renders in the overview rows, the activity timeline and
    // the narrow sticky bottom bar.
    expect(
      find.textContaining('${l10n.drv_licence} ${d.licenceExpiryDays}'),
      findsWidgets,
    );
    expect(find.byType(TTMonthCalendar), findsOneWidget);
    expect(find.byType(TTAvatar), findsWidgets);
  });
}
