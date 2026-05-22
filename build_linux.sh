#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
OUT="$SCRIPT_DIR/output/linux"

rm -rf "$OUT"
mkdir -p "$OUT"

echo "==> Building Linux..."
bazel build //:sparrowhawk_static
cp bazel-bin/libsparrowhawk_static.a "$OUT/"

echo "==> Done: $OUT"
