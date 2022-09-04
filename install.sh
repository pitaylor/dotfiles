#!/usr/bin/env bash

create_links() {
  local dir="${1:?dir is missing}"

  if [[ -d "${dir}" ]]; then
    cp -nRsv "${dir}/" "${HOME}"
  fi
}

install_script() {
  local source="${1:?source is missing}"
  local target="${2:?target is missing}"

  if ! grep -q "${source}" "${target}" 2>/dev/null; then
    printf "\n[[ -s \"%s\" ]] && source \"%s\"\n" "${source}" "${source}" >> "${target}"
  fi
}

# On macOS have coreutils preempt default commands
PATH="/usr/local/opt/coreutils/libexec/gnubin:${PATH}"

# Bootstrap the project
if [[ ! -e ~/.dotfiles ]]; then
  git clone https://github.com/pitaylor/dotfiles.git ~/.dotfiles
  ~/.dotfiles/install.sh
  exit
fi

# Symlink platform-agnostic and platform-specific files to home directory
create_links "${HOME}/.dotfiles/Default"
create_links "${HOME}/.dotfiles/$(uname)"

# Hook into .bash_profile and .bashrc
install_script "\${HOME}/.dotfiles/bin/profile.sh" "${HOME}/.bash_profile"
install_script "\${HOME}/.dotfiles/bin/bashrc.sh" "${HOME}/.bashrc"

# Create placeholder tmux file
[[ -e ~/.tmux.local.conf ]] || echo "# Local tmux config goes here" >> ~/.tmux.local.conf

echo "Done!

Commands:
dotbrew - install homebrew packages
dotpull - pull latest dotfiles
"
