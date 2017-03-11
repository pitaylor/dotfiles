#!/usr/bin/env bash

if [ -d ~/.dotfiles ]; then
  echo "The ~/.dotfiles directory already exists, please rename or remove before proceeding"
  exit 1
fi

git clone https://github.com/pitaylor/dotfiles.git ~/.dotfiles
~/.dotfiles/install.sh
