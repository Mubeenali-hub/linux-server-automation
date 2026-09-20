#!/usr/bin/env bash

# ==========================================================
# Script Name : 10_master_dashboard.sh
# Description : Unified Master Health & Telemetry Dashboard
# Author      : Mubeen Ali
# ==========================================================

set -euo pipefail

CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m' # No Color

clear

print_banner() {
    echo -e "${CYAN}${BOLD}"
    echo "================================================================"
    echo "       LINUX SERVER AUTOMATION - MASTER HEALTH DASHBOARD        "
    echo "================================================================"
    echo -e "${NC}"
    echo -e "Report Generated at : ${YELLOW}$(date '+%Y-%m-%d %H:%M:%S')${NC}"
    echo -e "Hostname            : ${GREEN}$(hostname)${NC}"
    echo -e "Current User        : ${GREEN}$(whoami)${NC}"
    echo "----------------------------------------------------------------"
}

print_banner