#!/usr/bin/env bash

# ==========================================================
# Script Name : 09_cron_automation.sh
# Description : Configures scheduled cron jobs for sysadmin routines
# Author      : Mubeen Ali
# ==========================================================

set -euo pipefail

LOG_FILE="logs/cron_automation.log"
WORKSPACE_DIR="$(pwd)"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "Initializing automated cron scheduler setup..."
log "Detected project root: ${WORKSPACE_DIR}" 

# Define scheduled tasks
CRON_BACKUP="0 2 * * * ${WORKSPACE_DIR}/scripts/05_backup_routine.sh >/dev/null 2>&1"
CRON_MONITOR="*/30 * * * * ${WORKSPACE_DIR}/scripts/06_resource_monitor.sh >/dev/null 2>&1"
CRON_WATCHDOG="*/15 * * * * ${WORKSPACE_DIR}/scripts/07_service_watchdog.sh >/dev/null 2>&1"
CRON_ROTATOR="0 0 * * * ${WORKSPACE_DIR}/scripts/08_log_rotator.sh >/dev/null 2>&1"

TMP_CRON=$(mktemp)

# Preserve current crontab entries if any exist
crontab -l 2>/dev/null > "$TMP_CRON" || true

# Append tasks safely with duplicate prevention
add_job_if_missing() {
    local job="$1"
    local desc="$2"
    if grep -Fq "$job" "$TMP_CRON"; then
        log "Cron schedule already exists for: $desc"
    else
        echo "$job" >> "$TMP_CRON"
        log "Scheduled new cron job: $desc"
    fi
}

log "Registering automated system jobs..."
add_job_if_missing "$CRON_BACKUP" "Daily 2 AM Backup Routine"
add_job_if_missing "$CRON_MONITOR" "Every 30 Mins Resource Monitor"
add_job_if_missing "$CRON_WATCHDOG" "Every 15 Mins Service Watchdog"
add_job_if_missing "$CRON_ROTATOR" "Daily Midnight Log Rotation"