Can be used on a macOS install, or *on top* of an Omarchy install.


Omarchy
-------

Some of these configs will be broken without the Omarchy source files.


### Install

```bash
git clone https://github.com/edbritton/dots $HOME/.dots
sudo pacman -S stow
stow -d ~/.dots
```

If you only want a few configs just select them by name:
```bash
stow walker shell
```


macOS
-----

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


### Quick install

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
git clone https://github.com/edbritton/dots ~/.dots
brew install stow
stow macOS shell git -d ~/.dots
brew bundle --file=~/.brews
```
