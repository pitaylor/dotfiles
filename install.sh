#!/usr/bin/env bash

# Bootstrap the project
if [ ! -e ~/.dotfiles ]; then
  git clone https://github.com/pitaylor/dotfiles.git ~/.dotfiles
  ~/.dotfiles/install.sh
  exit
fi

make_links() {
  if [ -d "${1}" ]; then
    cp -fvrs "${1}/." "${HOME}"
  fi
}

install_profile() {
  if  [ -e "${2}" ]; then
    grep -q "${1}" "${2}" ||
      printf "\n# Add dotfiles\n[ -s \"${1}\" ] && source \"${1}\"\n" >> "${2}"
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
install_profile "${HOME}/.dotfiles/bin/profile.sh" "${HOME}/.bash_profile" ||
  install_profile "${HOME}/.dotfiles/bin/profile.sh" "${HOME}/.profile"

# Load bashrc.sh from .bashrc
install_profile "${HOME}/.dotfiles/bin/bashrc.sh" "${HOME}/.bashrc"

# Create restic configuration
if [ ! -f ~/.restic ]; then
  cat <<SHELL > ~/.restic
# Backblaze B2 credentials
#export B2_ACCOUNT_ID=backblaze-account-id
#export B2_ACCOUNT_KEY=backblaze-account-key

# Restic repository of the form "b2:<bucket-name>:<path>"
#export RESTIC_REPOSITORY=restic-repository

# Load restic password from a file. Optional, will be prompted otherwise.
#export RESTIC_PASSWORD_FILE=password-file

# Files/directories to backup with "backup" command
export BACKUP_TARGETS=( ~/Documents ~/Pictures )

# Uncomment to use sudo when running restic with "backup" command
#export BACKUP_USE_SUDO=1
SHELL
fi

chmod 600 ~/.restic
source ~/.restic
