#!/bin/bash
# Builds DScribe.app then packages DScribe.dmg (drag-to-Applications layout).
set -euo pipefail
cd "$(dirname "$0")"
./build.sh
STAGE=$(mktemp -d)
cp -R DScribe.app "$STAGE/"
ln -s /Applications "$STAGE/Applications"
rm -f DScribe.dmg
hdiutil create -volname "DScribe" -srcfolder "$STAGE" -ov -format UDZO DScribe.dmg >/dev/null
rm -rf "$STAGE"
echo "Created $PWD/DScribe.dmg ($(du -h DScribe.dmg | cut -f1))"
