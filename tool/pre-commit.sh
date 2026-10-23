#!/bin/sh
# Pre-commit: centralization net + analyze on changed packages.
# Documented in docs/plan/05-phase-plan.md (working rule A4).
# Bypass only with reviewer sign-off: git commit --no-verify (logged in changes.md).
set -e
ROOT="$(git rev-parse --show-toplevel)"
cd "$ROOT"

CHANGED="$(git diff --cached --name-only --diff-filter=ACMR | grep '\.dart$' || true)"
if [ -z "$CHANGED" ]; then exit 0; fi

echo "[hook] check_centralization…"
if [ -f tool/check_centralization.sh ]; then
  bash tool/check_centralization.sh || {
    echo "[hook] FAILED: fix violations or add centralization:allow with sign-off.";
    exit 1;
  }
fi

echo "[hook] flutter analyze on changed packages…"
PKGS="$(echo "$CHANGED" | cut -d/ -f1-2 | sort -u)"
for p in $PKGS; do
  if [ -f "$p/pubspec.yaml" ]; then
    (cd "$p" && flutter analyze --no-fatal-infos) || {
      echo "[hook] FAILED in $p"; exit 1;
    }
  fi
done
echo "[hook] OK"
