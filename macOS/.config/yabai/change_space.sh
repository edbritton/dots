#!/usr/bin/env sh

set -euo pipefail

if [ $# -eq 0 ]; then
  sleep 0.3

  # Count visible windows on the current space
  visible_count=$(yabai -m query --windows --space \
    | jq -r 'map(select(."is-visible" == true)) | length')

  # If there are visible windows, nothing to do
  if [ "$visible_count" -gt 0 ]; then
    exit 0
  fi
fi

IGNORED_APPS='^(Messages|Signal)$'
CURRENT_SPACE=$(yabai -m query --spaces --space | jq -r '.index')

# Find the next and previous spaces which:
#   - are not currently visible
#   - have at least one window

#target=$(yabai -m query --spaces | jq -r 'map(select(."is-visible" == false and (.windows | length > 0))) | sort_by(.index) | .[0].index')
recent=$(yabai -m query --windows | jq -r --arg excl "$IGNORED_APPS" --arg curr "$CURRENT_SPACE" 'map(select(."is-minimized" == false and .space != ($curr | tonumber) and (.app | test($excl) | not))) | (.[0].space // 1)')
first=$(yabai -m query --windows | jq -r --arg excl "$IGNORED_APPS" --arg curr "$CURRENT_SPACE" 'map(select(."is-minimized" == false and (.app | test($excl) | not))) | sort_by(.space) | .[].space')
next=$(yabai -m query --windows | jq -r --arg excl "$IGNORED_APPS" --arg curr "$CURRENT_SPACE" 'map(select(."is-minimized" == false and (.app | test($excl) | not) and .space > ($curr | tonumber))) | .[].space')
prev=$(yabai -m query --windows | jq -r --arg excl "$IGNORED_APPS" --arg curr "$CURRENT_SPACE" 'map(select(."is-minimized" == false and (.app | test($excl) | not) and .space < ($curr | tonumber))) | .[].space')
last=$(yabai -m query --windows | jq -r --arg excl "$IGNORED_APPS" --arg curr "$CURRENT_SPACE" 'map(select(."is-minimized" == false and (.app | test($excl) | not))) | sort_by(.space) | reverse | .[].space')

if [[ ! $next || $next == null ]]; then
  next=$first
fi

if [[ ! $prev || $prev == null ]]; then
  prev=$last
fi

if [ $# -eq 0 ]; then
  target=$recent
else
  target="$(eval echo \$$1)"
fi

# If no target space found, exit
if [ -z "$target" ]; then
  exit 0
fi

# Trigger skhd hotkey to switch to the target space
skhd -k "ctrl - $target"

# Focus the target space (suppress errors if already focused)
yabai -m space --focus "$target" &>/dev/null
