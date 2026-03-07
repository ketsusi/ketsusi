#!/bin/bash

OPENWRT_PATH="$GITHUB_WORKSPACE/openwrt-src"
PKG_PATH="$OPENWRT_PATH/package"

echo "===== Fix OpenWrt Build Environment ====="

########################################
# Fix Rust build failure
########################################

RUST_FILE=$(find "$OPENWRT_PATH/feeds/packages/" -maxdepth 3 -type f -wholename "*/rust/Makefile")

if [ -f "$RUST_FILE" ]; then
    echo "Fixing rust build..."

    sed -i 's/ci-llvm=true/ci-llvm=false/g' "$RUST_FILE"
    sed -i 's/download-ci-llvm = true/download-ci-llvm = false/g' "$RUST_FILE"

    echo "Rust fix applied!"
fi

########################################
# Fix CRLF (Windows line endings)
########################################

echo "Fixing CRLF line endings..."

find "$OPENWRT_PATH" -type f \( -name "Makefile" -o -name "*.mk" -o -name "*.sh" \) -exec sed -i 's/\r$//' {} +

echo "CRLF fix completed"

########################################
# Done
########################################

echo "All fixes applied successfully!"
