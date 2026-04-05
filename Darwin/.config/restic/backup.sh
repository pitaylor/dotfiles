#!/bin/bash
set -euo pipefail

RESTIC_CONFIG_DIR="$HOME/.config/restic"
LOG_PREFIX="[restic-backup]"

log() { echo "$LOG_PREFIX $(date '+%Y-%m-%d %H:%M:%S') $1"; }

if ! command -v restic &>/dev/null; then
  log "ERROR: restic is not installed. Run: brew install restic"
  exit 1
fi

if [[ ! -f "$RESTIC_CONFIG_DIR/.env" ]]; then
  log "ERROR: $RESTIC_CONFIG_DIR/.env not found. Copy .env.example and fill in your credentials."
  exit 1
fi

set -a
source "$RESTIC_CONFIG_DIR/.env"
set +a

log "Starting backup"

BACKUP_ARGS=(--verbose)
[[ -f "$RESTIC_CONFIG_DIR/includes.txt" ]] && BACKUP_ARGS+=(--files-from "$RESTIC_CONFIG_DIR/includes.txt")
[[ -f "$RESTIC_CONFIG_DIR/excludes.txt" ]] && BACKUP_ARGS+=(--exclude-file "$RESTIC_CONFIG_DIR/excludes.txt")

restic backup "${BACKUP_ARGS[@]}"

if [[ "${RESTIC_FORGET_ENABLED:-false}" == "true" ]]; then
  log "Pruning old snapshots"
  restic forget \
    --keep-daily "${RESTIC_KEEP_DAILY:-7}" \
    --keep-weekly "${RESTIC_KEEP_WEEKLY:-4}" \
    --keep-monthly "${RESTIC_KEEP_MONTHLY:-6}" \
    --prune
fi

log "Done"
