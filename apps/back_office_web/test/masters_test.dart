import 'package:back_office_web/src/data_providers.dart';
import 'package:back_office_web/src/features/customers/customer_screens.dart';
import 'package:back_office_web/src/features/depots/depot_screens.dart';
import 'package:back_office_web/src/features/drivers/driver_screens.dart';
import 'package:back_office_web/src/features/products/product_screens.dart';
import 'package:back_office_web/src/features/vehicles/vehicle_screens.dart';
import 'package:back_office_web/src/ui/demo_state.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:l10n/l10n.dart';
import 'package:l10n/src/gen/app_localizations_en.dart';

import 'test_helpers.dart';

void main() async {
  // Real async zone: dart:io never completes inside testWidgets (FakeAsync).
  final bundle = await loadTestBundle();
  final customers = bundle.table('customers').length;
  final drivers = bundle.table('drivers').length;
  final vehicles = bundle.table('vehicles').length;
  final depots = bundle.table('depots').length;
  final products = bundle.table('products').length;
  final l10n = AppLocalizationsEn();

  testWidgets('customer list renders all seed rows as typographic rows',
      (tester) async {
    await tester.pumpWidget(
        p1TestApp(bundle: bundle, home: const CustomerListScreen()));
    await tester.pumpAndSettle();

    expect(find.text('$customers rows'), findsOneWidget);
    expect(find.text('ABC Construction'), findsWidgets);
    expect(find.byType(TTListRow), findsWidgets);
    // Pill filters carry real counts.
    expect(find.byType(FilterChip), findsWidgets);
    // No fake "All" pill (13 §2).
    expect(find.text(l10n.mst_all), findsNothing);
  });

  testWidgets('driver + vehicle lists render rows; Cards toggle swaps cards',
      (tester) async {
    expect(drivers, greaterThanOrEqualTo(20));
    expect(vehicles, greaterThanOrEqualTo(20));

    await tester.pumpWidget(
        p1TestApp(bundle: bundle, home: const DriverListScreen()));
    await tester.pumpAndSettle();
    expect(find.text('$drivers rows'), findsOneWidget);
    expect(find.byType(TTListRow), findsWidgets);

    await tester.tap(find.text(l10n.list_cards));
    await tester.pumpAndSettle();
    expect(find.byType(TTEntityCard), findsWidgets);

    await tester.pumpWidget(
        p1TestApp(bundle: bundle, home: const VehicleListScreen()));
    await tester.pumpAndSettle();
    expect(find.text('$vehicles rows'), findsOneWidget);
    expect(find.byType(TTListRow), findsWidgets);
  });

  testWidgets('depot + product lists render every seed row', (tester) async {
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

  testWidgets('pill filter narrows to its status', (tester) async {
    await tester.pumpWidget(
        p1TestApp(bundle: bundle, home: const VehicleListScreen()));
    await tester.pumpAndSettle();
    expect(find.text('$vehicles rows'), findsOneWidget);

    // First status pill filters; tapping again restores the full list.
    final pill = find.byType(FilterChip).first;
    await tester.tap(pill);
    await tester.pumpAndSettle();
    expect(find.text('$vehicles rows'), findsNothing);
    await tester.tap(pill);
    await tester.pumpAndSettle();
    expect(find.text('$vehicles rows'), findsOneWidget);
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

    // Open the create form via the header action.
    await tester.tap(find.text('Create'));
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

  testWidgets('demo switcher forces bo15 empty state', (tester) async {
    final container = ProviderContainer(
      overrides: [seedBundleProvider.overrideWith((ref) => bundle)],
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
          home: const VehicleListScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    container.read(demoScreenStateProvider('bo15').notifier).state =
        DemoScreenState.empty;
    await tester.pumpAndSettle();
    expect(find.text(l10n.bo15_empty), findsOneWidget);
  });
}
