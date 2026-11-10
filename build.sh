#!/bin/bash
# Builds Mumble.app (universal arm64+x86_64, ad-hoc signed) next to this script.
set -euo pipefail
cd "$(dirname "$0")"
VERSION="${VERSION:-1.0.0}"
APP=Mumble.app
rm -rf "$APP"; mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"
for arch in arm64 x86_64; do
  swiftc -O -target ${arch}-apple-macos13.0 -o ".build-$arch" Sources/main.swift 2>&1 | grep -E "error" || true
done
lipo -create .build-arm64 .build-x86_64 -output "$APP/Contents/MacOS/Mumble"
rm -f .build-arm64 .build-x86_64
cp assets/Mumble.icns "$APP/Contents/Resources/"
cat > "$APP/Contents/Info.plist" <<PL
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
<key>CFBundleName</key><string>Mumble</string>
<key>CFBundleDisplayName</key><string>Mumble</string>
<key>CFBundleIdentifier</key><string>fun.buildverse.mumble</string>
<key>CFBundleExecutable</key><string>Mumble</string>
<key>CFBundleIconFile</key><string>Mumble</string>
<key>CFBundleVersion</key><string>${VERSION}</string>
<key>CFBundleShortVersionString</key><string>${VERSION}</string>
<key>CFBundlePackageType</key><string>APPL</string>
<key>LSMinimumSystemVersion</key><string>13.0</string>
<key>NSMicrophoneUsageDescription</key><string>Mumble records your voice while you hold the dictation key.</string>
</dict></plist>
PL
codesign --force --sign - "$APP"
echo "Built $PWD/$APP ($(lipo -archs "$APP/Contents/MacOS/Mumble"))"
