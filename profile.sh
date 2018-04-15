#!/usr/bin/env bash

# Restic
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

backup() {
  if [[ "${BACKUP_USE_SUDO}" == "1" ]]; then
    sudo -E restic backup "${BACKUP_TARGETS[@]}"
  else
    restic backup "${BACKUP_TARGETS[@]}"
  fi
}

# Aliases
alias dir='ls -l'
alias dotpull='git -C ~/.dotfiles pull && ~/.dotfiles/install.sh && echo "Done!"'
alias less='less --raw'
alias ls='ls -G'
alias tmpaste='tmux save-buffer -'
alias tmcopy='tmux load-buffer -'

# Project directory "cd" aliases
#
# Examples:
# alias cdmyproject="cd ~/projects/my-project"
# alias cdfoobar="cd ~/projects/FooBar
if [ -d ~/projects ]; then
  for d in ~/projects/*/; do
    prefix=$(basename "${d}")
    prefix=${prefix//[^a-zA-Z0-9]/}
    prefix=$(tr '[:upper:]' '[:lower:]' <<< ${prefix})
    [ "${prefix}" != "" ] && alias cd${prefix}="cd \"${d}\""
  done
fi

# Invokes one of several project script variants
p() {
  for script in ./project.sh ./bin/project.sh ./build.sh ./bin/build.sh; do
    if [ -x "${script}" ]; then ${script} "${@}"; return ${?}; fi
  done
  echo 'No project.sh script found'
  return 1
}
