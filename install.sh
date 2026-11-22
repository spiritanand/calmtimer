#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"

die() { echo "install.sh: $1" >&2; exit 2; }
say() { printf '\033[1m==>\033[0m %s\n' "$1"; }

[ "$(uname)" = Darwin ] || die "calmtimer needs macOS"
# shellcheck disable=SC1003
case $ROOT in *'"'*|*'\'*) die "move calmtimer to a folder whose path has no quotes or backslashes" ;; esac
if ! command -v brew >/dev/null; then
  for b in /opt/homebrew/bin/brew /usr/local/bin/brew; do [ -x "$b" ] && eval "$("$b" shellenv)" && break; done
  command -v brew >/dev/null || die "Homebrew is required: https://brew.sh"
fi
BREW_PREFIX="$(brew --prefix)"

if [ ! -d /Applications/SwiftBar.app ] && ! brew list --cask swiftbar >/dev/null 2>&1; then
  say "Installing SwiftBar"
  brew install --cask swiftbar
fi

say "Adding the menu bar plugin"
PLUGINS="$(defaults read com.ameba.SwiftBar PluginDirectory 2>/dev/null || true)"
PLUGINS="${PLUGINS/#\~/$HOME}"
if [ -z "$PLUGINS" ]; then
  PLUGINS="$HOME/.config/swiftbar"
  defaults write com.ameba.SwiftBar PluginDirectory "$PLUGINS"
fi
mkdir -p "$PLUGINS"
# 1s so the countdown ticks; older installs linked it as calmtimer.10s.sh
[ "$(readlink "$PLUGINS/calmtimer.10s.sh" 2>/dev/null)" = "$ROOT/swiftbar/calmtimer.sh" ] && rm "$PLUGINS/calmtimer.10s.sh"
ln -sf "$ROOT/swiftbar/calmtimer.sh" "$PLUGINS/calmtimer.1s.sh"

say "Linking the calmtimer command"
ln -sf "$ROOT/bin/calmtimer" "$BREW_PREFIX/bin/calmtimer"

if pgrep -xq SwiftBar; then
  open -g "swiftbar://refreshallplugins"
else
  open -g -a SwiftBar
fi

cat <<EOF

Done. Try it: calmtimer start 5s test

Raycast: Settings → Extensions → + → Add Script Directory → $ROOT/raycast
Then give "Start Timer" the alias t, and type: t 60 tea (Tab or a space before the label both work)
EOF
