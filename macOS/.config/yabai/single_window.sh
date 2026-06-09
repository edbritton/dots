#!/usr/bin/env sh

EXCLUDED_APPS='^(LuLu|Calculator|Software Update|Dictionary|VLC|System Preferences|System Settings|zoom.us|Photo Booth|Archive Utility|Python|LibreOffice|App Store|Steam|Alfred|Activity Monitor|Tips|FaceTime|TestFlight|IINA)$'

sleep 0.3

WINDOWS_IN_SPACE=$(yabai -m query --windows --space)
WINDOW_COUNT=$(echo "$WINDOWS_IN_SPACE" | jq --arg excl "$EXCLUDED_APPS" '[.[] | select(."is-visible" == true and ."can-resize" == true and ."is-native-fullscreen" == false and .title != "Open" and (.app | test($excl) | not) )] | length')

#CURRENT_SPACE=$(yabai -m query --spaces --space | jq '.index')
#END=$((56 / (2 ** (WINDOW_COUNT - 1))))
#pad=$((64 / (2 ** (WINDOW_COUNT - 1))))
#case "$WINDOW_COUNT" in
#1) yabai -m space --padding abs:$END:$pad:$pad:$pad && yabai -m space --gap abs:$gap ;;
#2 | 3 | 4)
#  #for gap in $(seq "$(yabai -m config --space $CURRENT_SPACE window_gap)" "$END"); do
#  gap=$((gap ? gap : END))
#  yabai -m space --padding abs:$gap:$pad:$pad:$pad && yabai -m space --gap abs:$gap
#  #done
#  ;;
#*) yabai -m space --padding abs:7:8:8:8 && yabai -m space --gap abs:7 ;;
#esac

if [ "$WINDOW_COUNT" -eq 1 ]; then
  ID=$(echo "$WINDOWS_IN_SPACE" | jq -r --arg excl "$EXCLUDED_APPS" '[.[] | select(."is-visible" == true and ."is-floating" == false and ."can-resize" == true and ."is-native-fullscreen" == false and (.app | test($excl) | not) )][0].id')
  if [ "$ID" ] && [ "$ID" != 'null' ]; then
    yabai -m window $ID --toggle float
    sleep 0.3
    while [ $(yabai -m query --windows --window "$ID" | jq -r '.["is-floating"]') != "true" ]; do
      yabai -m window "$ID" --toggle float
      sleep 0.3
    done
    #yabai -m window $ID --toggle float
    yabai -m window $ID --focus

    APP_NAME=$(echo "$WINDOWS_IN_SPACE" | jq '[.[] | select(."is-visible" == true and ."can-resize" == true and ."is-native-fullscreen" == false)][0].app')

    if [[ "$APP_NAME" =~ ^\"(Obsidian|Snapmaker Orca)\"$ ]]; then
      yabai -m window "$ID" --grid 1:1:0:0:1:1
      skhd -k 'fn + ctrl - f'
    elif [[ "$APP_NAME" =~ ^\"(NotU1|NotYouTube)\"$ ]]; then
      yabai -m window "$ID" --grid 20:20:3:0:14:20
      skhd -k 'fn + ctrl - c'
    else
      #shortcuts run 'Square the window'
      #res=$(system_profiler SPDisplaysDataType | grep Resolution | jq -R 'capture("Resolution:\\s*(?<w>[0-9]+)\\s*x\\s*(?<h>[0-9]+)") | [.w, .h] | map(tonumber)')
      #w=$(echo "$res" | jq '.[0]')
      #h=$(echo "$res" | jq '.[1]')
      #x=$(((w - h) / 2))
      #yabai -m window --grid $h:$w:$x:0:$h:$h
      yabai -m window --grid 10:16:3:0:10:10
      skhd -k 'fn + ctrl - c'
    fi
  fi
elif [ "$WINDOW_COUNT" -gt 1 ]; then
  echo "$WINDOWS_IN_SPACE" | jq -r --arg excl "$EXCLUDED_APPS" 'reverse | .[] | select(."is-visible" == true and ."is-floating" == true and ."can-resize" == true and .title != "Open" and (.app | test($excl) | not) ) .id' | while read -r ID; do
    yabai -m window $ID --toggle float &&
      yabai -m window $ID --swap west
  done
fi
