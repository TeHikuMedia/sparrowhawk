#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
OUT="$SCRIPT_DIR/output/android"

rm -rf "$OUT"
mkdir -p "$OUT/arm64-v8a" "$OUT/armeabi-v7a" "$OUT/x86" "$OUT/x86_64"

echo "==> Building Android arm64-v8a..."
bazel build //:sparrowhawk_static --platforms=//:android_arm64
cp bazel-bin/libsparrowhawk_static.a "$OUT/arm64-v8a/"

echo "==> Building Android armeabi-v7a..."
bazel build //:sparrowhawk_static --platforms=//:android_arm32
cp bazel-bin/libsparrowhawk_static.a "$OUT/armeabi-v7a/"

echo "==> Building Android x86..."
bazel build //:sparrowhawk_static --platforms=//:android_x86
cp bazel-bin/libsparrowhawk_static.a "$OUT/x86/"

echo "==> Building Android x86_64..."
bazel build //:sparrowhawk_static --platforms=//:android_x86_64
cp bazel-bin/libsparrowhawk_static.a "$OUT/x86_64/"

echo "==> Done: $OUT"
