#!/bin/bash

# Build script for Sari Scan APK
# This script automates the process of building the Android APK
#
# Usage:
#   chmod +x build-apk.sh  # Make executable (first time only)
#   ./build-apk.sh

set -e  # Exit on error

echo "==================================="
echo "  Sari Scan APK Build Script"
echo "==================================="
echo ""

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "Error: Flutter is not installed or not in PATH"
    echo "Please install Flutter from https://flutter.dev/docs/get-started/install"
    exit 1
fi

echo "Flutter version:"
flutter --version
echo ""

# Get dependencies
echo "Step 1: Getting Flutter dependencies..."
flutter pub get
echo ""

# Clean previous builds
echo "Step 2: Cleaning previous builds..."
flutter clean
echo ""

# Build debug APK (always works without signing)
echo "Step 3: Building debug APK..."
flutter build apk --debug
echo ""

# Try to build release APK (may fail without signing configuration)
echo "Step 4: Attempting to build release APK..."
if flutter build apk --release 2>&1 | tee /tmp/release-build.log; then
    echo "✓ Release APK built successfully!"
    echo ""
    echo "Release APK location:"
    echo "  build/app/outputs/flutter-apk/app-release.apk"
else
    echo "⚠ Release APK build failed (likely due to missing signing configuration)"
    echo ""
    echo "Error details:"
    tail -n 20 /tmp/release-build.log | grep -A 5 -i "error" || echo "  Check /tmp/release-build.log for full details"
    echo ""
    echo "  This is expected if you haven't set up key.properties"
    echo "  You can still use the debug APK for testing"
fi
echo ""

echo "==================================="
echo "  Build Complete!"
echo "==================================="
echo ""
echo "Debug APK location:"
echo "  build/app/outputs/flutter-apk/app-debug.apk"
echo ""
echo "To install on a connected device:"
echo "  flutter install"
echo ""
