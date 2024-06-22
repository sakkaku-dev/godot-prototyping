#!/bin/sh

CHANNEL=${CHANNEL:-$1}

mkdir -v -p ./build/$CHANNEL
godot --export-release --headless $CHANNEL
