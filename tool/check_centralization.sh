# Centralization second net (08 §5.2). Runs in `melos analyze` from repo root.
# Scope per 08 §4: apps/* + packages/fleet_ui ONLY.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

mapfile -t FILES < <(git ls-files 'apps/*.dart' 'packages/fleet_ui/*.dart' 2>/dev/null || find apps packages/fleet_ui -name '*.dart' 2>/dev/null)
VIOLATIONS=0

check() { # check <label> <ere-pattern> <path-exclude-ere>
  local label="$1" pattern="$2" excl="${3:-__none__}"
  while IFS= read -r f; do
    case "$f" in
      *.dart) ;;
      *) continue ;;
    esac
    case "$f" in
      */test/*|*/gen/*|*.g.dart|*.freezed.dart|*.gen.dart)
        continue ;;
    esac
    if [[ "$f" =~ $excl ]]; then continue; fi
    while IFS= read -r hit; do
      case "$hit" in
        *centralization:allow*) continue ;;
      esac
      echo "CENTRALIZATION[$label] $hit"
      VIOLATIONS=$((VIOLATIONS+1))
    done < <(grep -rEn "$pattern" "$f" 2>/dev/null || true)
  done <<<"$(printf '%s\n' "${FILES[@]}")"
}

check "raw-color"        'Color\s*\(' '__none__'
check "colors-class"     'Colors\.' '__none__'
check "text-style"       'TextStyle\s*\(' '__none__'
check "font-prop"        'font(Size|Weight|Family)\s*:' '__none__'
check "radius-literal"   'BorderRadius\.circular\s*\(\s*[0-9]' '__none__'
check "insets-literal"    'EdgeInsets[[:alnum:]_]*[[:space:]]*\([^)]*[0-9]' '__none__'
check "sizedbox-literal" 'SizedBox\s*\([^)]*(width|height)\s*:\s*[0-9]' '__none__'
check "duration-literal" 'Duration\s*\(\s*(milli|micro|seconds|minutes|hours|days)\s*:\s*[0-9]' '__none__'
check "material-icons"   '(Icons|CupertinoIcons)\.' '__none__'
check "raw-text"         'Text\s*\(\s*['"'"'"]' '__none__'
check "directional"      'TextAlign\.(left|right)|Alignment\.(topLeft|topRight|centerLeft|centerRight|bottomLeft|bottomRight)|EdgeInsets\.only\s*\([^)]*(left|right)\s*:' '__none__'
check "mediaquery-style" 'MediaQuery\.(of|sizeOf|widthOf|heightOf)\(' '__none__'
check "adhoc-theme"      'Theme\s*\(\s*data\s*:\s*ThemeData\s*\(' '__none__'
check "raw-route"        '\.(go|push|replace|pushReplacement)\s*\(\s*['"'"'"]/' '__none__'

if [ "$VIOLATIONS" -gt 0 ]; then
  echo "check_centralization: $VIOLATIONS violation(s). See 08 §4. Add centralization:allow only with reviewer sign-off."
  exit 1
fi
echo "check_centralization: clean (0 violations)."
