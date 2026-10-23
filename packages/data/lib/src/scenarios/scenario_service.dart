import '../mock/seeds.dart';
import 'scenario_models.dart';

/// R3 scenario seam (extends, never breaks [MasterDataService]).
///
/// First-class fixtures per `docs/plan/12-figma-data-and-scenarios.md`:
/// `snapshotA`, `tripB`, `dayC`, `incidentI`, `exceptionR27`, `reportWeek`.
/// Scope discipline (printed on screens): Snapshot A (23 Oct 10:30 GST)
/// ≠ Main Trip B (planned→post-ABC) ≠ Historical Day C (06:00–17:15)
/// ≠ Reporting closed period (16–22 Oct). Never combine numbers across
/// scenarios — each fixture carries its own source label.
abstract class ScenarioService {
  Future<SnapshotA> snapshotA();
  Future<TripBLedger> tripB();
  Future<Map<String, Object?>> dayC();
  Future<Map<String, Object?>> incidentI();
  Future<ExceptionR27> exceptionR27();
  Future<ReportWeek> reportWeek();
  Future<List<Map<String, Object?>>> inspectionChecklist();
}

/// Mock over [SeedBundle]; remote in a later phase (UI never knows).
class MockScenarioService implements ScenarioService {
  const MockScenarioService(this.bundle);

  final SeedBundle bundle;

  Map<String, Object?> _single(String table) {
    final rows = bundle.table(table);
    if (rows.isEmpty) throw StateError('missing seed table: $table');
    return rows.first;
  }

  @override
  Future<SnapshotA> snapshotA() async =>
      SnapshotA.fromJson(_single('snapshot_a'));

  @override
  Future<TripBLedger> tripB() async =>
      TripBLedger.fromJson(_single('scenario_b_trip'));

  @override
  Future<Map<String, Object?>> dayC() async => _single('scenario_c_day');

  @override
  Future<Map<String, Object?>> incidentI() async =>
      _single('scenario_i_incident');

  @override
  Future<ExceptionR27> exceptionR27() async =>
      ExceptionR27.fromJson(_single('scenario_r27_exception'));

  @override
  Future<ReportWeek> reportWeek() async =>
      ReportWeek.fromJson(_single('report_week'));

  @override
  Future<List<Map<String, Object?>>> inspectionChecklist() async {
    final row = _single('inspection_checklist');
    return (row['items']! as List).cast<Map<String, Object?>>();
  }
}
