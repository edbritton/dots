Ed's dotfiles
=============

Previous dotfiles on my Mac were too messy to share online. With a fresh install of basecamp/omarchy from @DHH, I've taken the time to create something neat and tidy.

Currently, these dotfiles are for use on either an Omarchy install or macOS. Neither of which uses all of them.


Installing
----------


### Omarchy

The idea of these config files is to be placed on top of the opinionated ones which come bundled in the Omarchy install.

So some of them will be broken without the original source files provided there.

```bash
git clone https://github.com/edbritton/dots $HOME/.dots
sudo pacman -S stow
stow -d ~/.dots
```

If you only want a few configs just select them by name:
```bash
stow walker shell
```


### macOS

On the Mac there is less need for Walker, Elephant, Hyprland, and so on. Therefore the only things needed are perhaps the convienence of consistant shell binaries and personal scripts.

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
git clone https://github.com/edbritton/dots ~/.dots
brew install stow
stow macOS shell git -d ~/.dots
brew bundle --file=~/.brews
```
