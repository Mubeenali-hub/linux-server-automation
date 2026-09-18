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