#!/bin/sh

CHANNEL=${CHANNEL:-$1}

mkdir -v -p ./build/$CHANNEL
godot-4.3 --export-release --headless $CHANNEL
