import 'package:data/data.dart';
import 'package:flutter/services.dart';

/// Loads the seed JSON bundled by package:data (P1 contracts §2) into a
/// [SeedBundle]. Keys are table names (see [SeedBundle.assetUris]); the
/// bundle is built via [SeedBundle.fromStrings] over rootBundle reads.
Future<SeedBundle> loadSeedBundle() async {
  final sources = <String, String>{};
  for (final entry in SeedBundle.assetUris.entries) {
    sources[entry.key] = await rootBundle.loadString(entry.value);
  }
  return SeedBundle.fromStrings(sources);
}
