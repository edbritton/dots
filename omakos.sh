#!/bin/bash

set -eu

[ "$(uname)" != "Darwin" ] && echo "macOS required" && exit 1

# Enable TouchID for sudo auth -- required
# This is hard because of macOS privileges being crazy
# Probably need to do this manually
if [ ! -f /etc/pam.d/sudo_local ]; then
  echo "Enable TouchID for sudo authentication"
  echo
  echo "sudo cp /etc/pam.d/sudo_local.template /etc/pam.d/sudo_local"
  echo "sudo echo 'auth       sufficient     pam_tid.so' >> /etc/pam.d/sudo_local"
  sudo cp /etc/pam.d/sudo_local.template /etc/pam.d/sudo_local
  sudo echo 'auth       sufficient     pam_tid.so' >>/etc/pam.d/sudo_local
  exit 1
fi

### Install Homebrew, dotfiles, and packages ###

while true; do
  read -p "Install Omakos packages? [Y/n] " -n 1 -r
  echo
  case "$REPLY" in
  [Yy]* | "")
    if [ ! -x /opt/homebrew/bin/brew ]; then
      echo "Installing Homebrew package manager, may take a little time."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      #echo >> $HOME/.zprofile
      #echo 'eval "$(/opt/homebrew/bin/brew shellenv zsh)"' >> $HOME/.zprofile
      eval "$(/opt/homebrew/bin/brew shellenv zsh)"
    fi

    echo "Clone and stow the dots"
    brew install stow
    git clone https://github.com/edbritton/dots $HOME/.dots
    stow macOS shell git -d $HOME/.dots -t $HOME
    #defaults import com.apple.symbolichotkeys symbolichotkeys.plist && mv symbolichotkeys.plist .symbolichotkeys.plist
    echo "Install packages via brewfile"
    brew bundle --file=$HOME/.brews

    if command -v nvim &>/dev/null; then
      echo "Initialise LazyVim and install Neovim dots"
      mv ~/.config/nvim{,.bak}
      git clone https://github.com/LazyVim/starter ~/.config/nvim
      rm -rf ~/.config/nvim/.git
      stow nvim -d $HOME/.dots -t $HOME
    fi
    break
    ;;
  [Nn]*) ;;
  *) ;;
  esac
done

### System settings ###

while true; do
  read -p "Setup macOS with Omakos system preferences? [Y/n] " -n 1 -r
  echo
  case "$REPLY" in
  [Yy]* | "") ;;
  [Nn]*)
    exit 1
    break
    ;;
  *) ;;
  esac
done

# Reduce number of menu icons in Tahoe
defaults write -g "NSMenuEnableActionImages" -bool false

# Set date format
defaults write -g "AppleICUDateFormatStrings" '{1="y.MM.dd";}'

# Set grown-up time format
defaults write -g "AppleICUForce12HourTime" -bool false
defaults write -g "AppleICUForce24HourTime" -bool true
defaults write "com.apple.menuextra.clock" "ShowAMPM" -bool false

# Auto-delete OTP messages
defaults write "com.apple.onetimepasscodes" "DeleteVerificationCodes" -bool true

# Gaps when tiling windows
defaults write "com.apple.WindowManager" "EnableTiledWindowMargins" -bool true

# Make desktop less annoying
defaults write "com.apple.WindowManager" "StandardHideWidgets" -bool true
defaults write "com.apple.WindowManager" "EnableStandardClickToShowDesktop" -bool false

# Leave desktop spaces where the are thanks
defaults write "com.apple.dock" "mru-spaces" -bool false

# Don't atomatically switch to a space when openning app
defaults write -g "AppleSpacesSwitchOnActivate" -bool false

# Stop sharing analytics for Spotlight
defaults write "com.apple.assistant.support" "Search Queries Data Sharing Status" -int 2

# Use DuckDuckGo
defaults write -g "NSPreferredWebServices" '{NSWebServicesProviderWebSearch={NSDefaultDisplayName=DuckDuckGo;NSProviderIdentifier="com.duckduckgo";};}'

# Safari settings
defaults write "com.apple.Safari" "ShowOverlayStatusBar" -bool true 2>/dev/null || echo "Full Disk Access required for Safari settings"
defaults write "com.apple.Safari" "HomePage" -string "https://start.duckduckgo.com/" 2>/dev/null || true
defaults write "com.apple.Safari" "WekKitDefaultTextEncodingName" -string "utf-8" 2>/dev/null || true
defaults write "com.apple.Safari" "DidGrantSearchProviderAccessToWebNavigationExtensions" -bool true 2>/dev/null || true
defaults write "com.apple.Safari" "SearchProviderIdentifierMigratedToSystemPreference" -bool true 2>/dev/null || true
defaults write "com.apple.Safari" "SearchProviderShortName" -string "DuckDuckGo" 2>/dev/null || true

# Tap to click on trackpads
defaults write "com.apple.AppleMultitouchTrackpad" "Clicking" -bool true
defaults write "com.apple.driver.AppleBluetoothMultitouch.trackpad" "Clicking" -bool true

# Three fingers to display popup extra
#defaults write "com.apple.AppleMultitouchTrackpad" "TrackpadThreeFingerTapGesture" -bool true
#defaults write "com.apple.driver.AppleBluetoothMultitouch.trackpad" "TrackpadThreeFingerTapGesture" -bool true

# Four fingers mission control expose
defaults write "com.apple.AppleMultitouchTrackpad" "TrackpadThreeFingerVertSwipeGesture" -string 1
defaults write "com.apple.driver.AppleBluetoothMultitouch.trackpad" "TrackpadThreeFingerHVertSwipeGesture" -string 1
defaults write "com.apple.AppleMultitouchTrackpad" "TrackpadFourFingerVertSwipeGesture" -string 2
defaults write "com.apple.driver.AppleBluetoothMultitouch.trackpad" "TrackpadFourFingerHVertSwipeGesture" -string 2

# Three fingers swipe for backwards navigation
defaults write "com.apple.AppleMultitouchTrackpad" "TrackpadThreeFingerHorizSwipeGesture" -string 1
defaults write "com.apple.driver.AppleBluetoothMultitouch.trackpad" "TrackpadThreeFingerHorizSwipeGesture" -string 1

# Tap and drag with trackpad
defaults write "com.apple.AppleMultitouchTrackpad" "Dragging" -bool true
defaults write "com.apple.driver.AppleBluetoothMultitouch.trackpad" "Dragging" -bool true

# Set static IP
current_ip="$(ipconfig getifaddr en0)"
ip_base="$(ipconfig getifaddr en0 | sed 's/\.[^.]*$//')"
for i in {100..149}; do
  [ "$ip_base.$i" != "$current_ip" ] && ping -t 1 -c 1 "${ip_base}.${i}" 2>/dev/null | grep -q '1 packets received' && continue
  networksetup -setmanualwithdhcprouter "Wi-Fi" "${ip_base}.${i}" && break
done

# Low power mode when using battery
pmset -g batt 2>/dev/null | grep -q 'Battery' && sudo pmset -b lowpowermode 1

# Avoid DS_Store on USB or Network drives
defaults write "com.apple.desktopservices" "DSDontWriteUSBStores" -bool true
defaults write "com.apple.desktopservices" "DSDontWriteNetworkStores" -bool true

# Default TextEdit to plaintext
defaults write "com.apple.TextEdit" "RichText" -int 0

# Calendar settings
defaults write "com.apple.iCal" "Show Week Numbers" -bool true
defaults write "com.apple.iCal" "TimeZone support enabled" -bool true
defaults write "com.apple.iCal" "first minute of day time range" -int 0
defaults write "com.apple.iCal" "first minute of work hours" -int 360
defaults write "com.apple.iCal" "first shown minute of day" -int 0
defaults write "com.apple.iCal" "last minute of day time range" -int 1440
defaults write "com.apple.iCal" "number of hours displayed" -int 24

# file sharing
#defaults write "com.apple.amp.mediasharingd" "shared-library-id"

# media sharing
#defaults write "com.apple.preferences.sharing.SharingPrefsExtension" "mediaSharingUIStatus" -bool true

# Auto hide dock and menu bar
defaults write "com.apple.dock" "autohide" -bool true # dock
#defaults write -g "_HIHideMenuBar" -bool true # menu bar

# Enable SSH
# (depreciated) sudo systemsetup -setremotelogin on
sudo launchctl load -w /System/Library/LaunchDaemons/ssh.plist

# Enable VNC
#sudo defaults write /var/db/launchd.db/com.apple.launchd/overrides.plist com.apple.screensharing -dict Disabled -bool false
#sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.screensharing.plist

# Refresh to apply changes
killall Dock 2>/dev/null || true
killall ControlCenter 2>/dev/null || true
killall Finder 2>/dev/null || true
killall SytemUIServer 2>/dev/null || true

echo
echo "Remaining settings to manually implement:"
echo
echo "1. Create 4 spaces, set keybindings ^[1,2,3,4] to switch spaces."
echo "2. Set modifier key Caps -> Esc"
