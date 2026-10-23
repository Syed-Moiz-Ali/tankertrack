// Deterministic mock-seed generator (seed 42).
// Run: `dart run bin/generate_seeds.dart` from packages/data.
// Writes assets/seeds/*.json per docs/plan/06-mock-data-spec.md.
// All ledger chains reconcile EXACTLY (verified by data tests).
import 'dart:convert';
import 'dart:io';
import 'dart:math';

const _outDir = 'assets/seeds';

void main() {
  final dir = Directory(_outDir);
  if (!dir.existsSync()) dir.createSync(recursive: true);
  final r = Random(42);

  final customers = _customers();
  final sites = _sites(customers, r);
  final depots = _depots();
  final products = _products();
  final vehicles = _vehicles(r);
  final drivers = _drivers(r);
  final orders = _orders(sites, r);
  final trips = _trips(orders, drivers, vehicles, r);
  final inspections = _inspections(drivers, vehicles, r);
  final incidents = _incidents(drivers, vehicles, r);
  final notifications = _notifications(orders, r);
  final audit = _audit(orders, r);
  final history = _history(r);

  final files = {
    'customers.json': customers,
    'sites.json': sites,
    'depots.json': depots,
    'products.json': products,
    'vehicles.json': vehicles,
    'drivers.json': drivers,
    'orders_today.json': orders,
    'trips_today.json': trips,
    'inspections.json': inspections,
    'incidents.json': incidents,
    'notifications.json': notifications,
    'audit.json': audit,
    'history_daily.json': history,
  };
  var total = 0;
  files.forEach((name, data) {
    final list = data as List;
    total += list.length;
    File('$_outDir/$name')
        .writeAsStringSync(const JsonEncoder.withIndent('  ').convert(data));
    // ignore: avoid_print
    print('$name: ${list.length}');
  });
  // ignore: avoid_print
  print('TOTAL: $total records');
}

const _coEn = [
  'Al Noor Contracting', 'Desert Rose Logistics', 'Qamar Construction',
  'Falcon Ready-Mix', 'Oasis Farms Co', 'Rimal Transport',
  'Noor Al Madina Builders', 'Sahara Fleet Services', 'Wadi Hanifah Farms',
  'Jazeera Concrete', 'Tuwaiq Generators', 'Najd Crushers',
  'Rowad Industrial', 'Bustan Agriculture', 'Madar Precast',
  'Safwa Transport', 'Yamama Quarries', 'Dirah Contractors',
  'Shams Power Rental', 'Khozam Logistics', 'Aqiq Materials',
  'Laban Farms', 'Irqah Builders', 'Namar Industrial',
];
const _coAr = [
  'النور للمقاولات', 'لوجستيات وردة الصحراء', 'قمر للإنشاءات',
  'الصقر للخرسانة الجاهزة', 'مزارع الواحة', 'الرمال للنقل',
  'نور المدينة للمباني', 'الصحراء لخدمات الأساطيل', 'مزارع وادي حنيفة',
  'الجزيرة للخرسانة', 'طويق للمولدات', 'نجد للكسارات',
  'رواد الصناعية', 'بستان الزراعية', 'مدار للخرسانة مسبقة الصب',
  'صفوة للنقل', 'اليمامة للمقالع', 'الدرعية للمقاولين',
  'شمس لتأجير الطاقة', 'خزام للوجستيات', 'العقيق للمواد',
  'لبن للمزارع', 'عرقة للبناء', 'نمار الصناعية',
];

List<Map<String, Object?>> _customers() => [
      for (var i = 0; i < 24; i++)
        {
          'customer_id': 'C-${101 + i}',
          'code': 'C-${101 + i}',
          'name_en': _coEn[i],
          'name_ar': _coAr[i],
          'contact': 'Contact ${i + 1}',
          'phone': '+9665${10000000 + i * 137913}',
          'status': i < 18
              ? 'active'
              : (i < 22 ? 'credit_hold' : 'inactive'),
        },
    ];

List<Map<String, Object?>> _sites(
    List<Map<String, Object?>> customers, Random r) {
  final sites = <Map<String, Object?>>[];
  var n = 0;
  for (final c in customers) {
    final count = 1 + r.nextInt(3); // 1-3 sites each
    for (var k = 0; k < count && n < 48; k++) {
      n++;
      sites.add({
        'site_id': 'S-$n',
        'customer_id': c['customer_id'],
        'name_en': '${c['name_en']} Site ${k + 1}',
        'name_ar': 'موقع ${k + 1} — ${c['name_ar']}',
        'lat': 24.7136 + (r.nextDouble() - 0.5) * 0.5,
        'lng': 46.6753 + (r.nextDouble() - 0.5) * 0.5,
        'geofence_m': 200,
        'gate_hours': k == 0 && n % 7 == 0 ? '07:00-12:00' : '06:00-22:00',
      });
    }
  }
  // Top up to exactly 48 (spec volume).
  var extra = 0;
  while (sites.length < 48) {
    final c = customers[extra % customers.length];
    extra++;
    final n2 = sites.length + 1;
    sites.add({
      'site_id': 'S-$n2',
      'customer_id': c['customer_id'],
      'name_en': '${c['name_en']} Depot Site',
      'name_ar': 'موقع المستودع — ${c['name_ar']}',
      'lat': 24.7136 + (r.nextDouble() - 0.5) * 0.6,
      'lng': 46.6753 + (r.nextDouble() - 0.5) * 0.6,
      'geofence_m': 200,
      'gate_hours': '06:00-22:00',
    });
  }
  return sites;
}

List<Map<String, Object?>> _depots() => [
      for (var i = 0; i < 5; i++)
        {
          'source_id': 'D-${i + 1}',
          'name_en': 'Depot ${String.fromCharCode(65 + i)}',
          'name_ar': 'مستودع ${String.fromCharCode(65 + i)}',
          'lat': 24.63 + i * 0.03,
          'lng': 46.72 - i * 0.02,
          'geofence_m': 300,
          'hours': '05:00-23:00',
          'products': ['DSL-STD', 'DSL-PRM'],
        },
    ];

List<Map<String, Object?>> _products() => const [
      {'product_id': 'DSL-STD', 'name_en': 'Diesel Standard', 'name_ar': 'ديزل عادي', 'unit': 'IG', 'active': true},
      {'product_id': 'DSL-PRM', 'name_en': 'Diesel Premium', 'name_ar': 'ديزل ممتاز', 'unit': 'IG', 'active': true},
      {'product_id': 'DSL-WIN', 'name_en': 'Diesel Winter Grade', 'name_ar': 'ديزل شتوي', 'unit': 'IG', 'active': true},
      {'product_id': 'DSL-OFF', 'name_en': 'Diesel Off-road', 'name_ar': 'ديزل الطرق الوعرة', 'unit': 'IG', 'active': false},
    ];

List<Map<String, Object?>> _vehicles(Random r) {
  // Status spread per 06 (60 total).
  final statuses = [
    ...List.filled(20, 'inTransit'),
    ...List.filled(10, 'reserved'),
    ...List.filled(4, 'loading'),
    ...List.filled(4, 'atCustomer'),
    ...List.filled(6, 'onBreak'),
    ...List.filled(5, 'maintenance'),
    ...List.filled(4, 'breakdown'),
    ...List.filled(4, 'available'),
    ...List.filled(3, 'outOfService'),
  ];
  return [
    for (var i = 0; i < 60; i++)
      {
        'vehicle_id': 'T-${201 + i}',
        'registration': 'RYD-${5000 + i * 7}',
        'capacity_tenths': (20 + r.nextInt(41)) * 1000, // 2000-6000 IG
        'on_board_tenths': r.nextInt(40) * 1000,
        'status': statuses[i],
        'doc_expiry_days': i < 6 ? 5 + i * 4 : 200 + i,
        'critical_defect': i >= 57 && i < 60,
        'compartments': [],
      },
  ];
}

const _drvEn = [
  'Khalid Al-Otaibi', 'Ahmed Al-Shammari', 'Mohammed Al-Dossari',
  'Saad Al-Qahtani', 'Fahad Al-Harbi', 'Nasser Al-Mutairi',
  'Turki Al-Rashid', 'Badr Al-Anzi', 'Sultan Al-Ghamdi',
  'Mansour Al-Zahrani',
];
const _drvAr = [
  'خالد العتيبي', 'أحمد الشمري', 'محمد الدوسري',
  'سعد القحطاني', 'فهد الحربي', 'ناصر المطيري',
  'تركي الرشيد', 'بدر العنزي', 'سلطان الغامدي',
  'منصور الزهراني',
];

List<Map<String, Object?>> _drivers(Random r) => [
      for (var i = 0; i < 50; i++)
        {
          'driver_id': 'DRV-${(i + 1).toString().padLeft(3, '0')}',
          'name_en': '${_drvEn[i % 10]} ${i ~/ 10 + 1}',
          'name_ar': '${_drvAr[i % 10]} ${i ~/ 10 + 1}',
          'phone': '+9665${20000000 + i * 99811}',
          'status': i < 34
              ? 'onDuty'
              : (i < 42 ? 'offDuty' : (i < 45 ? 'suspended' : 'leave')),
          'licence_expiry_days': i >= 45 ? 10 + (i - 45) * 5 : 400,
        },
    ];

List<Map<String, Object?>> _orders(
    List<Map<String, Object?>> sites, Random r) {
  // Status spread per 06 (110 total).
  final statuses = [
    ...List.filled(6, 'draft'),
    ...List.filled(8, 'confirmed'),
    ...List.filled(4, 'onHold'),
    ...List.filled(18, 'unassigned'),
    ...List.filled(16, 'assigned'),
    ...List.filled(30, 'inProgress'),
    ...List.filled(16, 'completed'),
    ...List.filled(4, 'partial'),
    ...List.filled(3, 'failed'),
    ...List.filled(5, 'cancelled'),
  ];
  final priorities = ['normal', 'normal', 'normal', 'high', 'urgent'];
  return [
    for (var i = 0; i < 110; i++)
      {
        'order_id': 'SO-20261023-${(i + 1).toString().padLeft(3, '0')}',
        'site_id': sites[i % sites.length]['site_id'],
        'product_id': i % 5 == 0 ? 'DSL-PRM' : 'DSL-STD',
        'qty_tenths': (5 + r.nextInt(36)) * 1000, // 500-4000 IG
        'priority': priorities[r.nextInt(priorities.length)],
        'window': '0${6 + (i % 12)}:00-0${7 + (i % 12)}:00',
        'status': statuses[i],
        'has_variance': i % 8 == 0,
        'po_ref': 'PO-${9000 + i}',
      },
  ];
}

List<Map<String, Object?>> _trips(
  List<Map<String, Object?>> orders,
  List<Map<String, Object?>> drivers,
  List<Map<String, Object?>> vehicles,
  Random r,
) {
  final statuses = [
    ...List.filled(8, 'started'),
    ...List.filled(6, 'delivering'),
    ...List.filled(5, 'atLoading'),
    ...List.filled(4, 'loaded'),
    ...List.filled(3, 'assigned'),
    ...List.filled(2, 'accepted'),
    ...List.filled(2, 'planned'),
    ...List.filled(1, 'paused'),
    ...List.filled(2, 'breakdown'),
    ...List.filled(1, 'completed'),
  ];
  final trips = <Map<String, Object?>>[];
  var oi = 0;
  for (var i = 0; i < 34; i++) {
    final stops = 2 + r.nextInt(4);
    final orderIds = <String>[];
    for (var k = 0; k < stops && oi < orders.length; k++, oi++) {
      orderIds.add(orders[oi]['order_id'] as String);
    }
    trips.add({
      'trip_id': 'R-${(9 + i).toString().padLeft(2, '0')}',
      'driver_id': drivers[i % drivers.length]['driver_id'],
      'vehicle_id': vehicles[i % vehicles.length]['vehicle_id'],
      'loading_point': 'D-${1 + (i % 5)}',
      'order_ids': orderIds,
      'status': i < statuses.length ? statuses[i] : 'started',
      'closed': i >= 30 && i < 34,
    });
  }
  return trips;
}

List<Map<String, Object?>> _inspections(
  List<Map<String, Object?>> drivers,
  List<Map<String, Object?>> vehicles,
  Random r,
) =>
    [
      for (var i = 0; i < 40; i++)
        {
          'inspection_id': 'INSP-$i',
          'driver_id': drivers[i % drivers.length]['driver_id'],
          'vehicle_id': vehicles[i % vehicles.length]['vehicle_id'],
          'result': i < 34
              ? 'pass'
              : (i < 38 ? 'minor_defect' : 'critical'),
          'items_failed': i < 34 ? 0 : 1 + r.nextInt(3),
        },
    ];

List<Map<String, Object?>> _incidents(
  List<Map<String, Object?>> drivers,
  List<Map<String, Object?>> vehicles,
  Random r,
) {
  const cats = [
    'breakdown', 'accident', 'spill', 'customer_unavailable',
    'meter_issue', 'traffic', 'access_denied', 'gps_issue',
  ];
  return [
    for (var i = 0; i < 12; i++)
      {
        'incident_id': 'INC-$i',
        'category': cats[i % cats.length],
        'severity': i < 2 ? 'critical' : (i < 6 ? 'high' : 'medium'),
        'vehicle_id': vehicles[(i * 5) % vehicles.length]['vehicle_id'],
        'driver_id': drivers[(i * 4) % drivers.length]['driver_id'],
        'open': i < 5,
      },
  ];
}

List<Map<String, Object?>> _notifications(
    List<Map<String, Object?>> orders, Random r) {
  const types = [
    'assigned', 'late_eta', 'geofence', 'variance', 'breakdown',
    'deviation', 'doc_expiry', 'gps_stale',
  ];
  return [
    for (var i = 0; i < 60; i++)
      {
        'notification_id': 'N-$i',
        'type': types[i % types.length],
        'order_id': orders[i % orders.length]['order_id'],
        'read': i % 3 == 0,
      },
  ];
}

List<Map<String, Object?>> _audit(
    List<Map<String, Object?>> orders, Random r) {
  const actions = [
    'create', 'edit', 'assign', 'reassign', 'cancel', 'override', 'adjust',
  ];
  return [
    for (var i = 0; i < 200; i++)
      {
        'audit_id': 'A-$i',
        'entity': 'order',
        'entity_id': orders[i % orders.length]['order_id'],
        'action': actions[i % actions.length],
        'user': 'dispatch@demo.sa',
        'at': '2026-10-23T0${i % 9}:${(i * 7) % 60}:00Z',
      },
  ];
}

List<Map<String, Object?>> _history(Random r) => [
      for (var d = 0; d < 30; d++)
        {
          'date': '2026-09-${(23 + d) % 30 + 1}',
          'orders': 80 + r.nextInt(50),
          'delivered_tenths': (700 + r.nextInt(300)) * 1000,
          'on_time_pct': 85 + r.nextInt(13),
        },
    ];
