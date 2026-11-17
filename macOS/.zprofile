. /etc/zprofile
. ~/.config/shell/all
. ~/.config/shell/containers
. ~/.config/shell/zoptions

_machine=$(system_profiler SPHardwareDataType 2>/dev/null | sed -n 's/^.*Model Name: \(.*\)$/\1/p')
_osName=$(grep -oE 'SOFTWARE LICENSE AGREEMENT FOR macOS [^\]*' '/System/Library/CoreServices/Setup Assistant.app/Contents/Resources/en.lproj/OSXSoftwareLicense.rtf' | sed -n 's/.*macOS \([^0-9]*\).*$/\1/p' | xargs)

[ -n "$_osName" ] || _osName=$(grep -oaE 'macOS [0-9]+ [A-Z][A-Za-z]+( [A-Z][A-Za-z]+)*' '/System/Library/CoreServices/Setup Assistant.app/Contents/MacOS/Setup Assistant' | sed -n 's/.*macOS [0-9]* //p' | head -1)

clear && sh ~/.config/shell/banner.sh "$_machine" && echo -e "\
$(sw_vers -productName) $_osName $(sw_vers -productVersion) ($(uname -sr)) "

unset _machine _osName
