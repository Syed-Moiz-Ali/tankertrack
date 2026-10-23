import 'dart:async';
import 'dart:math';

/// Live position snapshot for one tanker.
class VehiclePosition {
  const VehiclePosition({
    required this.vehicleId,
    required this.latitude,
    required this.longitude,
    required this.heading,
    required this.speedKph,
    required this.status,
    required this.onBoardTenths,
    required this.updatedAt,
    this.driverName,
    this.orderId,
    this.etaMinutes,
    this.stale = false,
  });

  final String vehicleId;
  final double latitude;
  final double longitude;
  final double heading;
  final double speedKph;

  /// Display style key (fleet_ui maps domain statuses to these).
  final String status;
  final int onBoardTenths;
  final DateTime updatedAt;
  final String? driverName;
  final String? orderId;
  final int? etaMinutes;
  final bool stale;
}

/// Fleet-level event (delay, breakdown, loading, geofence…).
class FleetEvent {
  const FleetEvent({
    required this.type,
    required this.at,
    this.vehicleId,
    this.severity = 'info',
    this.detail,
  });

  final String type;
  final DateTime at;
  final String? vehicleId;
  final String severity;
  final String? detail;
}

/// Live-tracking seam: mock simulator now, WebSocket/STOMP in P11.
/// Same interface — UI never knows which.
abstract class TrackingStream {
  Stream<List<VehiclePosition>> positions();
  Stream<FleetEvent> events();
  void dispose();
}

/// Deterministic mock simulator: ≥40 tankers on waypoint corridors around
/// Riyadh, dwell at geofences, scripted delay/breakdown/loading injects.
/// onBoardTenths is a DISPLAY snapshot for demo aliveness — the simulator
/// never mutates the ledger (only driverops events do).
class MockTrackingSimulator implements TrackingStream {
  MockTrackingSimulator({int seed = 42, DateTime? origin})
      : _random = Random(seed),
        _now = origin ?? DateTime.utc(2026, 10, 23, 4, 0) {
    _spawnFleet();
  }

  final Random _random;
  DateTime _now;
  final _positions = StreamController<List<VehiclePosition>>.broadcast();
  final _events = StreamController<FleetEvent>.broadcast();
  final List<_Tanker> _fleet = [];
  Timer? _timer;
  int _tick = 0;

  static const _statuses = [
    'active',
    'active',
    'active',
    'loading',
    'unloading',
    'waiting',
    'completed',
  ];

  void _spawnFleet() {
    // Corridors: depot hub (24.63, 46.72) ↔ metro spokes.
    const hubLat = 24.63;
    const hubLng = 46.72;
    for (var i = 0; i < 42; i++) {
      final angle = _random.nextDouble() * 2 * pi;
      final dist = 0.05 + _random.nextDouble() * 0.22;
      final route = <_Wp>[
        _Wp(hubLat, hubLng),
        _Wp(hubLat + cos(angle) * dist, hubLng + sin(angle) * dist * 1.2),
        _Wp(hubLat + cos(angle + 0.6) * dist * 0.7,
            hubLng + sin(angle + 0.6) * dist),
        _Wp(hubLat, hubLng),
      ];
      _fleet.add(_Tanker(
        vehicleId: 'T-${214 + i}',
        route: route,
        leg: _random.nextInt(3),
        progress: _random.nextDouble(),
        speedKph: 30 + _random.nextDouble() * 50,
        status: _statuses[_random.nextInt(_statuses.length)],
        onBoardTenths: _random.nextInt(45) * 1000,
        driverName: 'Driver ${i + 1}',
        orderId: 'SO-${1000 + i}',
        etaMinutes: 5 + _random.nextInt(90),
      ));
    }
  }

  /// Starts the 2 s demo tick. Tests drive [step] manually instead.
  void start() {
    _timer ??= Timer.periodic(
      const Duration(seconds: 2),
      (_) => step(const Duration(seconds: 2)),
    );
  }

  /// Advances the simulation by [dt] and emits snapshots.
  void step(Duration dt) {
    _tick++;
    _now = _now.add(dt);
    final out = <VehiclePosition>[];
    for (final t in _fleet) {
      t.advance(dt, _random);
      out.add(VehiclePosition(
        vehicleId: t.vehicleId,
        latitude: t.lat,
        longitude: t.lng,
        heading: t.heading,
        speedKph: t.speedKph,
        status: t.status,
        onBoardTenths: t.onBoardTenths,
        updatedAt: _now,
        driverName: t.driverName,
        orderId: t.orderId,
        etaMinutes: t.etaMinutes,
      ));
    }
    // Scripted injects keep the demo alive: delay every ~150 ticks,
    // breakdown every ~450 ticks (tests force via [inject]).
    if (_tick % 150 == 0) _injectDelay();
    if (_tick % 450 == 0) _injectBreakdown();
    _positions.add(List.unmodifiable(out));
  }

  /// Forces a breakdown event for the control-room takeover demo (S5).
  void injectBreakdown([String? vehicleId]) => _injectBreakdown(vehicleId);

  void _injectDelay() {
    final t = _fleet[_random.nextInt(_fleet.length)];
    t.status = 'waiting';
    t.etaMinutes = (t.etaMinutes ?? 30) + 15;
    _events.add(FleetEvent(
      type: 'delay',
      at: _now,
      vehicleId: t.vehicleId,
      severity: 'warn',
      detail: 'Traffic delay, ETA +15 min',
    ));
  }

  void _injectBreakdown([String? vehicleId]) {
    final t = vehicleId == null
        ? _fleet[_random.nextInt(_fleet.length)]
        : _fleet.firstWhere((e) => e.vehicleId == vehicleId);
    t.status = 'critical';
    t.speedKph = 0;
    _events.add(FleetEvent(
      type: 'breakdown',
      at: _now,
      vehicleId: t.vehicleId,
      severity: 'critical',
      detail: 'Breakdown reported, assistance requested',
    ));
  }

  @override
  Stream<List<VehiclePosition>> positions() => _positions.stream;

  @override
  Stream<FleetEvent> events() => _events.stream;

  @override
  void dispose() {
    _timer?.cancel();
    _positions.close();
    _events.close();
  }
}

class _Wp {
  const _Wp(this.lat, this.lng);
  final double lat;
  final double lng;
}

class _Tanker {
  _Tanker({
    required this.vehicleId,
    required this.route,
    required this.leg,
    required this.progress,
    required this.speedKph,
    required this.status,
    required this.onBoardTenths,
    required this.driverName,
    required this.orderId,
    required this.etaMinutes,
  });

  final String vehicleId;
  final List<_Wp> route;
  int leg;
  double progress;
  double speedKph;
  String status;
  int onBoardTenths;
  final String? driverName;
  final String? orderId;
  int? etaMinutes;

  double get lat => _lerp(route[leg].lat, route[leg + 1].lat, progress);
  double get lng => _lerp(route[leg].lng, route[leg + 1].lng, progress);
  double get heading {
    final a = route[leg];
    final b = route[leg + 1];
    return (atan2(b.lng - a.lng, b.lat - a.lat) * 180 / pi + 360) % 360;
  }

  double _lerp(double a, double b, double t) => a + (b - a) * t;

  void advance(Duration dt, Random random) {
    if (status == 'critical') return; // broken down — stationary.
    if (status == 'loading' || status == 'unloading') {
      // Dwell, then depart with updated display balance.
      if (random.nextDouble() < dt.inSeconds / 1200) {
        final wasLoading = status == 'loading';
        status = 'active';
        if (wasLoading) onBoardTenths += 5000;
      }
      return;
    }
    const legKm = 18.0;
    final step = speedKph * dt.inSeconds / 3600 / legKm;
    progress += step;
    if (etaMinutes != null && etaMinutes! > 0) etaMinutes = etaMinutes! - 1;
    if (progress >= 1) {
      progress = 0;
      leg = (leg + 1) % (route.length - 1);
      // Arrive at a waypoint: maybe start loading/unloading.
      final roll = random.nextDouble();
      if (leg == 0) {
        status = 'loading';
      } else if (roll < 0.35) {
        status = 'unloading';
        onBoardTenths = (onBoardTenths - 5000).clamp(0, 60000);
      } else if (roll < 0.45) {
        status = 'waiting';
      } else {
        status = 'active';
      }
    }
  }
}
