eval "$(starship init zsh)"

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias c='opencode'
alias decompress='tar -xzf'
alias eff='$EDITOR "$(ff)"'
alias ff='fzf --preview '\''bat --style=numbers --color=always {}'\'''
alias lzg='lazygit'
alias v='vim'

alias docker='container'
alias d='docker'
alias lzc='lazycontainer'
alias lazydocker='lzc'
alias lzd='lazydocker'

alias g='git'
alias gcad='git commit -a --amend'
alias gcam='git commit -a -m'
alias gcm='git commit -m'

alias ls='eza -lh --group-directories-first --icons=auto'
alias lsa='ls -a'
alias lt='eza --tree --level=2 --long --icons --git'
alias lta='lt -a'

alias today='fd --changed-after 1day'
