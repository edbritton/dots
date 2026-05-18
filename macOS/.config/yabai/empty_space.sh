#!/usr/bin/env sh

set -euo pipefail

# Brief delay to allow yabai state to settle after window close
sleep 0.3

# Count visible windows on the current space
visible_count=$(yabai -m query --windows --space \
  | jq -r 'map(select(."is-visible" == true)) | length')

# If there are visible windows, nothing to do
if [ "$visible_count" -gt 0 ]; then
  exit 0
fi

EXCLUDED_APPS='^(Messages|Signal)$'
CURRENT_SPACE=$(yabai -m query --spaces --space | jq -r '.index')

# Find the next space that:
#   - is not currently visible
#   - has at least one window
# Then sort by index and grab the first match
target=$(yabai -m query --spaces \
  | jq -r 'map(select(."is-visible" == false and (.windows | length > 0)))
           | sort_by(.index)
           | .[0].index')
target=$(yabai -m query --windows | jq -r --arg excl "$EXCLUDED_APPS" --arg curr "$CURRENT_SPACE" 'map(select(."is-minimized" == false and .space != ($curr | tonumber) and (.app | test($excl) | not))) | (.[0].space // 1)')

# If no target space found, exit
if [ -z "$target" ]; then
  exit 0
fi

# Trigger skhd hotkey to switch to the target space
skhd -k "ctrl - $target"

# Focus the target space (suppress errors if already focused)
yabai -m space --focus "$target" &>/dev/null
