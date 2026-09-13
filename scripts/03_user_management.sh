#!/usr/bin/env bash

# ==========================================================
# Script Name : 03_user_management.sh
# Description : Automates user creation, group assignment, and sudo setup
# Author      : Mubeen Ali
# ==========================================================

set -euo pipefail

LOG_FILE="logs/user_management.log"
TARGET_USER="deployer"
TARGET_GROUP="devops"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "Starting user & group configuration..."

# 1. Ensure target group exists
if getent group "$TARGET_GROUP" >/dev/null 2>&1; then
    log "Group '$TARGET_GROUP' already exists."
else
    log "Creating group '$TARGET_GROUP'..."
    sudo groupadd "$TARGET_GROUP"
    log "Group '$TARGET_GROUP' created successfully."
fi

# 2. Ensure target user exists
if id -u "$TARGET_USER" >/dev/null 2>&1; then
    log "User '$TARGET_USER' already exists."
else
    log "Creating user '$TARGET_USER' with home directory and bash shell..."
    sudo useradd -m -s /bin/bash -g "$TARGET_GROUP" -G sudo "$TARGET_USER"
    log "User '$TARGET_USER' created successfully."
fi

# 3. Configure sudoers rule for non-interactive automation
SUDO_FILE="/etc/sudoers.d/$TARGET_USER"
if [ ! -f "$SUDO_FILE" ]; then
    log "Configuring passwordless sudo rule for '$TARGET_USER'..."
    echo "$TARGET_USER ALL=(ALL) NOPASSWD:ALL" | sudo tee "$SUDO_FILE" >/dev/null
    sudo chmod 0440 "$SUDO_FILE"
    log "Sudoers permissions configured."
else
    log "Sudoers rule for '$TARGET_USER' already in place."
fi

log "User management routine completed successfully."