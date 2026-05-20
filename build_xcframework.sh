#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
OUT="$SCRIPT_DIR/output/apple"
XCFRAMEWORK="$SCRIPT_DIR/output/Sparrowhawk.xcframework"

PUBLIC_HEADERS="$OUT/public_headers"

rm -rf "$OUT" "$XCFRAMEWORK"
mkdir -p "$OUT/macos_arm64" "$OUT/ios_arm64" "$OUT/ios_sim_arm64"

mkdir -p "$PUBLIC_HEADERS/sparrowhawk"
cp "$SCRIPT_DIR/src/include/sparrowhawk/sparrowhawk_wrapper.h" "$PUBLIC_HEADERS/sparrowhawk/"

echo "==> Building macOS arm64..."
bazel build //:sparrowhawk_static
cp bazel-bin/libsparrowhawk_static.a "$OUT/macos_arm64/"

echo "==> Building iOS arm64"
bazel build //:sparrowhawk_static \
  --platforms=//:ios_arm64 \
  --apple_platform_type=ios
cp bazel-bin/libsparrowhawk_static.a "$OUT/ios_arm64/"

echo "==> Building iOS simulator arm64."
bazel build //:sparrowhawk_static \
  --platforms=//:ios_sim_arm64 \
  --apple_platform_type=ios
cp bazel-bin/libsparrowhawk_static.a "$OUT/ios_sim_arm64/"

echo "==> Creating XCFramework"
xcodebuild -create-xcframework \
  -library "$OUT/macos_arm64/libsparrowhawk_static.a" -headers "$PUBLIC_HEADERS" \
  -library "$OUT/ios_arm64/libsparrowhawk_static.a" -headers "$PUBLIC_HEADERS" \
  -library "$OUT/ios_sim_arm64/libsparrowhawk_static.a" -headers "$PUBLIC_HEADERS" \
  -output "$XCFRAMEWORK"

echo "==> Done: $XCFRAMEWORK"
