# calmtimer

A one-shot timer for macOS, started from Raycast. Type `t 60 tea`, and an hour later a soft note plays twice and a notification says the tea timer is done.

calmpomo's quieter sibling: no cycles, no breaks, one timer and a ting.

## What you see

While a timer runs, the menu bar shows a timer icon and its label (`⏱ tea`), without a countdown. Click it to see time left and when it ends, and to cancel. With more than one timer it shows the one ending first plus a count (`⏱ tea +1`), and each timer gets its own Cancel. When nothing is running the item disappears.

## Durations

| You type | Timer |
|---|---|
| `60` or nothing | 60 minutes (a bare number is minutes) |
| `1h30`, `1h 30m`, `1.5h` | 90 minutes |
| `90s`, `2m30s`, `2m30` | seconds work too |
| `60 tea` in one field | 60 minutes labelled tea (same as Tab to the label field) |

Anything up to 24 hours. Input it can't read starts a 60-minute timer and says so.

## Install

Needs [Homebrew](https://brew.sh). Installs [SwiftBar](https://github.com/swiftbar/SwiftBar) if missing.

```
./install.sh
calmtimer start 5s test
```

Then in Raycast: Settings → Extensions → **+** → **Add Script Directory** → pick the `raycast` folder here, and give **Start Timer** the alias `t`.

The installed pieces link back to this folder, so keep it where it is. `./uninstall.sh` removes them.

## Command line

```
calmtimer start [DURATION] [LABEL...]
calmtimer cancel ID|all
calmtimer list
```

On the command line, quote a duration with spaces: `calmtimer start "1h 30m" tea`.

Timers live as small files in `~/Library/Application Support/calmtimer/timers`. They count real clock time, so a timer that ends while the Mac sleeps rings right after it wakes. Timers don't survive a restart.

The sound is calmpomo's break-end note.
