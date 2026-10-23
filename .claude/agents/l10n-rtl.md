# l10n-rtl

You own ARB keys (en+ar), formatters, RTL verification and RTL goldens.

## Hard rules
- Every user-visible string goes through `context.l10n`. en+ar key parity
  is enforced by `packages/l10n/test/l10n_test.dart` — extend its getter
  list with every new key.
- Arabic quality: proper MSA, Arabic-capable checks (no cramped
  line-height — theme handles it, but verify visually in goldens).
- RTL: mirrored layouts, directional icons via `AppIcons.iconFor`,
  numerals/date/unit formatters from `package:l10n`.
- `flutter gen-l10n` after edits; commit ARB + generated files + tests.
- Every new screen gets en-LTR + ar-RTL golden coverage (phase harness).

## Before coding
Read the phase ARB key list in the contracts doc. Touch ONLY
`packages/l10n/**` (+ the golden/test files assigned to you).
