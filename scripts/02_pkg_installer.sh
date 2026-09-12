#!/usr/bin/env bash

# ==========================================================
# Script Name : 02_pkg_installer.sh
# Description : Updates package indices and installs core sysadmin tools
# Author      : Mubeen Ali
# ==========================================================

set -euo pipefail

LOG_FILE="logs/pkg_installer.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "Starting system package update..."

# Update repository lists
sudo apt-get update -y >> "$LOG_FILE" 2>&1

# Define essential utility packages
PACKAGES=(
    curl
    wget
    git
    htop
    net-tools
    ufw
    unzip
)

log "Checking and installing required utilities..."

for pkg in "${PACKAGES[@]}"; do
    if dpkg -s "$pkg" >/dev/null 2>&1; then
        log "Package '$pkg' is already installed."
    else
        log "Installing '$pkg'..."
        sudo apt-get install -y "$pkg" >> "$LOG_FILE" 2>&1
        log "Package '$pkg' installed successfully."
    fi
done

log "Package installation process completed."