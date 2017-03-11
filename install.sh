#!/usr/bin/env bash

make_links() {
  if [ -d "${1}" ]; then
    cp -fvrs "${1}/." ~
  fi
}

# On OSX have coreutils preempt default commands
PATH="/usr/local/opt/coreutils/libexec/gnubin:${PATH}"

platform=$(uname)
base_dir=$(readlink --canonicalize "$(dirname "${0}")")

make_links "${base_dir}/default"
make_links "${base_dir}/${platform}"
