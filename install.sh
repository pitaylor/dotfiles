#!/usr/bin/env bash

make_links() {
  if [ -d "${1}" ]; then
    cp -fvrs "${1}/." "${HOME}"
  fi
}

install_profile() {
  if  [ -s "${1}" ] && ! grep -q '$HOME/.dotfiles/profile.sh' "${1}"; then
    echo '[ -s "$HOME/.dotfiles/profile.sh" ] && source "$HOME/.dotfiles/profile.sh"' >> "${1}"
  else
    return 1
  fi
}

# On OSX have coreutils preempt default commands
PATH="/usr/local/opt/coreutils/libexec/gnubin:${PATH}"

platform=$(uname)
base_dir=$(readlink --canonicalize "$(dirname "${0}")")

# Create symlinks to files in the "default" directory
make_links "${base_dir}/default"

# Create symlinks to files in the platform-specific directory
make_links "${base_dir}/${platform}"

# Load profile.sh from .bash_profile or .profile
install_profile "${HOME}/.bash_profile" ||
  install_profile "${HOME}/.profile"
