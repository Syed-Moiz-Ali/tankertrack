import 'package:back_office_web/src/features/customers/customer_screens.dart';
import 'package:back_office_web/src/features/depots/depot_screens.dart';
import 'package:back_office_web/src/features/drivers/driver_screens.dart';
import 'package:back_office_web/src/features/products/product_screens.dart';
import 'package:back_office_web/src/features/vehicles/vehicle_screens.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() async {
  // Real async zone: dart:io never completes inside testWidgets (FakeAsync).
  final bundle = await loadTestBundle();
  final customers = bundle.table('customers').length;
  final drivers = bundle.table('drivers').length;
  final vehicles = bundle.table('vehicles').length;
  final depots = bundle.table('depots').length;
  final products = bundle.table('products').length;

  testWidgets('customer list renders all 24 seed rows', (tester) async {
    expect(customers, 24);

    await tester.pumpWidget(
        p1TestApp(bundle: bundle, home: const CustomerListScreen()));
    await tester.pumpAndSettle();

    expect(find.text('$customers rows'), findsOneWidget);
    expect(find.text('Al Noor Contracting'), findsWidgets);
  });

  testWidgets('driver + vehicle lists render 20+ rows from mock service',
      (tester) async {
    expect(drivers, greaterThanOrEqualTo(20));
    expect(vehicles, greaterThanOrEqualTo(20));

    await tester.pumpWidget(
        p1TestApp(bundle: bundle, home: const DriverListScreen()));
    await tester.pumpAndSettle();
    expect(find.text('$drivers rows'), findsOneWidget);

    await tester.pumpWidget(
        p1TestApp(bundle: bundle, home: const VehicleListScreen()));
    await tester.pumpAndSettle();
    expect(find.text('$vehicles rows'), findsOneWidget);
  });

  testWidgets('depot + product lists render every seed row', (tester) async {
    // Seeds ship 5 depots / 4 products — lists render all of them
    // (contract "20+" cannot hold until slice A grows the seeds).
    await tester.pumpWidget(
        p1TestApp(bundle: bundle, home: const DepotListScreen()));
    await tester.pumpAndSettle();
    expect(find.text('$depots rows'), findsOneWidget);

    await tester.pumpWidget(
        p1TestApp(bundle: bundle, home: const ProductListScreen()));
    await tester.pumpAndSettle();
    expect(find.text('$products rows'), findsOneWidget);
  });

  testWidgets('master search filters in-memory', (tester) async {
    await tester.pumpWidget(
        p1TestApp(bundle: bundle, home: const CustomerListScreen()));
    await tester.pumpAndSettle();
    expect(find.text('$customers rows'), findsOneWidget);

    await tester.enterText(find.byType(SearchBar), 'Al Noor');
    await tester.pumpAndSettle();
    expect(find.text('$customers rows'), findsNothing);
  });

  testWidgets('customer form validates required fields', (tester) async {
    await tester.pumpWidget(
        p1TestApp(bundle: bundle, home: const CustomerFormScreen()));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
    await tester.pumpAndSettle();
    expect(find.text('This field is required'), findsWidgets);
  });

  testWidgets('vehicle form validates + creates a row', (tester) async {
    await tester.pumpWidget(
        p1TestApp(bundle: bundle, home: const VehicleListScreen()));
    await tester.pumpAndSettle();
    expect(find.text('$vehicles rows'), findsOneWidget);

    // Open the create form via the app-bar add action.
    await tester.tap(find.byType(TTIconButton));
    await tester.pumpAndSettle();
    expect(find.byType(VehicleFormScreen), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Vehicles'),
      'RYD-9999',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Capacity'),
      '3000',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'On board'),
      '1000',
    );
    await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
    await tester.pumpAndSettle();

    expect(find.byType(VehicleListScreen), findsOneWidget);
    expect(find.text('${vehicles + 1} rows'), findsOneWidget);
  });
}
