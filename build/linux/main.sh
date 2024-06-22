#!/bin/sh
echo -ne '\033c\033]0;godot-prototype\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/main.x86_64" "$@"
