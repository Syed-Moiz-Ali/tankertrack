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

  /// Asset URIs keyed by table name, so Flutter apps can bundle the same
  /// seeds via `rootBundle.loadString(...)` (P1 contracts §2).
  static const assetUris = {
    'customers': 'packages/data/assets/seeds/customers.json',
    'sites': 'packages/data/assets/seeds/sites.json',
    'depots': 'packages/data/assets/seeds/depots.json',
    'products': 'packages/data/assets/seeds/products.json',
    'vehicles': 'packages/data/assets/seeds/vehicles.json',
    'drivers': 'packages/data/assets/seeds/drivers.json',
    'orders_today': 'packages/data/assets/seeds/orders_today.json',
    'trips_today': 'packages/data/assets/seeds/trips_today.json',
    'inspections': 'packages/data/assets/seeds/inspections.json',
    'incidents': 'packages/data/assets/seeds/incidents.json',
    'notifications': 'packages/data/assets/seeds/notifications.json',
    'audit': 'packages/data/assets/seeds/audit.json',
    'history_daily': 'packages/data/assets/seeds/history_daily.json',
  };

  static Future<SeedBundle> load(Directory seedsDir) async {
    final tables = <String, List<Map<String, Object?>>>{};
    for (final f in files) {
      final raw = await File('${seedsDir.path}/$f').readAsString();
      final list = (jsonDecode(raw) as List).cast<Map<String, Object?>>();
      tables[f.replaceAll('.json', '')] = list;
    }
    return SeedBundle(tables);
  }

  /// Builds a bundle from in-memory JSON strings keyed by table name
  /// (same keys as [assetUris]; a trailing `.json` is tolerated).
  /// Used by Flutter apps that load seeds via `rootBundle`.
  static SeedBundle fromStrings(Map<String, String> sources) {
    final tables = <String, List<Map<String, Object?>>>{};
    for (final entry in sources.entries) {
      final list = (jsonDecode(entry.value) as List)
          .cast<Map<String, Object?>>();
      tables[entry.key.replaceAll('.json', '')] = list;
    }
    return SeedBundle(tables);
  }

  List<Map<String, Object?>> table(String name) => tables[name] ?? const [];
}
