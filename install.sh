#!/usr/bin/env bash

set -e
set -o pipefail

# Bootstrap the project
if [[ ! -e ~/.dotfiles ]]; then
  git clone https://github.com/pitaylor/dotfiles.git ~/.dotfiles
  ~/.dotfiles/install.sh
  exit
fi

make_links() {
  local dir="${1:?dir is missing}"

  if [[ -d "${dir}" ]]; then
    cp -fvrs "${dir}/." "${HOME}"
  fi
}

install_profile() {
  local source="${1:?source is missing}"
  local target="${2:?target is missing}"

  if ! grep -q "${source}" "${target}"; then
    printf "\n[[ -s \"${source}\" ]] && source \"${source}\"\n" >> "${target}"
  fi
}

# On macOS have coreutils preempt default commands
PATH="/usr/local/opt/coreutils/libexec/gnubin:${PATH}"

# Symlink platform-agnostic and platform-specific files to home directory
platform=$(uname)
base_dir=$(readlink --canonicalize "$(dirname "${0}")")
make_links "${base_dir}/default"
make_links "${base_dir}/${platform}"

# Hook into .bash_profile and .bashrc
install_profile "\${HOME}/.dotfiles/bin/profile.sh" "${HOME}/.bash_profile"
install_profile "\${HOME}/.dotfiles/bin/bashrc.sh" "${HOME}/.bashrc"

# Install homebrew packages
if type brew &>/dev/null; then
  brew bundle --global
fi

echo 'Done!'
