#!/usr/bin/env bash

# Aliases
alias dir='ls -l'
alias dotpull='git -C ~/.dotfiles pull && ~/.dotfiles/install.sh && echo "Done!"'
alias less='less --raw'
alias ls='ls -G'

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
}
