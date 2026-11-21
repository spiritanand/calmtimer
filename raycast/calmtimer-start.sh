#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title Start Timer
# @raycast.mode silent
# @raycast.packageName calmtimer
# @raycast.icon ⏱️
# @raycast.argument1 { "type": "text", "placeholder": "60, 1h30, 90s", "optional": true }
# @raycast.argument2 { "type": "text", "placeholder": "label", "optional": true }

exec "$(dirname "$0")/../bin/calmtimer" start "$1" "$2"
