# Centralization second net (08 §5.2). Runs in `melos analyze` from repo root.
# Scope per 08 §4: apps/* + packages/fleet_ui ONLY (design_system defines
# tokens; data/core/domain/l10n own legitimate numeric timing/math).
$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
Set-Location $root

# Each rule: name, violation pattern, allow pattern ($null = none).
# -cmatch everywhere: Dart is case-sensitive; case-insensitive -match flags
# sanctioned accessors (context.colors vs the Colors. ban).
$patterns = @(
  @('raw-color', '\bColor\s*\(', $null),
  @('colors-class', '\bColors\.', $null),
  @('text-style', '\bTextStyle\s*\(', $null),
  @('font-prop', '\bfont(Size|Weight|Family)\s*:', $null),
  @('radius-literal', 'BorderRadius\.circular\s*\(\s*[0-9]', $null),
  @('insets-literal', 'EdgeInsets\w*\s*\([^)]*[0-9]', $null),
  @('sizedbox-literal', 'SizedBox\s*\([^)]*(width|height)\s*:\s*[0-9]', $null),
  @('duration-literal', 'Duration\s*\(\s*(milli|micro|seconds|minutes|hours|days)\s*:\s*[0-9]', $null),
  @('material-icons', '\b(Icons|CupertinoIcons|PhosphorIcons\w*|TablerIcons\w*)\.', $null),
  @('raw-text', "Text\s*\(\s*['`"][^`"'$]", $null),
  @('directional', 'TextAlign\.(left|right)|Alignment\.(topLeft|topRight|centerLeft|centerRight|bottomLeft|bottomRight)|EdgeInsets\.only\s*\([^)]*(left|right)\s*:', $null),
  @('mediaquery-style', 'MediaQuery\.(of|sizeOf|widthOf|heightOf)\(', 'context\.tokens\.breakpoint'),
  @('adhoc-theme', 'Theme\s*\(\s*data\s*:\s*ThemeData\s*\(', $null),
  @('raw-route', "\.(go|push|replace|pushReplacement)\s*\(\s*['`"]/", $null)
)

$violations = 0
$roots = @('apps', 'packages\fleet_ui')
$files = foreach ($r in $roots) {
  if (Test-Path $r) {
    Get-ChildItem -Recurse -Include *.dart -Path $r |
      Where-Object { $_.FullName -notmatch '\\\.dart_tool\\' -and $_.FullName -notmatch '\\build\\' }
  }
}

foreach ($f in $files) {
  $rel = $f.FullName.Substring($root.Length + 1)
  if ($rel.Contains('\test\')) { continue }
  $lines = Get-Content -LiteralPath $f.FullName
  for ($i = 0; $i -lt $lines.Count; $i++) {
    $line = $lines[$i]
    if ($line.Contains('centralization:allow')) { continue }
    foreach ($p in $patterns) {
      if ($line -cmatch $p[1]) {
        if ($p[2] -ne $null -and $line -cmatch $p[2]) { continue }
        Write-Output "CENTRALIZATION[$($p[0])] $($rel):$($i + 1): $($line.Trim())"
        $violations++
        break
      }
    }
  }
}

if ($violations -gt 0) {
  Write-Output "check_centralization: $violations violation(s). See 08 §4."
  exit 1
}
Write-Output 'check_centralization: clean (0 violations).'
