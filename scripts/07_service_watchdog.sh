#!/usr/bin/env bash

# ==========================================================
# Script Name : 07_service_watchdog.sh
# Description : Monitors daemon health and auto-restarts failed services
# Author      : Mubeen Ali
# ==========================================================

set -euo pipefail

LOG_FILE="logs/service_watchdog.log"
CRITICAL_SERVICES=("ssh" "cron")

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "Starting daemon watchdog check..."

for svc in "${CRITICAL_SERVICES[@]}"; do
    if service "$svc" status >/dev/null 2>&1 || systemctl is-active --quiet "$svc" 2>/dev/null; then
        log "Service status: '$svc' is active and running."
    else
        log "ALERT: Service '$svc' is offline! Initiating auto-recovery..."
        if sudo service "$svc" restart >/dev/null 2>&1 || sudo systemctl restart "$svc" >/dev/null 2>&1; then
            log "RECOVERY: Service '$svc' was successfully restarted."
        else
            log "CRITICAL: Unable to revive service '$svc'. Manual intervention required."
        fi
    fi
done

log "Watchdog inspection cycle concluded."