#!/bin/bash
set -e

APP_NAME="小胡桃"
BUNDLE_DIR="${APP_NAME}.app"
EXEC_NAME="WalnutPet"

echo "🔨 Building ${APP_NAME}..."

# Clean
rm -rf "${BUNDLE_DIR}"

# Create bundle structure
mkdir -p "${BUNDLE_DIR}/Contents/MacOS"
mkdir -p "${BUNDLE_DIR}/Contents/Resources"

# Copy Info.plist
cp Info.plist "${BUNDLE_DIR}/Contents/Info.plist"

# Compile
SDK=$(xcrun --show-sdk-path)
swiftc WalnutPet.swift \
    -o "${BUNDLE_DIR}/Contents/MacOS/${EXEC_NAME}" \
    -framework SwiftUI \
    -framework AppKit \
    -sdk "${SDK}" \
    -O

chmod +x "${BUNDLE_DIR}/Contents/MacOS/${EXEC_NAME}"

echo "✅ Done: $(pwd)/${BUNDLE_DIR}"
echo ""
echo "Run: open '$(pwd)/${BUNDLE_DIR}'"
