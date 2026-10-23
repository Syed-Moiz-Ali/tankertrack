import 'package:core/core.dart';
import 'package:domain/domain.dart';
import 'package:fleet_ui/fleet_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:l10n/l10n.dart';

void main() {
  Future<AppLocalizations> load(Locale locale) =>
      AppLocalizations.delegate.load(locale);

  group('status labels (zero raw strings in UI)', () {
    test('typed overloads cover every enum value', () async {
      final en = await load(const Locale('en'));
      final ar = await load(const Locale('ar'));
      for (final s in OrderStatus.values) {
        expect(orderStatusLabel(s, en).isNotEmpty, isTrue, reason: '$s');
        expect(orderStatusLabel(s, ar).isNotEmpty, isTrue, reason: '$s');
      }
      for (final s in TripStatus.values) {
        expect(tripStatusLabel(s, en).isNotEmpty, isTrue, reason: '$s');
      }
      for (final s in TaskStatus.values) {
        expect(taskStatusLabel(s, en).isNotEmpty, isTrue, reason: '$s');
      }
      for (final s in VehicleStatus.values) {
        expect(vehicleStatusLabel(s, en).isNotEmpty, isTrue, reason: '$s');
      }
      for (final s in DriverStatus.values) {
        expect(driverStatusLabel(s, en).isNotEmpty, isTrue, reason: '$s');
      }
      // Gender check: same raw, different enum → different Arabic.
      expect(orderStatusLabel(OrderStatus.assigned, ar),
          isNot(driverStatusLabel(DriverStatus.assigned, ar)));
      expect(vehicleStatusLabel(VehicleStatus.available, ar),
          isNot(driverStatusLabel(DriverStatus.available, ar)));
    });

    test('masterStatusLabel covers seed vocabularies + safe fallback',
        () async {
      final en = await load(const Locale('en'));
      expect(masterStatusLabel('onDuty', en), en.st_duty_on);
      expect(masterStatusLabel('credit_hold', en), en.st_cust_credit_hold);
      expect(masterStatusLabel('inTransit', en), en.st_vehicle_in_transit);
      expect(masterStatusLabel('bogus_future_status', en),
          'bogus_future_status');
    });

    test('roleLabel covers all roles', () async {
      final en = await load(const Locale('en'));
      for (final r in Role.values) {
        expect(roleLabel(r, en).isNotEmpty, isTrue);
      }
    });
  });
}
