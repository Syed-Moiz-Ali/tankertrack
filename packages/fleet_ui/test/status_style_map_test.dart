import 'package:domain/domain.dart';
import 'package:fleet_ui/fleet_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('every domain status maps to a display style (exhaustive)', () {
    for (final s in OrderStatus.values) {
      expect(s.style, isA<StatusStyle>(), reason: '$s');
    }
    for (final s in TripStatus.values) {
      expect(s.style, isA<StatusStyle>(), reason: '$s');
    }
    for (final s in TaskStatus.values) {
      expect(s.style, isA<StatusStyle>(), reason: '$s');
    }
    for (final s in VehicleStatus.values) {
      expect(s.style, isA<StatusStyle>(), reason: '$s');
    }
    for (final s in DriverStatus.values) {
      expect(s.style, isA<StatusStyle>(), reason: '$s');
    }
    // Spot checks against the image color legend.
    expect(OrderStatus.completed.style, StatusStyle.completed);
    expect(TripStatus.breakdown.style, StatusStyle.critical);
    expect(VehicleStatus.loading.style, StatusStyle.loading);
    expect(statusStyleForKey('critical'), StatusStyle.critical);
    expect(statusStyleForKey('unknown'), StatusStyle.offline);
  });
}
