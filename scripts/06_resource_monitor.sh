#!/usr/bin/env bash

# ==========================================================
# Script Name : 06_resource_monitor.sh
# Description : Tracks storage and memory usage with threshold alerts
# Author      : Mubeen Ali
# ==========================================================

set -euo pipefail

LOG_FILE="logs/resource_monitor.log"
DISK_THRESHOLD=80
MEM_THRESHOLD=80

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "Starting system resource audit..."

# 1. Disk usage monitoring
CURRENT_DISK=$(df / | awk 'NR==2 {gsub("%",""); print $5}')
log "Current root filesystem disk usage: ${CURRENT_DISK}%"

if [ "$CURRENT_DISK" -ge "$DISK_THRESHOLD" ]; then
    log "WARNING: Disk usage exceeded threshold! Current: ${CURRENT_DISK}% (Threshold: ${DISK_THRESHOLD}%)"
else
    log "Disk health status: OK"
fi

# 2. Memory usage monitoring
MEM_TOTAL=$(free -m | awk '/^Mem:/ {print $2}')
MEM_USED=$(free -m | awk '/^Mem:/ {print $3}')
MEM_PERCENT=$(( 100 * MEM_USED / MEM_TOTAL ))
log "Current memory usage: ${MEM_PERCENT}% (${MEM_USED}MB / ${MEM_TOTAL}MB)"

if [ "$MEM_PERCENT" -ge "$MEM_THRESHOLD" ]; then
    log "WARNING: High memory consumption detected! Current: ${MEM_PERCENT}% (Threshold: ${MEM_THRESHOLD}%)"
else
    log "Memory health status: OK"
fi

log "Resource audit completed successfully."