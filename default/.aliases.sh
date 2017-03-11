#!/usr/bin/env bash

alias dir='ls -l'
alias less='less --raw'
alias ls='ls -G'

dotsync() {
  git -C ~/.dotfiles pull
  ~/.dotfiles/install.sh
}
