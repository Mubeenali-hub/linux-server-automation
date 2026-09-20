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

# 1. System Load & Telemetry
echo -e "${BOLD}[+] System Telemetry & Hardware Utilization:${NC}"
UPTIME_STR=$(uptime -p 2>/dev/null || uptime | awk -F'( |,|:)+' '{print $6,"hrs",$7,"min"}')
LOAD_AVG=$(awk '{print $1, $2, $3}' /proc/loadavg)
MEM_USAGE=$(free -m | awk '/Mem:/ {printf "Used: %dMB / Total: %dMB (%.1f%%)", $3, $2, $3*100/$2}')
DISK_USAGE=$(df -h / | awk 'NR==2 {printf "Used: %s / Total: %s (%s)", $3, $2, $5}')

echo -e "  Uptime        : ${GREEN}${UPTIME_STR}${NC}"
echo -e "  Load Average  : ${GREEN}${LOAD_AVG}${NC}"
echo -e "  RAM Memory    : ${GREEN}${MEM_USAGE}${NC}"
echo -e "  Root Storage  : ${GREEN}${DISK_USAGE}${NC}"
echo "----------------------------------------------------------------"

# 2. Critical Daemon Status
echo -e "${BOLD}[+] Critical Service Health:${NC}"
SERVICES=("ssh" "cron")

for svc in "${SERVICES[@]}"; do
    if service "$svc" status >/dev/null 2>&1 || systemctl is-active --quiet "$svc" 2>/dev/null; then
        echo -e "  Daemon [${svc}] : ${GREEN}[ACTIVE / RUNNING]${NC}"
    else
        echo -e "  Daemon [${svc}] : ${RED}[OFFLINE / CRITICAL]${NC}"
    fi
done
echo "----------------------------------------------------------------"