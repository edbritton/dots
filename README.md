Omakos
------

Personal macOS setup. Includes these dots, sets system preferences, and installs some packages.

`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/edbritton/dots/HEAD/omakos.sh)"`


### Window management

Yabai will stop managing a window if it is the only one visible in the space.  

- <kbd>fn + Y</kbd> toggle Yabai globally
- <kbd>lalt + T</kbd> toggle tiling for current window
- <kbd>fn + lalt + T</kbd> toggle tiling for current space


**macOS built-in window management bindings**:

- <kbd>fn + control + left/right</kbd> move current window
- <kbd>shift + fn + control + left/right</kbd> arrange two windows
- <kbd>shift + fn + control + option + left/right</kbd> arrange three windows
- <kbd>fn + control + f</kbd> fill screen (not fullscreen)
- <kbd>fn + control + c</kbd> centre window


After install, creating a file `/etc/pam.d/sudo_local` requires manual creation, because Apple doesn't trust us not to break things. Copying `/etc/pam.d/sudo_local.template` and removing the comment from its final line to enable Terminal TouchID.

```bash
brew bundle --file=~/.brews
```


Other possible tweaks
---------------------

- <https://github.com/m4rkw/macos-corner-fix>
