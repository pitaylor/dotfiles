#!/usr/bin/env bash

# Better bash history
#
# https://www.thomaslaurenson.com/blog/2018/07/02/better-bash-history/

HISTFILESIZE=10000
HISTSIZE=10000
HISTCONTROL=ignoreboth

shopt -s histappend
shopt -s cmdhist

export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$"\n"}history -a; history -c; history -r"

HOMEBREW_PREFIX="$(brew --prefix)"
[[ -r "${HOMEBREW_PREFIX}/etc/profile.d/z.sh" ]] && source "${HOMEBREW_PREFIX}/etc/profile.d/z.sh"

dotbrew() { brew bundle install --file=~/.Brewfile; }
dotpull() { git -C ~/.dotfiles pull && ~/.dotfiles/install.sh; }

alias dir='ls -l'
alias less='less --raw'
alias ls='ls -G'
alias sup=supervisorctl
alias supd=supervisord
alias tmcopy='tmux load-buffer -'
alias tmpaste='tmux save-buffer -'
