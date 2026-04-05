#!/bin/bash
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"

create_if_missing() {
  local file="$DIR/$1"
  if [[ -f "$file" ]]; then
    echo "Already exists: $file"
  else
    cat > "$file"
    if [[ "$1" == .env ]]; then
      chmod 600 "$file"
    fi
    echo "Created: $file"
  fi
}

create_if_missing .env <<'EOF'
# Backblaze B2 credentials
B2_ACCOUNT_ID="your-account-id"
B2_ACCOUNT_KEY="your-account-key"

# Restic repository and password
RESTIC_REPOSITORY="b2:your-bucket-name:/"
RESTIC_PASSWORD="your-restic-repo-password"

# Snapshot pruning (disabled by default)
# RESTIC_FORGET_ENABLED="true"
# RESTIC_KEEP_DAILY="7"
# RESTIC_KEEP_WEEKLY="4"
# RESTIC_KEEP_MONTHLY="6"
EOF

create_if_missing includes.txt <<'EOF'
# Add paths to back up, one per line.
# Example:
# /Users/ptaylor/Documents
# /Users/ptaylor/Projects
EOF

create_if_missing excludes.txt <<'EOF'
.DS_Store
.Trash
Library/Caches
node_modules
.cache
__pycache__
*.pyc
.venv
.terraform
EOF

echo "Done. Edit .env and includes.txt, then run: restic init"
