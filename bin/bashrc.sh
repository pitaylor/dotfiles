#!/usr/bin/env bash

dotpull() {
  git -C ~/.dotfiles pull && ~/.dotfiles/install.sh
}

[[ -r "/usr/local/etc/profile.d/z.sh" ]] && source "/usr/local/etc/profile.d/z.sh"

alias dir='ls -l'
alias less='less --raw'
alias ls='ls -G'
alias sup=supervisorctl
alias supd=supervisord
alias tmcopy='tmux load-buffer -'
alias tmpaste='tmux save-buffer -'
