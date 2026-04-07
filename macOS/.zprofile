. /etc/zprofile

if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv zsh)"
fi

mm="\
                           ▄      ▄
█▀▀▄▀▀▄ ▄▀▀█ █▀▀▀  █▀▀▄▀▀▄ ▄ █▀▀▄ ▄
█  █  █ █  █ █     █  █  █ █ █  █ █
▀  ▀  ▀ ▀▀▀▀ ▀▀▀▀  ▀  ▀  ▀ ▀ ▀  ▀ ▀"

mbn="\
                  ▄              ▄                   
█▀▀▄▀▀▄ ▄▀▀█ █▀▀▀ █▀▀█ █▀▀█ █▀▀█ █  █  █▀▀▄ █▀▀█ █▀▀█
█  █  █ █  █ █    █  █ █  █ █  █ █▀▀▄  █  █ █▀▀▀ █  █
▀  ▀  ▀ ▀▀▀▀ ▀▀▀▀ ▀▀▀▀ ▀▀▀▀ ▀▀▀▀ ▀  ▀  ▀  ▀ ▀▀▀▀ ▀▀▀▀"

machine=$(system_profiler SPHardwareDataType 2>/dev/null | grep Name | sed 's/.*Model Name: //g')
osName=$(grep -oE 'SOFTWARE LICENSE AGREEMENT FOR macOS [^\]*' '/System/Library/CoreServices/Setup Assistant.app/Contents/Resources/en.lproj/OSXSoftwareLicense.rtf' | sed 's/.*macOS //;s/ .*//')

clear && echo -e "\
$([ "$machine" = "Mac mini" ] && echo "$mm")\
$([ "$machine" = "MacBook Neo" ] && echo "$mbn")\

$(sw_vers -productName) $osName $(sw_vers -productVersion) ($(uname -sr)) "
