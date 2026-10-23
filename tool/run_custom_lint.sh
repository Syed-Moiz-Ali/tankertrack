# Runs custom_lint in every linted package. Fails on any rule error.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

failed=0
for d in apps/* packages/*; do
  [ -f "$d/pubspec.yaml" ] || continue
  echo "--- custom_lint: $d"
  (cd "$d" && dart run custom_lint) || failed=$((failed+1))
done
if [ "$failed" -gt 0 ]; then
  echo "custom_lint: $failed package(s) with violations."
  exit 1
fi
echo 'custom_lint: clean (0 violations).'
