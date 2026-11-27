#!/bin/sh

export LC_ALL=C.UTF-8

get_glyph() {
  case "$1" in
  a) echo "     ▀▀██▀▀█▀▀▀▀" ;;
  b) echo "▄   █▀▀██  █▀▀▀▀" ;;
  c) echo "    █▀▀▀█   ▀▀▀▀" ;;
  d) echo "   ▄█▀▀██  █▀▀▀▀" ;;
  e) echo "    █▀▀██▀▀▀▀▀▀▀" ;;
  f) echo " ▄▄█  █▀▀▀  " ;;
  g) echo "    █▀▀██▄▄█ ▄▄█" ;;
  h) echo "▄   █▀▀▄█  █▀  ▀" ;;
  i) echo "▄▄█▀" ;;
  j) echo " ▄ ▄ █▄█" ;;
  k) echo "▄   █  ██▀▀▄▀  ▀" ;;
  l) echo "▄ █ █ ▀▀" ;;
  m) echo "       █▀▀▄▀▀▄█  █  █▀  ▀  ▀" ;;
  n) echo "    █▀▀▄█  █▀  ▀" ;;
  o) echo "    █▀▀██  █▀▀▀▀" ;;
  p) echo "    █▀▀██  ██▀▀▀" ;;
  q) echo "    █▀▀██  █▀▀▀█" ;;
  r) echo "   █▀▀█  ▀  " ;;
  s) echo "    █▀▀▀▀▀▀█▀▀▀▀" ;;
  t) echo "▄  █▀▀█  ▀▀▀" ;;
  u) echo "    █  ██  █ ▀▀▀" ;;
  v) echo "    █  ██  █ ▀▀ " ;;
  w) echo "       █  █  ██  █  █▀▀▀ ▀▀ " ;;
  x) echo "    █  █▄▀▀▄▀  ▀" ;;
  y) echo "    █  ██  █ ▀▀█" ;;
  z) echo "    ▀▀▀█▄▀▀ ▀▀▀▀" ;;
  1) echo "   ▀█  █ ▀▀▀" ;;
  2) echo "    ▀▀▀██▀▀▀▀▀▀▀" ;;
  3) echo "    ▀▀▀█▀▀▀█▀▀▀▀" ;;
  5) echo "    █▀▀▀▀▀▀█▀▀▀▀" ;;
  4) echo "    █  █▀▀▀█   ▀" ;;
  6) echo "    █▀▀ █▀▀█▀▀▀▀" ;;
  7) echo "    ▀▀▀█ ▄▀  ▀  " ;;
  8) echo "    █▀▀██▀▀█▀▀▀▀" ;;
  9) echo "    █▀▀█▀▀▀█▀▀▀▀" ;;
  0) echo "    █▀███▄ █▀▀▀▀" ;;
  # using section symbol to fix whitespace issue
  §) echo "" ;;
  _) echo "            ▀▀▀▀" ;;
  /) echo "  ▄ ▄▀▄▀ ▀  " ;;
  -) echo "    ▀▀  " ;;
  \') echo "▄▀  " ;;
  :) echo " ▄▄ " ;;
  .) echo "   ▀" ;;
  ,) echo "   █" ;;
  @) echo "▄▄▄▄▄▄ ██  █▀▀▀▀" ;;
  *) echo " 404" ;;
  esac
}

input="${1}"
input=$(echo "$input" | tr '[:upper:]' '[:lower:]')
input="${input// /§}"

r1="" r2="" r3="" r4=""

i=0
for char in $(echo "$input" | grep -o .); do
  glyph=$(get_glyph "$char")
  len=${#glyph}
  # cpr: characters per row
  cpr=$((len / 4))
  [ $cpr -eq 0 ] && cpr=1

  prefix=" "
  [ "$i" == 0 ] && prefix=""
  [ "$prev_char" == "/" ] && [ "$char" == "/" ] && prefix=""
  [ "$prev_char" == "-" ] && [ "$char" == "-" ] && prefix=""
  [ "$prev_char" == "r" ] && [ "$char" == "j" ] && prefix=""
  [ "$prev_char" == "r" ] && [ "$char" == "a" ] && prefix=""
  [ "$prev_char" == "6" ] && [ "$char" == "7" ] && prefix=""
  [ "$prev_char" == "1" ] && [ "$char" == "7" ] && prefix=""
  [ "$prev_char" == "1" ] && [ "$char" == "4" ] && prefix=""

  r1="$r1$prefix${glyph:0:$cpr}"
  r2="$r2$prefix${glyph:$cpr:$cpr}"
  r3="$r3$prefix${glyph:$((cpr * 2)):$cpr}"
  r4="$r4$prefix${glyph:$((cpr * 3)):$cpr}"

  prev_char="$char"
  i=$((i + 1))
done

# repeating echo for cross compatibility issue
echo "\033[34m$r1\033[0m"
echo "\033[34m$r2\033[0m"
echo "\033[34m$r3\033[0m"
echo "\033[34m$r4\033[0m"
