# Runs custom_lint in every linted package. Fails on any rule error.
$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
Set-Location $root

$dirs = @()
$dirs += Get-ChildItem -Directory -Path apps | ForEach-Object { $_.FullName }
$dirs += Get-ChildItem -Directory -Path packages | ForEach-Object { $_.FullName }

$failed = 0
foreach ($d in $dirs) {
  if (-not (Test-Path (Join-Path $d 'pubspec.yaml'))) { continue }
  Write-Output "--- custom_lint: $d"
  Push-Location $d
  try {
    dart run custom_lint
    if ($LASTEXITCODE -ne 0) { $failed++ }
  } finally {
    Pop-Location
  }
}
if ($failed -gt 0) {
  Write-Output "custom_lint: $failed package(s) with violations."
  exit 1
}
Write-Output 'custom_lint: clean (0 violations).'
