#!/usr/bin/env bash

# Suppress zsh message on macOS
export BASH_SILENCE_DEPRECATION_WARNING=1

# Source homebrew completion scripts
if type brew &>/dev/null; then
  HOMEBREW_PREFIX="$(brew --prefix)"
  if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
      [[ -r "$COMPLETION" ]] && source "$COMPLETION"
    done
  fi
fi

# Source docker completion scripts
if [[ -d /Applications/Docker.app/Contents/Resources/etc/ ]]; then
  for COMPLETION in /Applications/Docker.app/Contents/Resources/etc/*.bash-completion; do
    [[ -r "${COMPLETION}" ]] && source "${COMPLETION}"
  done
fi
