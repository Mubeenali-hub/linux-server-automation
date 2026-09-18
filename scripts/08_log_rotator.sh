#!/usr/bin/env bash

# ==========================================================
# Script Name : 08_log_rotator.sh
# Description : Rotates archive logs and audits auth security
# Author      : Mubeen Ali
# ==========================================================

set -euo pipefail

LOG_DIR="logs"
AUDIT_LOG="${LOG_DIR}/log_rotator.log"
RETENTION_DAYS=7

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$AUDIT_LOG"
}

log "Initializing log rotation and security audit suite..."

# Rotate and compress active logs over 1MB
log "Scanning for logs exceeding 1MB threshold..."
find "$LOG_DIR" -type f -name "*.log" ! -name "log_rotator.log" -size +1M | while read -r log_file; do
    TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
    TARGET="${log_file}_${TIMESTAMP}.gz"
    gzip -c "$log_file" > "$TARGET"
    : > "$log_file"
    log "Rotated and compressed: $log_file -> $TARGET"
done

# Purge logs older than retention policy
log "Purging archived logs older than $RETENTION_DAYS days..."
find "$LOG_DIR" -type f -name "*.gz" -mtime +"$RETENTION_DAYS" -exec rm -f {} \;
log "Archive purge cycle completed."

# Security audit: Inspect failed authentication attempts
log "Auditing security logs for unauthorized access attempts..."
AUTH_LOG="/var/log/auth.log"

if [ -f "$AUTH_LOG" ]; then
    FAILED_ATTEMPTS=$(grep -ci "Failed password" "$AUTH_LOG" || true)
    log "Total failed SSH authentication attempts found: $FAILED_ATTEMPTS"
else
    log "Standard auth.log not present, creating clean security audit baseline."
fi

log "Log rotation and security inspection finished successfully."