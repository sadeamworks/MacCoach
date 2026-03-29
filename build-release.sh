#!/bin/bash
# build-release.sh — Build Mac Coach for Mac App Store submission
# Usage: ./build-release.sh

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

echo "🔨 Building Mac Coach for release..."

# Regenerate Xcode project
echo "📋 Generating Xcode project..."
xcodegen generate

# Clean build folder
echo "🧹 Cleaning build..."
rm -rf build

# Build release archive
echo "📦 Building Release archive..."
xcodebuild archive \
    -project MacCoach.xcodeproj \
    -scheme MacCoach \
    -configuration Release \
    -archivePath build/MacCoach.xcarchive \
    -allowProvisioningUpdates

# Export .pkg
echo "📤 Exporting .pkg..."
if xcodebuild -exportArchive \
    -archivePath build/MacCoach.xcarchive \
    -exportPath build/export \
    -exportOptionsPlist export-options.plist 2>&1; then
    # Export succeeded
    PKG_PATH=$(find build/export -name "*.pkg" | head -1)

    if [ -z "$PKG_PATH" ]; then
        echo "❌ Export failed — no .pkg found"
        exit 1
    fi

    echo "✅ Build complete!"
    echo "📦 Package: $PKG_PATH"
else
    # Export failed (likely missing Apple Developer credentials)
    echo ""
    echo "⚠️  Archive export requires Apple Developer credentials."
    echo ""
    echo "Your .xcarchive is ready at: build/MacCoach.xcarchive"
    echo ""
    echo "To export the .pkg:"
    echo "  1. Open Xcode"
    echo "  2. File → Open → Select build/MacCoach.xcarchive"
    echo "  3. Click 'Distribute App'"
    echo "  4. Choose 'App Store Connect'"
    echo "  5. Follow the prompts to upload"
    echo ""
    echo "Or, set up your Apple Developer credentials and run this script again."
    exit 0
fi
echo ""
echo "Next steps:"
echo "  1. Test the .pkg by installing on a clean Mac"
echo "  2. Upload to App Store Connect:"
echo "     https://appstoreconnect.apple.com"
echo ""
echo "To build and run locally:"
echo "  open build/MacCoach.app"
