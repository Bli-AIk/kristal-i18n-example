#!/bin/sh
set -eu

root=$(CDPATH='' cd -- "$(dirname -- "$0")/../.." && pwd -P)

test -f "$root/mod.lua"
test -f "$root/scripts/world/maps/room1.lua"
test -f "$root/libraries/kristal-i18n/lib.lua"
test -f "$root/libraries/kristal-i18n/lib.json"
luajit -b "$root/libraries/kristal-i18n/lib.lua" /dev/null
