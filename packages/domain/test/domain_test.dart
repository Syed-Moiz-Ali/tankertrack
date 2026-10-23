import 'package:domain/domain.dart';
import 'package:test/test.dart';

void main() {
  group('QuantityIG (integer tenths, exact math)', () {
    test('S1 hero numbers: 4000.0 - 1500.0 = 2500.0 exactly', () {
      const loaded = QuantityIG(40000);
      const delivered = QuantityIG(15000);
      expect((loaded - delivered).tenthGallons, 25000);
      expect((loaded - delivered).asIg, 2500.0);
    });

    test('arithmetic + comparison', () {
      expect((const QuantityIG(100) + const QuantityIG(5)).tenthGallons, 105);
      expect(QuantityIG.fromIg(4.04).tenthGallons, 40);
      expect(const QuantityIG(10) > const QuantityIG(9), isTrue);
      expect(const QuantityIG(10) >= const QuantityIG(10), isTrue);
      expect(const QuantityIG(9) < const QuantityIG(10), isTrue);
      expect(QuantityIG.zero.isZero, isTrue);
      expect(const QuantityIG(-1).isNegative, isTrue);
      expect(const QuantityIG(0) == QuantityIG.zero, isTrue);
    });

    test('litres conversion is display-only', () {
      expect(const QuantityIG(40000).toLitres(4.54609),
          closeTo(18184.36, 0.01));
    });
  });

  group('StateMachine: every declared edge allowed, terminals closed', () {
    void checkAll<S>(StateMachine<S> m) {
      for (final from in m.allowed.keys) {
        for (final to in m.allowed[from]!) {
          expect(m.canTransition(from, to), isTrue,
              reason: '$from -> $to must be allowed');
          expect(m.transition(from, to).isOk, isTrue);
        }
      }
      for (final t in m.terminals) {
        for (final s in m.allowed.keys) {
          expect(m.canTransition(t, s), isFalse,
              reason: 'terminal $t must have no exits');
        }
        expect(m.transition(t, t).isErr, isTrue);
      }
    }

    test('order (10 states)', () {
      checkAll(StatusMachines.order);
      expect(StatusMachines.order.terminals,
          {OrderStatus.completed, OrderStatus.cancelled});
      // Key guards.
      expect(
          StatusMachines.order
              .canTransition(OrderStatus.draft, OrderStatus.completed),
          isFalse);
      expect(
          StatusMachines.order
              .canTransition(OrderStatus.failed, OrderStatus.unassigned),
          isTrue); // replan path
      expect(
          StatusMachines.order
              .canTransition(OrderStatus.partial, OrderStatus.completed),
          isTrue); // remainder delivered
    });

    test('trip (11 states, closed locks)', () {
      checkAll(StatusMachines.trip);
      expect(StatusMachines.trip.terminals, {TripStatus.closed});
      expect(
          StatusMachines.trip
              .canTransition(TripStatus.completed, TripStatus.started),
          isFalse);
      expect(
          StatusMachines.trip
              .canTransition(TripStatus.breakdown, TripStatus.started),
          isTrue); // rescue/resume
    });

    test('task (9 states)', () {
      checkAll(StatusMachines.task);
      expect(
          StatusMachines.task.canTransition(
              TaskStatus.pending, TaskStatus.completed),
          isFalse); // must flow through execution
    });

    test('vehicle (9 states)', () {
      checkAll(StatusMachines.vehicle);
      expect(
          StatusMachines.vehicle.canTransition(
              VehicleStatus.maintenance, VehicleStatus.loading),
          isFalse); // must return to available first
    });

    test('driver (9 states)', () {
      checkAll(StatusMachines.driver);
      expect(
          StatusMachines.driver.canTransition(
              DriverStatus.offline, DriverStatus.driving),
          isFalse); // must go available first
    });

    test('illegal transition returns Err with details', () {
      final r = StatusMachines.order
          .transition(OrderStatus.draft, OrderStatus.completed);
      expect(r.isErr, isTrue);
      expect(r.error.details, contains('from'));
    });
  });

  group('DerivedStatus aliases (C1/C3)', () {
    test('scheduled/delivered aliases are flag-gated projections', () {
      expect(
          DerivedStatus.orderShowsScheduled(OrderStatus.assigned,
              hasPlanDate: true),
          isTrue);
      expect(
          DerivedStatus.orderShowsScheduled(OrderStatus.unassigned,
              hasPlanDate: true),
          isFalse);
      expect(
          DerivedStatus.orderShowsDelivered(OrderStatus.completed,
              singleDrop: true),
          isTrue);
    });

    test('§6 execution phases derive from trip/task', () {
      String? phase(TripStatus? t, TaskStatus? k) =>
          DerivedStatus.orderExecutionPhase(
              order: OrderStatus.inProgress, trip: t, task: k);
      expect(phase(null, TaskStatus.enRoute), 'en_route_loading');
      expect(phase(null, TaskStatus.arrived), 'arrived');
      expect(phase(TripStatus.atLoading, TaskStatus.started), 'loading');
      expect(phase(TripStatus.delivering, TaskStatus.started), 'unloading');
      expect(phase(TripStatus.loaded, null), 'loaded');
      expect(phase(TripStatus.delivering, null), 'en_route_customer');
      expect(
          DerivedStatus.orderExecutionPhase(
              order: OrderStatus.assigned, trip: null, task: null),
          isNull);
    });
  });

  group('LedgerRule (FRS §14)', () {
    test('S1 day reconciles exactly', () {
      final closing = LedgerRule.closing(
        opening: QuantityIG.zero,
        loads: const [QuantityIG(40000), QuantityIG(30000)],
        deliveries: const [QuantityIG(15000), QuantityIG(20000)],
      );
      expect(closing.tenthGallons, 35000);
    });

    test('returns + adjustments', () {
      final closing = LedgerRule.closing(
        opening: const QuantityIG(5000),
        loads: const [QuantityIG(40000)],
        deliveries: const [QuantityIG(15000)],
        returns: const [QuantityIG(2000)],
        adjustments: const [QuantityIG(-500)],
      );
      expect(closing.tenthGallons, 27500);
    });

    test('delivery within balance ok; over balance blocked w/o override', () {
      final ok = LedgerRule.checkDelivery(
        onBoard: const QuantityIG(25000),
        requested: const QuantityIG(15000),
        supervisorOverride: false,
      );
      expect(ok.isOk, isTrue);
      expect(ok.value.tenthGallons, 10000);

      final blocked = LedgerRule.checkDelivery(
        onBoard: const QuantityIG(25000),
        requested: const QuantityIG(30000),
        supervisorOverride: false,
      );
      expect(blocked.isErr, isTrue);

      final overridden = LedgerRule.checkDelivery(
        onBoard: const QuantityIG(25000),
        requested: const QuantityIG(30000),
        supervisorOverride: true,
      );
      expect(overridden.isOk, isTrue);
    });

    test('variance tiers (S3: -3% on 2000 needs approval path)', () {
      // planned 2000.0 (20000), actual 1940.0 (19400): diff 600 tenths.
      // tol = max(1% of 20000 = 200, 100) = 200; 600 > 400 → approvalRequired.
      expect(
          LedgerRule.variance(
            planned: const QuantityIG(20000),
            actual: const QuantityIG(19400),
            tolerancePct: 1,
            toleranceAbsTenths: 100,
          ),
          VarianceDisposition.approvalRequired);
      // small variance within tolerance.
      expect(
          LedgerRule.variance(
            planned: const QuantityIG(20000),
            actual: const QuantityIG(19900),
            tolerancePct: 1,
            toleranceAbsTenths: 100,
          ),
          VarianceDisposition.withinTolerance);
      // mid variance → reason required.
      expect(
          LedgerRule.variance(
            planned: const QuantityIG(20000),
            actual: const QuantityIG(19650),
            tolerancePct: 1,
            toleranceAbsTenths: 100,
          ),
          VarianceDisposition.reasonRequired);
      // exact → within.
      expect(
          LedgerRule.variance(
            planned: const QuantityIG(20000),
            actual: const QuantityIG(20000),
            tolerancePct: 1,
            toleranceAbsTenths: 100,
          ),
          VarianceDisposition.withinTolerance);
    });
  });

  group('OrderValidator (FRS §7/§23)', () {
    test('dispatchable only with coords/product/qty/date', () {
      expect(
          OrderValidator.dispatchable(
            latitude: 24.7,
            longitude: 46.6,
            productId: 'DSL-STD',
            quantity: const QuantityIG(15000),
            requestedDate: DateTime.utc(2026, 10, 24),
          ).isOk,
          isTrue);
      final missing = OrderValidator.dispatchable(
        latitude: null,
        longitude: null,
        productId: '',
        quantity: QuantityIG.zero,
        requestedDate: null,
      );
      expect(missing.isErr, isTrue);
      expect((missing.error.details!['missing'] as List),
          containsAll(['coordinates', 'product', 'quantity', 'requestedDate']));
    });

    test('capacity + assignment blocks honor override', () {
      expect(
          OrderValidator.capacity(
            capacity: const QuantityIG(45000),
            plannedCumulative: const QuantityIG(40000),
            supervisorOverride: false,
          ).isOk,
          isTrue);
      expect(
          OrderValidator.capacity(
            capacity: const QuantityIG(45000),
            plannedCumulative: const QuantityIG(50000),
            supervisorOverride: false,
          ).isErr,
          isTrue);
      expect(
          OrderValidator.assignable(
            vehicleBlocked: true,
            driverBlocked: false,
            supervisorOverride: true,
          ).isOk,
          isTrue);
      expect(
          OrderValidator.assignable(
            vehicleBlocked: false,
            driverBlocked: true,
            supervisorOverride: false,
          ).isErr,
          isTrue);
    });
  });

  group('PodPolicy (D7)', () {
    test('default: name + (signature OR photo), OTP off', () {
      const policy = PodPolicy();
      expect(
          policy
              .satisfied(
                  hasName: true,
                  hasSignature: true,
                  hasPhoto: false,
                  hasOtp: false)
              .isOk,
          isTrue);
      expect(
          policy
              .satisfied(
                  hasName: true,
                  hasSignature: false,
                  hasPhoto: true,
                  hasOtp: false)
              .isOk,
          isTrue);
      expect(
          policy
              .satisfied(
                  hasName: false,
                  hasSignature: true,
                  hasPhoto: false,
                  hasOtp: false)
              .isErr,
          isTrue);
      expect(
          policy
              .satisfied(
                  hasName: true,
                  hasSignature: false,
                  hasPhoto: false,
                  hasOtp: false)
              .isErr,
          isTrue);
    });
  });

  group('ReasonCodes bilingual', () {
    test('defaults cover all override-family uses', () {
      expect(ReasonCodes.forUse(ReasonAppliesTo.override), isNotEmpty);
      expect(ReasonCodes.forUse(ReasonAppliesTo.reassign), isNotEmpty);
      expect(ReasonCodes.forUse(ReasonAppliesTo.variance), isNotEmpty);
      for (final r in ReasonCodes.defaults) {
        expect(r.nameEn.isNotEmpty, isTrue);
        expect(r.nameAr.isNotEmpty, isTrue);
        expect(r.label(arabic: true), r.nameAr);
        expect(r.label(arabic: false), r.nameEn);
      }
    });
  });
}
