#!/bin/sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
developer=$(xcode-select -p)/Platforms/MacOSX.platform/Developer
source_dir="$root/MapxusMapSample/MapInteraction/BaseMapChange"
output=$(mktemp -d)
trap 'rm -rf "$output"' EXIT

xcrun swiftc -swift-version 5 \
    -I "$developer/usr/lib" \
    -L "$developer/usr/lib" \
    -F "$developer/Library/Frameworks" \
    -Xlinker -rpath -Xlinker "$developer/Library/Frameworks" \
    -Xlinker -rpath -Xlinker "$developer/usr/lib" \
    "$source_dir/GoogleMapSessionManager.swift" \
    "$source_dir/GoogleMapURLProtocol.swift" \
    "$root/MapxusMapSampleTests/GoogleMapNetworkingTests.swift" \
    -o "$output/tests"

"$output/tests"