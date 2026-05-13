#!/usr/bin/env sh

EXCLUDED_APPS='^(LuLu|Calculator|Software Update|Dictionary|VLC|System Preferences|System Settings|zoom.us|Photo Booth|Archive Utility|Python|LibreOffice|App Store|Steam|Alfred|Activity Monitor)$'

WINDOWS_IN_SPACE=$(yabai -m query --windows --space)
WINDOW_COUNT=$(echo "$WINDOWS_IN_SPACE" | jq --arg excl "$EXCLUDED_APPS" '[.[] | select(."is-visible"==true and ."can-resize"==true and (.app | test($excl) | not) )] | length')

if [ "$WINDOW_COUNT" -eq 1 ]; then
  ID=$(echo "$WINDOWS_IN_SPACE" | jq -r --arg excl "$EXCLUDED_APPS" '[.[] | select(."is-visible"==true and ."is-floating"==false and ."can-resize"==true and ."is-native-fullscreen"==false and (.app | test($excl) | not) )][0].id')
  if [ "$ID" ] && [ "$ID" != 'null' ]; then
    yabai -m window $ID --toggle float
    yabai -m window $ID --focus
    shortcuts run 'Centre Square'
  fi
elif [ "$WINDOW_COUNT" -eq 2 ]; then
  echo "$WINDOWS_IN_SPACE" | jq -r --arg excl "$EXCLUDED_APPS" '.[] | select(."is-visible"==true and ."is-floating"==true and ."can-resize"==true and (.app | test($excl) | not) ) .id' | while read -r ID; do
    yabai -m window $ID --toggle float &&
      yabai -m window $ID --swap west
  done
fi
