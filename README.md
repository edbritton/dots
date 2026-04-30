Can be used on a macOS install, or *on top* of an Omarchy install.


Omarchy install
---------------

Some of these configs will be broken without the Omarchy source files.

```bash
git clone https://github.com/edbritton/dots $HOME/.dots
sudo pacman -S stow
stow -d ~/.dots
```

If you only want a few configs just select them by name:
```bash
stow walker shell
```


Omakos install
--------------

Personal macOS setup. Includes these dots, sets system preferences, and installs some packages.

`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/edbritton/dots/HEAD/omakos.sh)"`


### Tiling windows solution

I really enjoy the tiling windows or Hyprland, but getting macOS to behave nicely was getting too difficult. Instead, I have learned the keybindings for window manipulation:

- <kbd>fn + control + left/right</kbd> move current window
- <kbd>shift + fn + control + left/right</kbd> arrange two windows
- <kbd>shift + fn + control + option + left/right</kbd> arrange three windows
- <kbd>fn + control + f</kbd> fill screen (not fullscreen)
- <kbd>fn + control + c</kbd> centre window


macOS (manual install)
----------------------

Essentials: `stow macOS shell git`.

`stow macOS` includes:
- Zsh shell (references things in the shell dots)
- Alacritty (for pre-Tahoe Terminal)
- AutoRaise
- Brewfile

`stow shell` includes:
- Starship
- Shell functions
- Aliases
- Zsh options
- Paths and evals (used by macOS/Zsh dots)

After install, creating a file `/etc/pam.d/sudo_local` requires manual creation, because Apple doesn't trust us not to break things. Copying `/etc/pam.d/sudo_local.template` and removing the comment from its final line to enable Terminal TouchID.

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
git clone https://github.com/edbritton/dots ~/.dots
brew install stow
stow macOS shell git -d ~/.dots
brew bundle --file=~/.brews
```
