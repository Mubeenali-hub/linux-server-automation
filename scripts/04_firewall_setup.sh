#!/usr/bin/env bash

# ==========================================================
# Script Name : 04_firewall_setup.sh
# Description : Configures UFW firewall rules and enables host defense
# Author      : Mubeen Ali
# ==========================================================

set -euo pipefail

LOG_FILE="logs/firewall_setup.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "Starting firewall hardening routine..."

# Ensure ufw is installed
if ! command -v ufw >/dev/null 2>&1; then
    log "UFW not found, installing..."
    sudo apt-get install -y ufw >> "$LOG_FILE" 2>&1
fi

# Reset to clean defaults
log "Resetting default policies..."
sudo ufw --force default deny incoming >> "$LOG_FILE" 2>&1
sudo ufw --force default allow outgoing >> "$LOG_FILE" 2>&1

# Allow essential ports
log "Allowing SSH (port 22)..."
sudo ufw allow 22/tcp >> "$LOG_FILE" 2>&1

log "Allowing HTTP (port 80) and HTTPS (port 443)..."
sudo ufw allow 80/tcp >> "$LOG_FILE" 2>&1
sudo ufw allow 443/tcp >> "$LOG_FILE" 2>&1

# Enable firewall non-interactively
log "Enabling UFW..."
sudo ufw --force enable >> "$LOG_FILE" 2>&1

log "Firewall status:"
sudo ufw status verbose | tee -a "$LOG_FILE"

log "Firewall configuration completed successfully."