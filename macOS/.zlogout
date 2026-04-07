clear
echo
echo "$(system_profiler SPHardwareDataType 2>/dev/null | grep Name | sed 's/.*Model Name: //g'): じゃあまたね!"
