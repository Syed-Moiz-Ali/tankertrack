import 'dart:convert';
import 'dart:io';

/// Loads generated seed JSON (assets/seeds/*.json).
/// Tests read from the package dir; Flutter apps bundle the same files
/// as assets in P1 (identical bytes, zero drift).
class SeedBundle {
  const SeedBundle(this.tables);

  final Map<String, List<Map<String, Object?>>> tables;

  static const files = [
    'customers.json',
    'sites.json',
    'depots.json',
    'products.json',
    'vehicles.json',
    'drivers.json',
    'orders_today.json',
    'trips_today.json',
    'inspections.json',
    'incidents.json',
    'notifications.json',
    'audit.json',
    'history_daily.json',
  ];

  static Future<SeedBundle> load(Directory seedsDir) async {
    final tables = <String, List<Map<String, Object?>>>{};
    for (final f in files) {
      final raw = await File('${seedsDir.path}/$f').readAsString();
      final list = (jsonDecode(raw) as List).cast<Map<String, Object?>>();
      tables[f.replaceAll('.json', '')] = list;
    }
    return SeedBundle(tables);
  }

  List<Map<String, Object?>> table(String name) => tables[name] ?? const [];
}
