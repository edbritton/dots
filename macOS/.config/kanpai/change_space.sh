#!/usr/bin/env sh

set -euo pipefail

DIRECT_MAX=4

active_is_last() {
  python3 -c '
import ctypes, plistlib, subprocess, sys
cg = ctypes.CDLL("/System/Library/Frameworks/CoreGraphics.framework/CoreGraphics")
cur = cg.CGSGetActiveSpace()
md = plistlib.loads(subprocess.run(["defaults","export","com.apple.spaces","-"],
                                   capture_output=True).stdout
                  )["SpacesDisplayConfiguration"]["Management Data"]
for m in md["Monitors"]:
    ids = [s["id64"] for s in m.get("Spaces") or []]
    if cur in ids:
        sys.exit(0 if ids[-1] == cur else 1)
sys.exit(1)' 2>/dev/null
}

last_space_number() {
  python3 -c '
import ctypes, plistlib, subprocess
cg = ctypes.CDLL("/System/Library/Frameworks/CoreGraphics.framework/CoreGraphics")
cur = cg.CGSGetActiveSpace()
md = plistlib.loads(subprocess.run(["defaults","export","com.apple.spaces","-"],
                                   capture_output=True).stdout
                  )["SpacesDisplayConfiguration"]["Management Data"]
for m in md["Monitors"]:
    ids = [s["id64"] for s in m.get("Spaces") or []]
    if cur in ids:
        print(len(ids))
        break'
}

prev_target() {
  python3 -c '
import ctypes, plistlib, subprocess, time
cg = ctypes.CDLL("/System/Library/Frameworks/CoreGraphics.framework/CoreGraphics")
cur = cg.CGSGetActiveSpace()
md = plistlib.loads(subprocess.run(["defaults","export","com.apple.spaces","-"],
                                   capture_output=True).stdout
                  )["SpacesDisplayConfiguration"]["Management Data"]
for m in md["Monitors"]:
    ids = [s["id64"] for s in m.get("Spaces") or []]
    if cur in ids:
        if ids[0] != cur:
            print("left"); break
        t0 = time.time()
        while time.time()-t0 < 0.3 and (cg.CGEventSourceKeyState(0, 56) or cg.CGEventSourceKeyState(0, 60)):
            time.sleep(0.01)
        print(len(ids)); break
else:
    print("left")'
}

current=$(python3 -c '
import ctypes, plistlib, subprocess
cg = ctypes.CDLL("/System/Library/Frameworks/CoreGraphics.framework/CoreGraphics")
cur = cg.CGSGetActiveSpace()
md = plistlib.loads(subprocess.run(["defaults", "export", "com.apple.spaces", "-"],
                                   capture_output=True).stdout
                  )["SpacesDisplayConfiguration"]["Management Data"]
for m in md["Monitors"]:
    ids = [s["id64"] for s in m.get("Spaces") or []]
    if cur in ids:
        print(ids.index(cur) + 1)
        break')

space_step() {
  target=$1
  [ -n "$current" ] || {
    echo "change_space.sh: could not determine current desktop" >&2
    return 1
  }
  delta=$((target - current))
  [ "$delta" -eq 0 ] && return 0

  if [ "$delta" -gt 0 ]; then key=124; else
    key=123
    delta=$((-delta))
  fi

  i=0
  while [ "$i" -lt "$delta" ]; do
    osascript -e "tell application \"System Events\" to key code $key using control down"
    i=$((i + 1))
    # sleep 0.15
  done
}

focus_active_space() {
  if ! target=$(/Users/ted/Code/Kanpai/.build/debug/kanpai info spaces active "$1" 2>/dev/null); then
    skhd -k "ctrl - 1"
    return
  fi
  case "$target" in
  '' | *[!0-9]*)
    # skhd -k "ctrl - 2"
    return 1
    ;;
  esac

  if [ "$target" -le "$DIRECT_MAX" ]; then
    skhd -k "ctrl - $target"
    sleep 0.3
    if [ "$(/Users/ted/Code/Kanpai/.build/debug/kanpai info spaces current)" = "$target" ]; then
      return
    fi
  fi

  if [ "$target" -gt "$DIRECT_MAX" ]; then
    space_step "$target"
    if [ "$(/Users/ted/Code/Kanpai/.build/debug/kanpai info spaces current)" = "$target" ]; then
      return
    fi
  fi
}

case "${1:-recent}" in
next) focus_active_space next ;;
prev) focus_active_space prev ;;
first) focus_active_space first ;;
last) focus_active_space last ;;
recent) skhd -k 'ctrl - left' ;;
esac

exit 0
