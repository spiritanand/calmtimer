#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"

"$ROOT/bin/calmtimer" cancel all >/dev/null 2>&1 || true

unlink_if_ours() { [ -L "$1" ] && [ "$(readlink "$1")" = "$2" ] && rm "$1" && echo "Removed $1"; return 0; }

PLUGINS="$(defaults read com.ameba.SwiftBar PluginDirectory 2>/dev/null || true)"
PLUGINS="${PLUGINS/#\~/$HOME}"
if [ -n "$PLUGINS" ]; then
  for n in 1s 10s; do unlink_if_ours "$PLUGINS/calmtimer.$n.sh" "$ROOT/swiftbar/calmtimer.sh"; done
fi
for p in "$(brew --prefix 2>/dev/null)" /opt/homebrew /usr/local; do
  [ -n "$p" ] && unlink_if_ours "$p/bin/calmtimer" "$ROOT/bin/calmtimer"
done
rm -rf "$HOME/Library/Application Support/calmtimer"

echo "Done. Remove the script directory from Raycast settings if you added it."
