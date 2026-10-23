import 'package:back_office_web/src/data_providers.dart';
import 'package:back_office_web/src/features/customers/customer_screens.dart';
import 'package:back_office_web/src/features/dashboard/dashboard_screen.dart';
import 'package:back_office_web/src/features/depots/depot_screens.dart';
import 'package:back_office_web/src/features/drivers/driver_screens.dart';
import 'package:back_office_web/src/features/products/product_screens.dart';
import 'package:back_office_web/src/features/tower/tower_screen.dart';
import 'package:back_office_web/src/features/vehicles/vehicle_screens.dart';
import 'package:back_office_web/src/providers.dart';
import 'package:core/core.dart';
import 'package:data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

/// Enum-leak guard (contracts §8): every user-visible string on the
/// dashboard, control tower and all master lists + details must be localized.
/// Fails on raw enum names (order/trip/task/vehicle/driver statuses) and raw
/// lowercase role names.
final _leakPattern = RegExp(
  r'\b(onHold|inProgress|unassigned|credit_hold|inTransit|atCustomer|'
  r'onBreak|outOfService|completedDay|enRoute|atLoading|delivering|'
  r'dispatcher|driver|admin|sales|supervisor|finance|fleetController|'
  r'customerStub)\b',
);

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
    ];

Set<String> _visibleStrings(WidgetTester tester) {
  final out = <String>{};
  for (final element in tester.widgetList(find.byType(Text))) {
    final text = element as Text;
    final value = text.data ?? text.textSpan?.toPlainText();
    if (value != null && value.isNotEmpty) out.add(value);
  }
  for (final element in tester.widgetList(find.byType(RichText))) {
    final value = (element as RichText).text.toPlainText();
    if (value.isNotEmpty) out.add(value);
  }
  return out;
}

void main() async {
  // Real async zone: dart:io never completes inside testWidgets (FakeAsync).
  final bundle = await loadTestBundle();
  final vehicleId = bundle.table('vehicles').first['vehicle_id']! as String;
  final driverId = bundle.table('drivers').first['driver_id']! as String;
  final customerId = bundle.table('customers').first['customer_id']! as String;
  final depotId = bundle.table('depots').first['source_id']! as String;

  List<Override> live() => [
        sessionProvider.overrideWith(
          (_) => const Session(
            userId: 'dispatch@demo.sa',
            displayName: 'Sara Al-Qahtani',
            role: Role.dispatcher,
            driverId: null,
          ),
        ),
        positionsProvider.overrideWith((ref) => Stream.value(_live())),
      ];

  Future<void> check(WidgetTester tester, Widget home) async {
    await tester.pumpWidget(
      p1TestApp(bundle: bundle, home: home, overrides: live()),
    );
    await tester.pumpAndSettle();
    final leaks = _visibleStrings(tester)
        .where((s) => _leakPattern.hasMatch(s))
        .toList();
    expect(leaks, isEmpty, reason: 'enum/role leak in ${home.runtimeType}');
  }

  testWidgets('no enum leak: dashboard + tower', (tester) async {
    await check(tester, const DashboardScreen());
    await check(tester, const ControlTowerScreen());
  });

  testWidgets('no enum leak: master lists', (tester) async {
    await check(tester, const CustomerListScreen());
    await check(tester, const DepotListScreen());
    await check(tester, const ProductListScreen());
    await check(tester, const DriverListScreen());
    await check(tester, const VehicleListScreen());
  });

  testWidgets('no enum leak: master details', (tester) async {
    await check(tester, CustomerDetailScreen(customerId: customerId));
    await check(tester, DepotDetailScreen(depotId: depotId));
    await check(tester, DriverDetailScreen(driverId: driverId));
    await check(tester, VehicleDetailScreen(vehicleId: vehicleId));
  });
}
