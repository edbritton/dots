#!/usr/bin/env sh

EXCLUDED_APPS='^(LuLu|Calculator|Software Update|Dictionary|VLC|System Preferences|System Settings|zoom.us|Photo Booth|Archive Utility|Python|LibreOffice|App Store|Steam|Alfred|Activity Monitor|Tips|FaceTime)$'

sleep 0.3

WINDOWS_IN_SPACE=$(yabai -m query --windows --space)
WINDOW_COUNT=$(echo "$WINDOWS_IN_SPACE" | jq --arg excl "$EXCLUDED_APPS" '[.[] | select(."is-visible"==true and ."can-resize"==true and ."is-native-fullscreen"==false and (.app | test($excl) | not) )] | length')

if [ "$WINDOW_COUNT" -eq 1 ]; then
  ID=$(echo "$WINDOWS_IN_SPACE" | jq -r --arg excl "$EXCLUDED_APPS" '[.[] | select(."is-visible"==true and ."is-floating"==false and ."can-resize"==true and ."is-native-fullscreen"==false and (.app | test($excl) | not) )][0].id')
  if [ "$ID" ] && [ "$ID" != 'null' ]; then
    yabai -m window $ID --toggle float
    sleep 0.3
    while [ $(yabai -m query --windows --window "$ID" | jq -r '.["is-floating"]') != "true" ]; do
      yabai -m window "$ID" --toggle float
      sleep 0.3
    done
    #yabai -m window $ID --toggle float
    yabai -m window $ID --focus

    APP_NAME=$(echo "$WINDOWS_IN_SPACE" | jq --arg excl "$EXCLUDED_APPS" '[.[] | select(."is-visible"==true and ."can-resize"==true and ."is-native-fullscreen"==false and (.app | test($excl) | not) )][0].app')

    if [ "$APP_NAME" == \"Obsidian\" ]; then
      #skhd -k 'fn + ctrl - f'
      yabai -m window "$ID" --grid 1:1:0:0:1:1
    else
      #shortcuts run 'Square the window'
      res=$(system_profiler SPDisplaysDataType | grep Resolution | jq -R 'capture("Resolution:\\s*(?<w>[0-9]+)\\s*x\\s*(?<h>[0-9]+)") | [.w, .h] | map(tonumber)')
      w=$(echo "$res" | jq '.[0]')
      h=$(echo "$res" | jq '.[1]')
      x=$(((w - h) / 2))
      yabai -m window --grid $h:$w:$x:0:$h:$h
    fi
  fi
elif [ "$WINDOW_COUNT" -gt 1 ]; then
  echo "$WINDOWS_IN_SPACE" | jq -r --arg excl "$EXCLUDED_APPS" 'reverse | .[] | select(."is-visible" == true and ."is-floating" == true and ."can-resize" == true and (.app | test($excl) | not) ) .id' | while read -r ID; do
    yabai -m window $ID --toggle float &&
      yabai -m window $ID --swap west
  done
fi
