#!/bin/sh

#
# Simple shell script to backup all GitHub repos
# Usage: github-backup.sh <username> <destination>
# @author Petr Trofimov <petrofimov@yandex.ru>
# Tweaks by Kevin Wojniak

set -ex

USER="$1"
DEST="$2"
API_URL="https://api.github.com/users/${USER}/repos?type=owner"
DATE=$(date +"%Y%m%d")
TEMP_DIR="github_${USER}_${DATE}"
BACKUP_FILE="${TEMP_DIR}.tgz"

cd "$TMPDIR"
mkdir "$TEMP_DIR" && cd "$TEMP_DIR"
curl -s "$API_URL" | grep -Eo '"git_url": "[^"]+"' | awk '{print $2}' | xargs -n 1 git clone
cd -
tar zcf "$BACKUP_FILE" "$TEMP_DIR"
rm -rf "$TEMP_DIR"

# Delete backup files in dest older than 5 days. Ignore errors.
find "${DEST}/github_${USER}_"* -mtime +5 -exec rm {} \; || true

# Move file to destination
mv -f "$BACKUP_FILE" "$DEST"

# Display a notification
osascript -e "display notification \"${BACKUP_FILE}\" with title \"GitHub Backup Completed\""
