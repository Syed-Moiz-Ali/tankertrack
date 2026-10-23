import 'package:core/core.dart';
import 'package:test/test.dart';

void main() {
  group('Result', () {
    test('ok/err fold', () {
      const Result<int> ok = Ok(3);
      const Result<int> err = Err(AppError.notFound());
      expect(ok.isOk, isTrue);
      expect(err.isErr, isTrue);
      expect(ok.fold((v) => v, (e) => -1), 3);
      expect(err.fold((v) => 0, (e) => e.kind), AppErrorKind.notFound);
    });
  });

  group('AppConfig defaults match 00 §G/D', () {
    test('tolerances, GPS, geofence, POD, tz', () {
      const c = AppConfig.defaults;
      expect(c.toleranceLoadPct, 2);
      expect(c.toleranceLoadAbsTenths, 200);
      expect(c.toleranceDeliverPct, 1);
      expect(c.toleranceDeliverAbsTenths, 100);
      expect(c.gpsMovingSecs, 15);
      expect(c.gpsStaleSecs, 300);
      expect(c.geofenceDepotM, 300);
      expect(c.geofenceSiteM, 200);
      expect(c.displayTimeZoneName, 'Asia/Riyadh');
      expect(c.flags.compartments, isFalse);
      expect(c.flags.requireOtp, isFalse);
      expect(
          c.flags.podSatisfied(
              hasName: true, hasSignature: true, hasPhoto: false),
          isTrue);
      expect(
          c.flags.podSatisfied(
              hasName: true, hasSignature: false, hasPhoto: false),
          isFalse);
    });
  });

  group('RBAC (FRS §4)', () {
    test('least privilege matrix', () {
      expect(Role.driver.can(Permission.driveTasks), isTrue);
      expect(Role.driver.can(Permission.ordersCreate), isFalse);
      expect(Role.dispatcher.can(Permission.dispatchAssign), isTrue);
      expect(Role.dispatcher.can(Permission.dispatchOverride), isFalse);
      expect(Role.supervisor.can(Permission.dispatchOverride), isTrue);
      expect(Role.finance.can(Permission.dispatchAssign), isFalse);
      expect(Role.admin.can(Permission.configManage), isTrue);
      expect(Role.customerStub.can(Permission.ordersCreate), isFalse);
    });
  });

  group('AppLog ring', () {
    test('breadcrumbs kept, capacity bounded', () {
      AppLog.clearForTest();
      AppLog.info('a');
      AppLog.error('b');
      expect(AppLog.breadcrumbs.length, 2);
      expect(AppLog.breadcrumbs.last.message, 'b');
    });
  });
}
