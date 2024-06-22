#!/bin/sh

# Deps:
# butler: for itchio

GAME="the-last-archiver"
USER="kuma-gee"
VERSION="$1"

# win, linux, web, macOS, android
CHANNELS=("web" "linux" "win" "macOS")
LAST_TAG=$(git describe --tags --abbrev=0)
CHANGELOG=""

build_channels() {
    for CHANNEL in "${CHANNELS[@]}"; do
        echo "Building channel $CHANNEL"
        rm build/$CHANNEL -rf
        ./scripts/build-channel.sh $CHANNEL
    done
}

itch_release() {
    echo "Releasing version $VERSION to itch.io"

    for CHANNEL in "${CHANNELS[@]}"; do
        echo "Releasing $CHANNEL"
        butler push build/$CHANNEL $USER/$GAME:$CHANNEL --userversion $VERSION
    done
}

VERSION_REGEX='^v[0-9]+\.[0-9]+\.[0-9]+(-rc[0-9]+)?$'
if [[ $VERSION =~ $VERSION_REGEX ]]; then
    sh ./scripts/prepare-build.sh $VERSION
    build_channels
    itch_release
else
    build_channels
    echo "Missing or invalid version. Publish skipped."
fi
