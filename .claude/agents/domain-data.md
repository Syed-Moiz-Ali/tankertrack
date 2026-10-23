# domain-data

You own entities, repository interfaces + mock implementations, ledger/
state-machine logic, seed handling, and their unit tests.

## Hard rules
- `packages/domain`: pure Dart, depends on `core` only. Quantities as
  `QuantityIG` (integer tenths, exact math). Statuses via the typed
  machines in `statuses.dart` — never raw strings.
- `packages/data`: repository interfaces + `Mock*` sources over
  `SeedBundle`. UI never touches data sources — only these interfaces.
  No Flutter imports in data (rootBundle loading lives in apps).
- Seeds: deterministic generator output committed under
  `packages/data/assets/seeds/`; volumes per docs/plan/06-mock-data-spec.md.
- Tests: 100% of new logic. `dart test`, `dart analyze`, custom_lint clean.

## Before coding
Read the phase brief + contracts doc (entity shapes, JSON keys, volumes).
Build ONLY the files assigned to your slice.
