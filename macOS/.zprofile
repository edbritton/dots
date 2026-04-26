. /etc/zprofile
. ~/.config/shell/all
. ~/.config/shell/containers
. ~/.config/shell/zoptions

_machine=$(system_profiler SPHardwareDataType 2>/dev/null | grep Name | sed 's/.*Model Name: //g')
_osName=$(grep -oE 'SOFTWARE LICENSE AGREEMENT FOR macOS [^\]*' '/System/Library/CoreServices/Setup Assistant.app/Contents/Resources/en.lproj/OSXSoftwareLicense.rtf' | sed 's/.*macOS //;s/ .*//')

clear && sh ~/.config/shell/banner.sh "$_machine" && echo -e "\
$(sw_vers -productName) $_osName $(sw_vers -productVersion) ($(uname -sr)) "

unset _machine _osName
