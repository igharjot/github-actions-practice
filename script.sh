#!/bin/bash
set -euo pipefail

echo "========================================="
echo " CI Health Check Script"
echo "========================================="

# ── 1. Node.js version check ──────────────────
echo "[1/4] Checking Node.js..."
node --version || { echo "ERROR: Node.js not found"; exit 1; }

# ── 2. Dependency audit ───────────────────────
echo "[2/4] Running dependency audit..."
if [ -f "package.json" ]; then
  npm audit --audit-level=high
  echo "Dependency audit passed."
else
  echo "No package.json found — skipping audit."
fi

# ── 3. Lint check ─────────────────────────────
echo "[3/4] Running lint..."
if [ -f "package.json" ] && grep -q '"lint"' package.json; then
  npm run lint
  echo "Lint passed."
else
  echo "No lint script found — skipping."
fi

# ── 4. Unit tests ─────────────────────────────
echo "[4/4] Running tests..."
if [ -f "package.json" ] && grep -q '"test"' package.json; then
  npm test
  echo "Tests passed."
else
  echo "No test script found — skipping."
fi

echo ""
echo "✅ All CI checks passed!"
exit 0