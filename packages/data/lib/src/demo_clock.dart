/// R3 demo clock (frozen).
///
/// Snapshot A "now" is fixed: 23 Oct 2026 10:30 GST == 06:30 UTC.
/// GST = UTC+4, no DST.
///
/// Reset-demo semantics: running `dart run bin/generate_seeds.dart`
/// restores [demoNowUtc] and every scenario fixture (Snapshot A, Trip B,
/// Day C, Incident I, R-27, Reporting week) to the Figma values in
/// `docs/plan/12-figma-data-and-scenarios.md`. Apps implement Reset-demo
/// by reloading `SeedBundle` (identical bytes, zero drift); the clock
/// itself never advances implicitly.
const demoNowUtcIso = '2026-10-23T06:30:00Z';

/// Canonical demo "now" as UTC (10:30 GST 23 Oct 2026).
final DateTime demoNowUtc = DateTime.utc(2026, 10, 23, 6, 30);
