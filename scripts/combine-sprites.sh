#!/bin/sh

TARGET=$1

if [[ -z $TARGET ]]; then
    TARGET="./assets"
else
    TARGET="games/$TARGET/assets"
fi

if [[ ! -d $TARGET ]]; then
    mkdir -p $TARGET
fi

python ./scripts/anim_combine.py -d ./_sprites -o $TARGET -c 10