#!/bin/bash

RATE=8000
CHANNELS=1
FORMAT="s16le"
DURATION_MS=150
BYTES=$(( RATE * 2 * CHANNELS * DURATION_MS / 1000 ))
MAX=32767
BARS=(▁ ▂ ▃ ▄ ▅ ▆ ▇ █)

SOURCE=$(pactl get-default-source 2>/dev/null) || exit 1

level=$(parec --device="$SOURCE" --rate="$RATE" --channels="$CHANNELS" \
  --format="$FORMAT" --raw 2>/dev/null |
  head -c "$BYTES" |
  od -An -td2 -v |
  awk -v max="$MAX" '{ for(i=1;i<=NF;i++) sum_sq+=$i*$i; n+=NF }
       END { if(n==0) print 0; else print int(sqrt(sum_sq/n)*100/max) }'
)

(( level < 0 )) && level=0
(( level > 100 )) && level=100

num=$(( level * 8 / 100 ))
(( num < 0 )) && num=0
(( num > 8 )) && num=8

bar=""
for ((i=0; i<num; i++)); do
  bar="${bar}${BARS[$i]}"
done

if pactl get-source-mute "$SOURCE" 2>/dev/null | grep -q yes; then
  icon=""
  cls="muted"
  ttip="Muted"
elif (( num > 0 )); then
  icon=""
  cls="active"
  ttip="Sound detected: ${bar}"
else
  icon=""
  cls="quiet"
  ttip="No sound detected"
fi

#jq -nc --arg text "$icon $bar " --arg cls "$cls" --arg pct "$level%" '{text: $text, class: $cls, tooltip: ("Mic level: " + $pct)}'
jq -nc --arg text "$icon " --arg cls "$cls" --arg ttip "$ttip" \
  '{text: $text, class: $cls, tooltip: ($ttip)}'
