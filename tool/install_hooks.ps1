# Installs the pre-commit hook (rule A4). Run once per clone.
$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
Copy-Item (Join-Path $PSScriptRoot 'pre-commit.sh') `
  (Join-Path $root '.git\hooks\pre-commit') -Force
Write-Output 'pre-commit hook installed.'
