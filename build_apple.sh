#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

usage() {
    echo "Usage: $0 [--macos] [--ios] [--all]"
    echo "  --macos   Build macOS arm64 only"
    echo "  --ios     Build iOS arm64 + simulator arm64 only"
    echo "  --all     Build all slices (default)"
    exit 1
}

BUILD_MACOS=false
BUILD_IOS=false

if [ $# -eq 0 ]; then
    BUILD_MACOS=true
    BUILD_IOS=true
else
    for arg in "$@"; do
        case "$arg" in
            --macos) BUILD_MACOS=true ;;
            --ios)   BUILD_IOS=true ;;
            --all)   BUILD_MACOS=true; BUILD_IOS=true ;;
            *) usage ;;
        esac
    done
fi

build_slice() {
    local SLICE=$1
    local OUT="$SCRIPT_DIR/output/$SLICE"

    if [ -f "$OUT/libsparrowhawk_static.a" ]; then
        echo "$SLICE already built, skipping"
        return
    fi

    mkdir -p "$OUT"

    case "$SLICE" in
        macos-arm64)
            echo "==> Building macOS arm64..."
            bazel build //:sparrowhawk_static
            ;;
        ios-arm64)
            echo "==> Building iOS arm64..."
            bazel build //:sparrowhawk_static \
                --platforms=//:ios_arm64 \
                --apple_platform_type=ios
            ;;
        iossim-arm64)
            echo "==> Building iOS simulator arm64..."
            bazel build //:sparrowhawk_static \
                --platforms=//:ios_sim_arm64 \
                --apple_platform_type=ios
            ;;
    esac

    cp bazel-bin/libsparrowhawk_static.a "$OUT/"
    echo "Built $OUT/libsparrowhawk_static.a"
}

$BUILD_MACOS && build_slice "macos-arm64"
$BUILD_IOS   && build_slice "ios-arm64"
$BUILD_IOS   && build_slice "iossim-arm64"

echo "==> Done"
