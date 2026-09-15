#!/usr/bin/env bash

# ==========================================================
# Script Name : 05_backup_routine.sh
# Description : Automates timestamped tar.gz backups with log rotation
# Author      : Mubeen Ali
# ==========================================================

set -euo pipefail

BACKUP_SRC="/etc"
BACKUP_DEST="/var/backups/system"
TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
ARCHIVE_NAME="etc_backup_${TIMESTAMP}.tar.gz"
LOG_FILE="logs/backup_routine.log"
RETENTION_DAYS=7

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "Starting backup procedure for '$BACKUP_SRC'..."

# Ensure target backup directory exists
if [ ! -d "$BACKUP_DEST" ]; then
    log "Creating backup directory '$BACKUP_DEST'..."
    sudo mkdir -p "$BACKUP_DEST"
fi

# Create compressed archive
log "Creating archive '$ARCHIVE_NAME'..."
sudo tar -czf "${BACKUP_DEST}/${ARCHIVE_NAME}" -C "$BACKUP_SRC" . >> "$LOG_FILE" 2>&1
log "Backup archive created at ${BACKUP_DEST}/${ARCHIVE_NAME}"

# Cleanup backups older than retention policy
log "Purging backups older than $RETENTION_DAYS days..."
sudo find "$BACKUP_DEST" -type f -name "etc_backup_*.tar.gz" -mtime +"$RETENTION_DAYS" -exec rm -f {} \;

log "Backup routine completed successfully."