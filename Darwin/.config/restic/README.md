# Restic Backup Setup

## 1. Install restic

```
brew install restic
```

## 2. Initialize config files

```
~/.config/restic/init.sh
```

Edit `.env` with your Backblaze B2 credentials and restic repo password.
Edit `includes.txt` with the directories you want to back up.
Edit `excludes.txt` to taste.

## 3. Initialize the restic repository

```
set -a; source ~/.config/restic/.env; set +a
restic init
```

## 4. Test a backup

```
~/.config/restic/backup.sh
```

## 5. Enable the launchd agent

The plist is installed by `install.py` but not loaded automatically. To enable daily backups at noon:

```
launchctl load ~/Library/LaunchAgents/com.github.pitaylor.dotfiles.restic.plist
```

Check status with:

```
launchctl list | grep restic
```

Logs go to `~/Library/Logs/restic-backup.log`.

To disable:

```
launchctl unload ~/Library/LaunchAgents/com.github.pitaylor.dotfiles.restic.plist
```
