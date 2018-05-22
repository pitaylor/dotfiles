#!/usr/bin/env bash

backup() {
  if [[ "${BACKUP_USE_SUDO}" == "1" ]]; then
    sudo -E restic backup "${BACKUP_TARGETS[@]}"
    sudo chown -R $(id -u):$(id -g) ~/.cache/restic
  else
    restic backup "${BACKUP_TARGETS[@]}"
  fi
}
