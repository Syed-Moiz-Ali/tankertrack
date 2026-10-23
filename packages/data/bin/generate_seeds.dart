// Deterministic Dubai seed generator for TankerTrack R3.
// Run: `dart run bin/generate_seeds.dart` from packages/data.
// Writes assets/seeds/*.json per docs/plan/12-figma-data-and-scenarios.md
// (Snapshot A + scenarios B/C/I/R-27/Reporting) and docs/plan/r3-contracts.md §2.
//
// Volumes: 28 drivers / 24 vehicles / 87 orders today (Snapshot A).
// Geography: Dubai cluster (~25.0-25.3N, 55.0-55.4E): Dubai Depot,
// Jebel Ali Port / Free Zone, Dubai Industrial City / Delta,
// Dubai Investment Park, ENOC terminals, E11, Al Quoz, Marina.
// Regs: "Dubai A <n>"; emails: ".ae"; product primary: Diesel 10ppm (PROD-001).
// Inspection checklist: Figma DR-04 8 items (inspectionChecklistV1).
//
// Demo clock: DEMO_NOW_UTC = 2026-10-23T06:30:00Z (10:30 GST).
// Reset-demo semantics: running this generator restores DEMO_NOW_UTC and all
// scenario fixtures to the values below; see lib/src/demo_clock.dart.
//
// Ledger math reconciles EXACTLY (verified by data tests):
//   B: 0 + 5,000 = 1,500 (ABC) + 2,000 (XYZ) + 1,500 (Delta) + 0 return.
//   R-27: 4,950 - 4,700 - 200 - 0 = 50 unexplained.
import 'dart:convert';
import 'dart:io';

const _outDir = 'assets/seeds';

// Canonical demo clock. Mirrors lib/src/demo_clock.dart `demoNowUtc`.
// GST = UTC+4, no DST. 06:30Z == 10:30 GST 23 Oct 2026 (Snapshot A).
const _demoNowUtcIso = '2026-10-23T06:30:00Z';

void main() {
  final dir = Directory(_outDir);
  if (!dir.existsSync()) dir.createSync(recursive: true);

  final customers = _customers();
  final sites = _sites();
  final depots = _depots();
  final products = _products();
  final vehicles = _vehicles();
  final drivers = _drivers();
  final orders = _orders();
  final trips = _trips();
  final inspections = _inspections();
  final incidents = _incidents();
  final notifications = _notifications();
  final audit = _audit();
  final history = _history();
  final demoMeta = _demoMeta();
  final snapshotA = _snapshotA();
  final tripB = _tripB();
  final dayC = _dayC();
  final incidentI = _incidentI();
  final exceptionR27 = _exceptionR27();
  final reportWeek = _reportWeek();
  final checklist = _inspectionChecklist();

  final files = <String, List<Object?>>{
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
    'demo_meta.json': demoMeta,
    'snapshot_a.json': snapshotA,
    'scenario_b_trip.json': tripB,
    'scenario_c_day.json': dayC,
    'scenario_i_incident.json': incidentI,
    'scenario_r27_exception.json': exceptionR27,
    'report_week.json': reportWeek,
    'inspection_checklist.json': checklist,
  };
  var total = 0;
  files.forEach((name, data) {
    total += data.length;
    File('$_outDir/$name')
        .writeAsStringSync(const JsonEncoder.withIndent('  ').convert(data));
    // ignore: avoid_print
    print('$name: ${data.length}');
  });
  // ignore: avoid_print
  print('TOTAL: $total records');
}

// ---------------------------------------------------------------- customers

List<Map<String, Object?>> _customers() => const [
      {
        'customer_id': 'CUST-0018',
        'code': 'CUST-0018',
        'name_en': 'ABC Construction',
        'name_ar': 'إيه بي سي للإنشاءات',
        'contact': 'Mohammed Saleem',
        'email': 'mohammed.saleem@abc-construction.ae',
        'phone': '+971502345678',
        'status': 'active',
      },
      {
        'customer_id': 'CUST-0021',
        'code': 'CUST-0021',
        'name_en': 'XYZ Contracting',
        'name_ar': 'إكس واي زد للمقاولات',
        'contact': 'Sara Nasser',
        'email': 'sara.nasser@xyz-contracting.ae',
        'phone': '+971505551214',
        'status': 'active',
      },
      {
        'customer_id': 'CUST-0024',
        'code': 'CUST-0024',
        'name_en': 'Delta Engineering',
        'name_ar': 'دلتا للهندسة',
        'contact': 'Omar Farouk',
        'email': 'omar.farouk@delta-eng.ae',
        'phone': '+971505553377',
        'status': 'active',
      },
      {
        'customer_id': 'CUST-0031',
        'code': 'CUST-0031',
        'name_en': 'Falcon Steel',
        'name_ar': 'فالكون للصلب',
        'contact': 'Layla Haddad',
        'email': 'layla.haddad@falconsteel.ae',
        'phone': '+971505557701',
        'status': 'active',
      },
      {
        'customer_id': 'CUST-0033',
        'code': 'CUST-0033',
        'name_en': 'Emirates Precast',
        'name_ar': 'الإمارات للخرسانة مسبقة الصب',
        'contact': 'Hassan Ali',
        'email': 'hassan.ali@emirates-precast.ae',
        'phone': '+971505558802',
        'status': 'active',
      },
      {
        'customer_id': 'CUST-0035',
        'code': 'CUST-0035',
        'name_en': 'Gulf Ready Mix',
        'name_ar': 'الخليج للخرسانة الجاهزة',
        'contact': 'Adel Karim',
        'email': 'adel.karim@gulfreadymix.ae',
        'phone': '+971505559903',
        'status': 'active',
      },
      {
        'customer_id': 'CUST-0040',
        'code': 'CUST-0040',
        'name_en': 'Marina Gate Developers',
        'name_ar': 'مارينا غيت للتطوير',
        'contact': 'Noor Al Farsi',
        'email': 'noor@marinagate.ae',
        'phone': '+971505551010',
        'status': 'active',
      },
      {
        'customer_id': 'CUST-0042',
        'code': 'CUST-0042',
        'name_en': 'Al Quoz Industrial Services',
        'name_ar': 'القوز للخدمات الصناعية',
        'contact': 'Khalid Mansour',
        'email': 'khalid@alquoz-industrial.ae',
        'phone': '+971505552020',
        'status': 'active',
      },
      {
        'customer_id': 'CUST-0044',
        'code': 'CUST-0044',
        'name_en': 'DIP Logistics Park',
        'name_ar': 'مجمع دبي للاستثمار اللوجستي',
        'contact': 'Mariam Hassan',
        'email': 'contact@dip-logistics.ae',
        'phone': '+971505553030',
        'status': 'active',
      },
      {
        'customer_id': 'CUST-0046',
        'code': 'CUST-0046',
        'name_en': 'Jebel Ali Terminal Services',
        'name_ar': 'خدمات محطة جبل علي',
        'contact': 'Yusuf Ibrahim',
        'email': 'yusuf.ibrahim@jebelali-terminals.ae',
        'phone': '+971505554040',
        'status': 'active',
      },
      {
        'customer_id': 'CUST-0048',
        'code': 'CUST-0048',
        'name_en': 'E11 Highway Contractors',
        'name_ar': 'مقاولو طريق E11',
        'contact': 'Saeed Omar',
        'email': 'saeed.omar@e11-contractors.ae',
        'phone': '+971505555050',
        'status': 'credit_hold',
      },
      {
        'customer_id': 'CUST-0050',
        'code': 'CUST-0050',
        'name_en': 'Palm Marina Concrete',
        'name_ar': 'نخلة مارينا للخرسانة',
        'contact': 'Fatima Ali',
        'email': 'fatima.ali@marina-concrete.ae',
        'phone': '+971505556060',
        'status': 'active',
      },
    ];

// -------------------------------------------------------------------- sites

List<Map<String, Object?>> _sites() => const [
      {
        'site_id': 'SITE-ABC-04',
        'customer_id': 'CUST-0018',
        'name_en': 'ABC DIC Site 04 Plot 42',
        'name_ar': 'موقع ABC في مدينة دبي الصناعية 04 قطعة 42',
        'lat': 24.8461,
        'lng': 55.0678,
        'geofence_m': 200,
        'gate_hours': '07:00-18:00',
      },
      {
        'site_id': 'SITE-XYZ-01',
        'customer_id': 'CUST-0021',
        'name_en': 'XYZ Contracting Yard DIP',
        'name_ar': 'ساحة إكس واي زد في مجمع دبي للاستثمار',
        'lat': 25.0312,
        'lng': 55.1524,
        'geofence_m': 200,
        'gate_hours': '06:00-22:00',
      },
      {
        'site_id': 'SITE-DLT-02',
        'customer_id': 'CUST-0024',
        'name_en': 'Delta Engineering Plant IC',
        'name_ar': 'مصنع دلتا في المدينة الصناعية',
        'lat': 25.0288,
        'lng': 55.1321,
        'geofence_m': 200,
        'gate_hours': '06:00-22:00',
      },
      {
        'site_id': 'SITE-FLC-01',
        'customer_id': 'CUST-0031',
        'name_en': 'Falcon Steel Jebel Ali',
        'name_ar': 'فالكون للصلب جبل علي',
        'lat': 25.0116,
        'lng': 55.0612,
        'geofence_m': 200,
        'gate_hours': '06:00-22:00',
      },
      {
        'site_id': 'SITE-EPC-01',
        'customer_id': 'CUST-0033',
        'name_en': 'Emirates Precast DIP',
        'name_ar': 'الإمارات للخرسانة مسبقة الصب',
        'lat': 25.0421,
        'lng': 55.1618,
        'geofence_m': 200,
        'gate_hours': '06:00-22:00',
      },
      {
        'site_id': 'SITE-GRM-01',
        'customer_id': 'CUST-0035',
        'name_en': 'Gulf Ready Mix Al Quoz',
        'name_ar': 'الخليج للخرسانة الجاهزة القوز',
        'lat': 25.1335,
        'lng': 55.2342,
        'geofence_m': 200,
        'gate_hours': '06:00-22:00',
      },
      {
        'site_id': 'SITE-MRN-01',
        'customer_id': 'CUST-0040',
        'name_en': 'Marina Gate Tower Site',
        'name_ar': 'موقع برج مارينا غيت',
        'lat': 25.0805,
        'lng': 55.1403,
        'geofence_m': 200,
        'gate_hours': '07:00-18:00',
      },
      {
        'site_id': 'SITE-AQZ-01',
        'customer_id': 'CUST-0042',
        'name_en': 'Al Quoz Yard 3',
        'name_ar': 'ساحة القوز 3',
        'lat': 25.1412,
        'lng': 55.2388,
        'geofence_m': 200,
        'gate_hours': '06:00-22:00',
      },
    ];

// -------------------------------------------------------------------- depots

List<Map<String, Object?>> _depots() => const [
      {
        'source_id': 'D-1',
        'name_en': 'Dubai Depot',
        'name_ar': 'مستودع دبي',
        'lat': 25.0612,
        'lng': 55.1644,
        'geofence_m': 300,
        'hours': '05:00-23:00',
        'products': ['PROD-001'],
      },
      {
        'source_id': 'D-2',
        'name_en': 'ENOC Jebel Ali Terminal',
        'name_ar': 'محطة إينوك جبل علي',
        'lat': 25.0168,
        'lng': 55.0603,
        'geofence_m': 300,
        'hours': '05:00-23:00',
        'products': ['PROD-001'],
      },
      {
        'source_id': 'D-3',
        'name_en': 'ENOC DIP Terminal',
        'name_ar': 'محطة إينوك مجمع دبي للاستثمار',
        'lat': 25.0355,
        'lng': 55.1588,
        'geofence_m': 300,
        'hours': '05:00-23:00',
        'products': ['PROD-001'],
      },
    ];

// ------------------------------------------------------------------ products

List<Map<String, Object?>> _products() => const [
      {
        'product_id': 'PROD-001',
        'name_en': 'Diesel 10ppm',
        'name_ar': 'ديزل 10 جزء في المليون',
        'unit': 'IG',
        'active': true,
      },
      {
        'product_id': 'DSL-STD',
        'name_en': 'Diesel Standard (legacy)',
        'name_ar': 'ديزل عادي (قديم)',
        'unit': 'IG',
        'active': false,
      },
      {
        'product_id': 'DSL-PRM',
        'name_en': 'Diesel Premium (legacy)',
        'name_ar': 'ديزل ممتاز (قديم)',
        'unit': 'IG',
        'active': false,
      },
    ];

// ------------------------------------------------------------------ vehicles
// 24 vehicles. 19 active: Loading 3 / In transit 9 / At customer 5 /
// Break 1 / Breakdown 1 (+ Delayed 4 is a subset flag, not a status).
// Remaining 5: Available 3 + Maintenance 2.

List<Map<String, Object?>> _vehicles() {
  const act = [
    // id, registration, capacity IG, onBoard IG, status
    ['T-07', 'Dubai A 12345', 5000, 3500, 'inTransit'], // hero Tanker 07
    ['T-03', 'Dubai A 12310', 5000, 3000, 'loading'],
    ['T-09', 'Dubai A 12361', 4000, 4000, 'atCustomer'],
    ['T-11', 'Dubai A 12388', 5000, 1200, 'atCustomer'],
    ['T-13', 'Dubai A 12402', 5000, 2200, 'atCustomer'],
    ['T-04', 'Dubai A 12320', 5000, 1800, 'breakdown'], // incident Tanker 04
    ['T-06', 'Dubai A 12333', 4000, 2500, 'onBreak'],
    ['T-01', 'Dubai A 12201', 5000, 4200, 'inTransit'],
    ['T-02', 'Dubai A 12202', 4000, 1000, 'loading'],
    ['T-05', 'Dubai A 12205', 5000, 4600, 'inTransit'],
    ['T-08', 'Dubai A 12208', 4000, 800, 'inTransit'],
    ['T-10', 'Dubai A 12210', 5000, 3100, 'inTransit'],
    ['T-12', 'Dubai A 12212', 5000, 0, 'loading'],
    ['T-14', 'Dubai A 12214', 4000, 1500, 'inTransit'],
    ['T-15', 'Dubai A 12215', 5000, 2700, 'atCustomer'],
    ['T-16', 'Dubai A 12216', 4000, 900, 'inTransit'],
    ['T-17', 'Dubai A 12217', 5000, 3300, 'inTransit'],
    ['T-18', 'Dubai A 12218', 4000, 600, 'atCustomer'],
    ['T-19', 'Dubai A 12219', 5000, 2900, 'inTransit'],
    ['T-20', 'Dubai A 12220', 5000, 4500, 'available'],
    ['T-21', 'Dubai A 12221', 4000, 0, 'available'],
    ['T-22', 'Dubai A 12222', 5000, 0, 'available'],
    ['T-23', 'Dubai A 12223', 4000, 0, 'maintenance'],
    ['T-24', 'Dubai A 12224', 5000, 0, 'maintenance'],
  ];
  return [
    for (final v in act)
      {
        'vehicle_id': v[0],
        'registration': v[1],
        'capacity_tenths': (v[2] as int) * 10,
        'on_board_tenths': (v[3] as int) * 10,
        'status': v[4],
        'doc_expiry_days': 300,
        'critical_defect': v[0] == 'T-04',
        'compartments': const [],
      },
  ];
}

// ------------------------------------------------------------------- drivers
// 28 drivers. 22 onDuty (active), 6 off (offline).

List<Map<String, Object?>> _drivers() {
  const names = [
    ['DRV-0001', 'Khalid Al Mansoori', 'خالد المنصوري', '+971506781193'],
    ['DRV-0002', 'Bilal Ahmed', 'بلال أحمد', '+971507771201'],
    ['DRV-0003', 'Omar Farouk', 'عمر فاروق', '+971507771202'],
    ['DRV-0004', 'Faisal Noor', 'فيصل نور', '+971507771203'],
    ['DRV-0005', 'Saeed Omar', 'سعيد عمر', '+971507771204'],
    ['DRV-0006', 'Rashid Ali', 'راشد علي', '+971506781193'],
    ['DRV-0007', 'Naveed Ali', 'نافيد علي', '+971507771206'],
    ['DRV-0008', 'Yusuf Ibrahim', 'يوسف إبراهيم', '+971507771207'],
    ['DRV-0009', 'Hassan Ali', 'حسن علي', '+971507771208'],
    ['DRV-0010', 'Adel Karim', 'عادل كريم', '+971507771209'],
    ['DRV-0011', 'Tariq Aziz', 'طارق عزيز', '+971507771210'],
    ['DRV-0012', 'Imran Sheikh', 'عمران شيخ', '+971507771211'],
    ['DRV-0013', 'Javed Iqbal', 'جاويد إقبال', '+971507771212'],
    ['DRV-0014', 'Rashid Kareem', 'راشد كريم', '+971507891124'],
    ['DRV-0015', 'Salim Khan', 'سليم خان', '+971507771214'],
    ['DRV-0016', 'Farhan Malik', 'فرحان مالك', '+971507771215'],
    ['DRV-0017', 'Asif Raza', 'آصف رضا', '+971507771216'],
    ['DRV-0018', 'Kamran Shah', 'كامران شاه', '+971507771217'],
    ['DRV-0019', 'Waqas Anwar', 'وقاص أنور', '+971507771218'],
    ['DRV-0020', 'Danish Ali', 'دانش علي', '+971507771219'],
    ['DRV-0021', 'Shahid Mehmood', 'شاهد محمود', '+971507771220'],
    ['DRV-0022', 'Zubair Ahmed', 'زبير أحمد', '+971507771221'],
    ['DRV-0023', 'Mariam Hassan', 'مريم حسن', '+971507771222'],
    ['DRV-0024', 'Fatima Ali', 'فاطمة علي', '+971507771223'],
    ['DRV-0025', 'Layla Haddad', 'ليلى حداد', '+971507771224'],
    ['DRV-0026', 'Omar Siddiq', 'عمر صديق', '+971507771225'],
    ['DRV-0027', 'Haris Sohail', 'حارث سهيل', '+971507771226'],
    ['DRV-0028', 'Ahmed Khan', 'أحمد خان', '+971507892281'],
  ];
  return [
    for (var i = 0; i < names.length; i++)
      {
        'driver_id': names[i][0],
        'name_en': names[i][1],
        'name_ar': names[i][2],
        'phone': names[i][3],
        'status': i < 22 ? 'onDuty' : 'offDuty',
        'licence_expiry_days': names[i][0] == 'DRV-0005' ? 30 : 700,
      },
  ];
}

// -------------------------------------------------------------------- orders
// 87 orders: Draft 5 + Unassigned 10 + Assigned 9 + In Progress 28 +
// Completed 31 + Partial 2 + Failed 1 + Cancelled 1 (BO-06 chips, doc 12 §1).

List<Map<String, Object?>> _orders() {
  final out = <Map<String, Object?>>[];
  void add(
    String id,
    String site,
    int qtyIg,
    String status,
    String window, {
    bool variance = false,
    String priority = 'normal',
    String? poRef,
  }) {
    out.add({
      'order_id': id,
      'site_id': site,
      'product_id': 'PROD-001',
      'qty_tenths': qtyIg * 10,
      'priority': priority,
      'window': window,
      'status': status,
      'has_variance': variance,
      'po_ref': poRef ?? 'ABC/PO/2026/${482 + out.length}',
    });
  }

  // Hero + named Figma orders (first 14).
  add('SO-260145', 'SITE-ABC-04', 1500, 'inProgress', '09:00-11:00',
      poRef: 'ABC/PO/2026/482');
  add('SO-260118', 'SITE-ABC-04', 1500, 'completed', '07:00-09:00');
  add('SO-260146', 'SITE-XYZ-01', 2000, 'inProgress', '11:00-13:00');
  add('SO-260147', 'SITE-DLT-02', 1500, 'assigned', '13:00-15:00');
  add('SO-260148', 'SITE-EPC-01', 2500, 'completed', '07:00-09:00');
  add('SO-260149', 'SITE-GRM-01', 1000, 'partial', '09:00-11:00',
      variance: true);
  add('SO-260150', 'SITE-MRN-01', 1800, 'inProgress', '10:00-12:00');
  add('SO-260151', 'SITE-AQZ-01', 1200, 'assigned', '10:00-12:00',
      priority: 'high');
  add('SO-260152', 'SITE-FLC-01', 1200, 'unassigned', '11:00-13:00');
  add('SO-260153', 'SITE-FLC-01', 1200, 'inProgress', '10:00-12:00');
  add('SO-260156', 'SITE-XYZ-01', 1600, 'assigned', '12:00-14:00');
  add('SO-260138', 'SITE-EPC-01', 2000, 'completed', '06:00-08:00');

  // Fill remaining per-status quotas.
  // Used so far: draft 0, unassigned 1 (152), assigned 3 (147,151,156),
  // inProgress 4 (145,146,150,153), completed 3 (118,148,138),
  // partial 1 (149), failed 0, cancelled 0.
  const need = {
    'draft': 5,
    'unassigned': 9,
    'assigned': 6,
    'inProgress': 24,
    'completed': 28,
    'partial': 1,
    'failed': 1,
    'cancelled': 1,
  };
  final siteIds = [
    'SITE-ABC-04',
    'SITE-XYZ-01',
    'SITE-DLT-02',
    'SITE-FLC-01',
    'SITE-EPC-01',
    'SITE-GRM-01',
    'SITE-MRN-01',
    'SITE-AQZ-01',
  ];
  var n = 260160;
  var k = 0;
  for (final entry in need.entries) {
    for (var i = 0; i < entry.value; i++) {
      final qty = 800 + ((k * 137) % 2200); // 800-2999 IG deterministic
      add('SO-$n', siteIds[k % siteIds.length], qty, entry.key,
          '0${6 + (k % 12)}:00-0${7 + (k % 12)}:00');
      n++;
      k++;
    }
  }
  return out;
}

// --------------------------------------------------------------------- trips

List<Map<String, Object?>> _trips() => const [
      {
        'trip_id': 'TRIP-260021',
        'driver_id': 'DRV-0028',
        'vehicle_id': 'T-07',
        'loading_point': 'D-2',
        'order_ids': ['SO-260145', 'SO-260146', 'SO-260147'],
        'status': 'delivering',
        'closed': false,
        'distance_km': 126,
        'loaded_tenths': 50000,
      },
      {
        'trip_id': 'TRIP-260027',
        'driver_id': 'DRV-0003',
        'vehicle_id': 'T-10',
        'loading_point': 'D-2',
        'order_ids': ['SO-260150'],
        'status': 'completed',
        'closed': true,
        'distance_km': 98,
        'loaded_tenths': 49500,
      },
    ];

// --------------------------------------------------------------- inspections
// Figma DR-04 8 checks (inspectionChecklistV1), INS-260023 06:14 pass.

List<Map<String, Object?>> _inspections() => [
      for (var i = 0; i < 6; i++)
        {
          'inspection_id': i == 0 ? 'INS-260023' : 'INS-2600${30 + i}',
          'driver_id': i == 0 ? 'DRV-0028' : 'DRV-000${i + 1}',
          'vehicle_id': i == 0 ? 'T-07' : 'T-0${i + 1}',
          'result': i < 5 ? 'pass' : 'minor_defect',
          'items_failed': i < 5 ? 0 : 1,
          'checklist_version': 'inspectionChecklistV1',
          'at': i == 0 ? '2026-10-23T06:14:00Z' : '2026-10-23T05:4$i:00Z',
        },
    ];

// ----------------------------------------------------------------- incidents
// INC-260019 hero (Rashid Kareem, Tanker 04, fuel pump failure, Al Quoz).

List<Map<String, Object?>> _incidents() => const [
      {
        'incident_id': 'INC-260019',
        'category': 'Fuel Pump Failure',
        'severity': 'critical',
        'vehicle_id': 'T-04',
        'driver_id': 'DRV-0014',
        'driver_name_en': 'Rashid Kareem',
        'lat': 25.1335,
        'lng': 55.2342,
        'place_en': 'Al Quoz',
        'at': '2026-10-23T06:22:00Z',
        'acknowledged_at': '2026-10-23T06:24:00Z',
        'owner': 'Mariam Hassan',
        'owner_role': 'Dispatcher',
        'recovery_eta': '2026-10-23T06:55:00Z',
        'affected_order_id': 'SO-260151',
        'evidence': ['pump-failure.jpg'],
        'note':
            'Stopped safely, engine isolated, no spill; delivery paused; recovery + replacement tanker required.',
        'open': true,
      },
      {
        'incident_id': 'INC-260020',
        'category': 'delay',
        'severity': 'high',
        'vehicle_id': 'T-09',
        'driver_id': 'DRV-0007',
        'at': '2026-10-23T06:10:00Z',
        'owner': 'Mariam Hassan',
        'open': true,
      },
      {
        'incident_id': 'INC-260021',
        'category': 'plan loading variance',
        'severity': 'high',
        'vehicle_id': 'T-10',
        'driver_id': 'DRV-0003',
        'at': '2026-10-23T05:50:00Z',
        'owner': 'Fatima Ali',
        'open': true,
      },
      {
        'incident_id': 'INC-260022',
        'category': 'gps_issue',
        'severity': 'high',
        'vehicle_id': 'T-12',
        'driver_id': 'DRV-0010',
        'at': '2026-10-23T04:00:00Z',
        'owner': 'IT Support',
        'open': true,
      },
      {
        'incident_id': 'INC-260023',
        'category': 'licence_expiry',
        'severity': 'high',
        'vehicle_id': 'T-01',
        'driver_id': 'DRV-0005',
        'at': '2026-10-23T03:00:00Z',
        'owner': 'Fleet Manager',
        'open': true,
      },
    ];

// ------------------------------------------------------------- notifications

List<Map<String, Object?>> _notifications() => [
      for (var i = 0; i < 16; i++)
        {
          'notification_id': 'N-${260000 + i}',
          'type': const [
            'assigned',
            'late_eta',
            'geofence',
            'variance',
            'breakdown',
            'deviation',
            'doc_expiry',
            'gps_stale',
          ][i % 8],
          'order_id': 'SO-${260145 + (i % 12)}',
          'read': i % 4 == 0,
        },
    ];

// --------------------------------------------------------------------- audit

List<Map<String, Object?>> _audit() => [
      for (var i = 0; i < 40; i++)
        {
          'audit_id': 'A-${260000 + i}',
          'entity': 'order',
          'entity_id': 'SO-${260145 + (i % 12)}',
          'action': const [
            'create',
            'edit',
            'assign',
            'reassign',
            'cancel',
            'override',
            'adjust',
          ][i % 7],
          'user': i % 3 == 0
              ? 'dispatch@demo.ae'
              : (i % 3 == 1 ? 'ops.manager@demo.ae' : 'driver.app@demo.ae'),
          'at': '2026-10-23T0${i % 9}:${(i * 7) % 60}:00Z',
        },
    ];

List<Map<String, Object?>> _history() => const [
      {
        'date': '2026-10-16',
        'orders': 62,
        'delivered_tenths': 510000,
        'on_time_pct': 96,
      },
      {
        'date': '2026-10-17',
        'orders': 68,
        'delivered_tenths': 580000,
        'on_time_pct': 97,
      },
      {
        'date': '2026-10-18',
        'orders': 71,
        'delivered_tenths': 620000,
        'on_time_pct': 96,
      },
      {
        'date': '2026-10-19',
        'orders': 64,
        'delivered_tenths': 550000,
        'on_time_pct': 95,
      },
      {
        'date': '2026-10-20',
        'orders': 78,
        'delivered_tenths': 680000,
        'on_time_pct': 97,
      },
      {
        'date': '2026-10-21',
        'orders': 66,
        'delivered_tenths': 570000,
        'on_time_pct': 96,
      },
      {
        'date': '2026-10-22',
        'orders': 72,
        'delivered_tenths': 620000,
        'on_time_pct': 96,
      },
    ];

// ---------------------------------------------------------------- demo meta

List<Map<String, Object?>> _demoMeta() => const [
      {
        'demo_now_utc': _demoNowUtcIso,
        'demo_now_gst': '2026-10-23T10:30:00+04:00',
        'timezone': 'Asia/Dubai',
        'reset_semantics':
            'Regenerating seeds (dart run bin/generate_seeds.dart) restores DEMO_NOW_UTC and all Snapshot-A / B / C / I / R-27 / Reporting fixtures to this file. Reset-demo in apps = reload this bundle.',
      },
    ];

// ---------------------------------------------------------------- Snapshot A
// BO-05 numbers verbatim. Telemetry 3,520 IG is a live sample, NOT ledger.

List<Map<String, Object?>> _snapshotA() => const [
      {
        'snapshot': 'A',
        'at_gst': '2026-10-23T10:30:00+04:00',
        'orders': 87,
        'deliveries': 74,
        'completed': 31,
        'active': 28,
        'pending': 15,
        'drivers_active': 22,
        'drivers_total': 28,
        'vehicles_active': 19,
        'vehicles_total': 24,
        'loaded_tenths': 785000,
        'loaded_ig': 78500,
        'delivered_tenths': 462500,
        'delivered_ig': 46250,
        'variance_tenths': 1250,
        'variance_ig': 125,
        'breakdowns': 1,
        'delayed': 4,
        'live': {
          'loading': 3,
          'in_transit': 9,
          'at_customer': 5,
          'break': 1,
          'delayed_subset': 4,
          'breakdown': 1,
        },
        'order_status_chips': {
          'draft': 5,
          'unassigned': 10,
          'assigned': 9,
          'in_progress': 28,
          'completed': 31,
          'partial': 2,
          'failed': 1,
          'cancelled': 1,
        },
        'hero_card': {
          'order_id': 'SO-260145',
          'customer_en': 'ABC Construction',
          'vehicle_id': 'T-07',
          'vehicle_label': 'Tanker 07',
          'registration': 'Dubai A 12345',
          'driver_id': 'DRV-0028',
          'driver_name_en': 'Ahmed Khan',
          'telemetry_tenths': 35200,
          'telemetry_ig': 3520,
          'telemetry_is_ledger': false,
          'eta_gst': '10:42',
          'distance_km': 16.4,
        },
        'activity': [
          {
            'at_gst': '08:45',
            'text': 'Unload ABC (SO-260118)',
          },
          {
            'at_gst': '08:42',
            'text': 'Tanker 03 arrived terminal (TRIP-260021, ENOC Jebel Ali)',
          },
          {
            'at_gst': '08:39',
            'text': 'Rashid Ali break (Tanker 06)',
          },
          {
            'at_gst': '08:32',
            'text': 'SO-260156 assigned to Tanker 09 (dispatcher Mariam Hassan)',
          },
        ],
        'detail_bo08': {
          'order_id': 'SO-260145',
          'ordered_ig': 1500,
          'delivered_ig': 0,
          'eta_gst': '10:42',
          'buffer_min': 18,
          'ticket': 'ENOC-88231',
          'revision': 4,
          'revision_by': 'Mariam Hassan',
          'revision_at_gst': '09:24',
          'contact': 'Mohammed Saleem',
          'contact_phone': '+971502345678',
          'site': 'ABC DIC Site 04 Plot 42',
          'lat': 24.8461,
          'lng': 55.0678,
          'tank_ig': 8000,
          'hours': '07:00-18:00',
          'gate_note': 'Enter through Gate 3',
          'window': '09:00-11:00',
        },
      },
    ];

// ------------------------------------------------------------- Scenario B
// TRIP-260021 (contracts ID; doc 12 §3 labels the same chain TRIP-260023).

List<Map<String, Object?>> _tripB() => const [
      {
        'trip_id': 'TRIP-260021',
        'legacy_trip_id': 'TRIP-260023',
        'trip_label': 'Main Trip B',
        'driver_id': 'DRV-0028',
        'driver_name_en': 'Ahmed Khan',
        'vehicle_id': 'T-07',
        'vehicle_label': 'Tanker 07',
        'registration': 'Dubai A 12345',
        'loaded_tenths': 50000,
        'loaded_ig': 5000,
        'distance_km': 126,
        'duration': '7h 40m',
        'completion_gst': '15:45',
        'revision': 1,
        'revision_received_gst': '06:14',
        'dispatcher': 'Mariam Hassan',
        'ledger': [
          {'step': 'opening', 'qty_ig': 0, 'balance_ig': 0},
          {'step': 'load', 'qty_ig': 5000, 'balance_ig': 5000},
          {
            'step': 'delivery',
            'order_id': 'SO-260145',
            'customer_en': 'ABC Construction',
            'qty_ig': 1500,
            'balance_ig': 3500,
          },
          {
            'step': 'delivery',
            'order_id': 'SO-260146',
            'customer_en': 'XYZ Contracting',
            'qty_ig': 2000,
            'balance_ig': 1500,
          },
          {
            'step': 'delivery',
            'order_id': 'SO-260147',
            'customer_en': 'Delta Engineering',
            'qty_ig': 1500,
            'balance_ig': 0,
          },
          {'step': 'return', 'qty_ig': 0, 'balance_ig': 0},
          {'step': 'closing', 'qty_ig': 0, 'balance_ig': 0},
          {'step': 'variance', 'qty_ig': 0, 'balance_ig': 0},
        ],
        'sequence': [
          '01 inspection',
          '02 travel ENOC',
          '03 load +5,000 (5,000)',
          '04 ABC -1,500 (3,500)',
          '05 XYZ -2,000 (1,500)',
          '06 Delta -1,500 (0)',
          '07 zero return',
        ],
        'windows': {
          'SO-260145': '09:00-11:00',
          'SO-260146': '11:00-13:00',
          'SO-260147': '13:00-15:00',
        },
        'loading': {
          'txn_id': 'LD-260023',
          'meter_start': 128400,
          'meter_end': 133400,
          'ticket': 'ENOC-88231',
          'photo': 'ticket-88231.jpg',
          'start_gst': '06:53',
          'end_gst': '07:18',
          'minutes': 25,
        },
        'abc_delivery': {
          'txn_id': 'DL-260145',
          'meter_start': 42100,
          'meter_end': 43600,
          'unload_start_gst': '08:12',
          'unload_end_gst': '08:31',
          'pod_id': 'POD-260145',
          'signed_by': 'Mohammed Saleem',
          'signed_phone': '+971502345678',
          'evidence': ['meter-final.jpg', 'delivery-note.pdf'],
        },
        'depot_return': {
          'txn_id': 'RET-260023',
          'qty_ig': 0,
          'receiver': 'Yusuf Ibrahim',
          'at_gst': '15:46',
          'distance_km': 126,
        },
        'approval': {
          'preparer': 'Mariam Hassan',
          'reviewer': 'Operations Manager',
          'evidence': ['3 POD', 'ticket', 'depot receipt'],
          'note': 'plan shortfall and stock variance are distinct',
        },
        'live_post_abc': {
          'loaded_ig': 5000,
          'delivered_ig': 1500,
          'remaining_ig': 3500,
          'speed_kph': 68,
          'heading': 'NE 042',
          'lat': 25.1186,
          'lng': 55.2094,
          'gps_age_s': 10,
          'next_stop': 'XYZ Contracting',
          'next_eta_gst': '11:05',
          'next_distance_km': 12.8,
        },
      },
    ];

// ------------------------------------------------------------- Scenario C

List<Map<String, Object?>> _dayC() => const [
      {
        'day': '2026-10-23',
        'driver_id': 'DRV-0028',
        'driver_name_en': 'Ahmed Khan',
        'vehicle_id': 'T-07',
        'shift_start_gst': '06:00',
        'shift_end_gst': '17:15',
        'distance_km': 182,
        'main_trip_km': 126,
        'depot_yard_km': 56,
        'duty_split': {
          'driving': '6h 15m',
          'loading': '42m',
          'unloading': '1h 54m',
          'waiting': '38m',
          'break': '46m',
          'break_detail': '15m rest + 31m lunch',
          'idle': '22m',
          'checks_admin': '38m',
          'total': '11h 15m',
        },
        'odometer_start_km': 128420,
        'odometer_end_km': 128602,
        'events_total': 27,
        'events': [
          {'at_gst': '06:00', 'text': 'login (Dubai Depot)'},
          {'at_gst': '06:05', 'text': 'inspection start (INS-260023)'},
          {'at_gst': '06:14', 'text': 'pass 0 defects'},
          {'at_gst': '06:16', 'text': 'depart'},
          {'at_gst': '06:47', 'text': 'arrive ENOC'},
          {'at_gst': '06:53', 'text': 'load start (meter 128,400)'},
          {'at_gst': '07:18', 'text': 'loaded 5,000 (ENOC-88231)'},
          {'at_gst': '07:22', 'text': 'depart (seal verified)'},
          {'at_gst': '08:04', 'text': 'arrive ABC Gate 3'},
          {'at_gst': '08:12', 'text': 'unload start (safety pass)'},
          {
            'at_gst': '08:31',
            'text': 'delivered 1,500 + signed POD (remaining 3,500)',
          },
          {'at_gst': '08:35', 'text': 'depart'},
          {'at_gst': '09:10', 'text': 'break'},
          {'at_gst': '09:25', 'text': 'resume'},
          {'at_gst': '11:05', 'text': 'arrive XYZ (2,000 planned)'},
          {'at_gst': '11:14', 'text': 'unload'},
          {'at_gst': '11:48', 'text': 'delivered (remaining 1,500)'},
          {'at_gst': '13:12', 'text': 'arrive Delta'},
          {'at_gst': '13:25', 'text': 'unload'},
          {'at_gst': '14:26', 'text': 'delivered (remaining 0)'},
          {'at_gst': '15:02', 'text': 'lunch'},
          {'at_gst': '15:33', 'text': 'resume'},
          {'at_gst': '15:45', 'text': 'main trip back (TRIP-260023)'},
          {'at_gst': '16:00', 'text': 'yard transfer'},
          {'at_gst': '16:48', 'text': 'parked'},
          {'at_gst': '17:00', 'text': 'end-shift checks'},
          {'at_gst': '17:15', 'text': 'shift end (reconciled)'},
        ],
        'selected_event': {
          'at_gst': '08:31',
          'site': 'ABC/Gate 3',
          'lat': 24.8461,
          'lng': 55.0678,
          'delivered_ig': 1500,
          'remaining_ig': 3500,
          'pod_id': 'POD-260145',
          'source': 'driver app + GPS geofence',
        },
        'close': {
          'unsynced': 0,
          'receipt': 'SH-261023-028',
          'dr24_loaded_ig': 5000,
          'dr24_customers': 3,
          'dr24_variance_ig': 0,
        },
      },
    ];

// ------------------------------------------------------------- Scenario I

List<Map<String, Object?>> _incidentI() => const [
      {
        'incident_id': 'INC-260019',
        'driver_name_en': 'Rashid Kareem',
        'driver_id': 'DRV-0014',
        'vehicle_id': 'T-04',
        'vehicle_label': 'Tanker 04',
        'failure': 'Fuel Pump Failure',
        'place_en': 'Al Quoz',
        'lat': 25.1335,
        'lng': 55.2342,
        'at_gst': '10:22',
        'owner': 'Mariam Hassan',
        'owner_role': 'Dispatcher',
        'acknowledged_at_gst': '10:24',
        'recovery_eta_gst': '10:55',
        'affected_order_id': 'SO-260151',
        'evidence': ['pump-failure.jpg'],
        'note':
            'Stopped safely, engine isolated, no spill; delivery paused; recovery + replacement tanker required.',
        'alert_counts': {
          'critical': 1,
          'high': 4,
          'medium': 7,
          'info': 12,
          'resolved': 18,
        },
      },
    ];

// ------------------------------------------------------------------ R-27

List<Map<String, Object?>> _exceptionR27() => const [
      {
        'exception_id': 'R-27',
        'trip_id': 'TRIP-260027',
        'loaded_ig': 4950,
        'delivered_ig': 4700,
        'returned_ig': 200,
        'closing_ig': 0,
        'unexplained_ig': 50,
        'owner': 'Fatima Ali',
        'owner_role': 'Loading Supervisor',
        'reason': 'Meter discrepancy — under investigation',
        'invoice_id': 'INV-26027',
        'invoice_due_gst': '2026-10-24T12:00:00+04:00',
        'approval_state': 'pending_operations_manager',
        'tolerance_policy': 'any unexplained variance requires review',
        'immutability':
            'Approved adjustment posts a separate signed event; original meter/POD records immutable.',
      },
    ];

// --------------------------------------------------------------- Reporting
// Closed period 16-22 Oct 2026. Separate from live Snapshot A.
// Daily bars are rounded; exact total comes from the posted ledger
// (41,3000 rounded sum vs 412,850 posted — by Figma design, doc 12 §11 #12).

List<Map<String, Object?>> _reportWeek() => const [
      {
        'period': '2026-10-16..2026-10-22',
        'city': 'Dubai',
        'product_id': 'PROD-001',
        'scope': 'closed days only',
        'delivered_ig': 412850,
        'delivered_change_pct': 8.6,
        'on_time_pct': 96.2,
        'on_time_target_pct': 95,
        'deliveries_total': 486,
        'deliveries_on_time': 471,
        'variance_ig': 125,
        'variance_note': '0.030% of loaded; live Snapshot-A 125 IG is a '
            'separate aggregate with its own source label (doc 12 §11 #3).',
        'fleet_utilisation_pct': 84.7,
        'daily_bars_ig': [51000, 58000, 62000, 55000, 68000, 57000, 62000],
        'daily_bars_note':
            'Rounded daily bars sum to 413,000; exact total 412,850 comes from the posted ledger.',
        'drivers': [
          {
            'name_en': 'Ahmed Khan',
            'on_time_pct': 98.4,
            'delivered_ig': 36500,
            'variance_ig': 0,
          },
          {
            'name_en': 'Omar Farouk',
            'on_time_pct': 98.1,
            'delivered_ig': 31250,
            'variance_ig': 0,
          },
          {
            'name_en': 'Bilal Ahmed',
            'on_time_pct': 97.0,
            'delivered_ig': 34000,
            'variance_ig': 25,
          },
          {
            'name_en': 'Faisal Noor',
            'on_time_pct': 97.3,
            'delivered_ig': 28600,
            'variance_ig': 0,
          },
          {
            'name_en': 'Others',
            'on_time_pct': 94.8,
            'delivered_ig': 282500,
            'variance_ig': 100,
          },
        ],
      },
    ];

// ------------------------------------------------------ inspection checklist

List<Map<String, Object?>> _inspectionChecklist() => const [
      {
        'version': 'inspectionChecklistV1',
        'vehicle_type': 'tanker',
        'items': [
          {'id': 'tyres', 'en': 'Tyres & wheel nuts', 'ar': 'الإطارات وصواميل العجلات'},
          {'id': 'lights', 'en': 'Lights & indicators', 'ar': 'الأنوار والإشارات'},
          {
            'id': 'brakes',
            'en': 'Brakes & air pressure',
            'ar': 'المكابح وضغط الهواء',
          },
          {
            'id': 'leaks',
            'en': 'Leaks, hoses & couplings',
            'ar': 'التسريبات والخراطيم والوصلات',
          },
          {
            'id': 'fire',
            'en': 'Fire extinguisher & spill kit',
            'ar': 'طفاية الحريق وعدة الانسكاب',
          },
          {
            'id': 'seals',
            'en': 'Tank seals & compartments',
            'ar': 'أختام الخزان والمقصورات',
          },
          {
            'id': 'ppe',
            'en': 'PPE & warning equipment',
            'ar': 'معدات الحماية الشخصية والتحذير',
          },
          {
            'id': 'docs',
            'en': 'Documents & permit',
            'ar': 'المستندات والتصريح',
          },
        ],
      },
    ];
