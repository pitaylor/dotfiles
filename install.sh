#!/usr/bin/env bash

set -e
set -o pipefail

# On macOS have coreutils preempt default commands
PATH="/usr/local/opt/coreutils/libexec/gnubin:${PATH}"

# Bootstrap the project
if [[ ! -e ~/.dotfiles ]]; then
  git clone https://github.com/pitaylor/dotfiles.git ~/.dotfiles
  ~/.dotfiles/install.sh
  exit
fi

create_links() {
  local dir="${1:?dir is missing}"

  if [[ -d "${dir}" ]]; then
    cp -fvrs "${dir}/." "${HOME}"
  fi
}

install_script() {
  local source="${1:?source is missing}"
  local target="${2:?target is missing}"

  if ! grep -q "${source}" "${target}"; then
    printf "\n[[ -s \"${source}\" ]] && source \"${source}\"\n" >> "${target}"
  fi
}

# Symlink platform-agnostic and platform-specific files to home directory
create_links "${HOME}/.dotfiles/Default"
create_links "${HOME}/.dotfiles/$(uname)"

# Hook into .bash_profile and .bashrc
install_script "\${HOME}/.dotfiles/bin/profile.sh" "${HOME}/.bash_profile"
install_script "\${HOME}/.dotfiles/bin/bashrc.sh" "${HOME}/.bashrc"

echo 'Done!'
