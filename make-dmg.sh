#!/bin/bash
# Builds Mumble.app then packages Mumble.dmg (drag-to-Applications layout).
set -euo pipefail
cd "$(dirname "$0")"
./build.sh
STAGE=$(mktemp -d)
cp -R Mumble.app "$STAGE/"
ln -s /Applications "$STAGE/Applications"
rm -f Mumble.dmg
hdiutil create -volname "Mumble" -srcfolder "$STAGE" -ov -format UDZO Mumble.dmg >/dev/null
rm -rf "$STAGE"
echo "Created $PWD/Mumble.dmg ($(du -h Mumble.dmg | cut -f1))"
