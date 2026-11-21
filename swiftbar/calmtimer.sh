#!/bin/bash
# <xbar.title>calmtimer</xbar.title>
# <xbar.desc>One-shot timers: label in the menu bar, time left on click</xbar.desc>
# <swiftbar.hideAbout>true</swiftbar.hideAbout>
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>
# <swiftbar.hideLastUpdated>true</swiftbar.hideLastUpdated>
# <swiftbar.hideDisablePlugin>true</swiftbar.hideDisablePlugin>
# <swiftbar.hideSwiftBar>true</swiftbar.hideSwiftBar>

SELF="$(readlink "$0" || echo "$0")"
CLI="$(cd "$(dirname "$SELF")/.." && pwd)/bin/calmtimer"

TIMERS="$("$CLI" list)"
[ -n "$TIMERS" ] || exit 0

now="$(date +%s)"
count="$(printf '%s\n' "$TIMERS" | wc -l | tr -d ' ')"

left() {
  local s=$(($1 - now)) m=$(( ($1 - now + 59) / 60 ))
  if [ "$s" -le 0 ]; then echo "ringing"
  elif [ "$s" -lt 60 ]; then echo "${s}s left"
  elif [ "$m" -lt 60 ]; then echo "${m}m left"
  elif [ $((m % 60)) -eq 0 ]; then echo "$((m / 60))h left"
  else echo "$((m / 60))h $((m % 60))m left"; fi
}

clock() { date -r "$1" "+%l:%M %p" | sed 's/^ //'; }

cancel() { echo "$1 | bash=\"$CLI\" param1=cancel param2=$2 terminal=false refresh=true"; }

IFS=$'\t' read -r end _ _ label <<<"$(printf '%s\n' "$TIMERS" | head -n 1)"
extra=""
[ "$count" -gt 1 ] && extra=" +$((count - 1))"
# perl, not ${label:0:n}: SwiftBar may run us without a UTF-8 locale, where bash would cut mid-character
label="$(perl -CSA -e '$s = shift; print length($s) > 24 ? substr($s, 0, 23) . "\x{2026}" : $s' "$label")"
echo "$label$extra | sfimage=timer sfsize=13 emojize=false"
echo "---"

while IFS=$'\t' read -r end _ id label; do
  info="${label:-Timer} · $(left "$end") · ends $(clock "$end")"
  if [ "$count" -eq 1 ]; then
    echo "$info | disabled=true emojize=false"
    cancel "Cancel" "$id"
  else
    echo "$info | emojize=false"
    cancel "--Cancel" "$id"
  fi
done <<<"$TIMERS"

if [ "$count" -gt 1 ]; then
  echo "---"
  cancel "Cancel all" all
fi
