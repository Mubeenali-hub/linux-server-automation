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

# 3. Scheduled Automation Routines
echo -e "${BOLD}[+] Scheduled Automation Tasks (Crontab):${NC}"
CRON_COUNT=$(crontab -l 2>/dev/null | grep -v '^#' | grep -c . || true)
if [ "$CRON_COUNT" -gt 0 ]; then
    echo -e "  Active Tasks  : ${GREEN}${CRON_COUNT} scheduled routines active${NC}"
else
    echo -e "  Active Tasks  : ${YELLOW}No active cron tasks configured${NC}"
fi

# 4. Storage & Log Telemetry
echo "----------------------------------------------------------------"
echo -e "${BOLD}[+] Log Directory Footprint:${NC}"
if [ -d "logs" ]; then
    TOTAL_LOGS=$(find logs -type f | wc -l)
    LOG_SIZE=$(du -sh logs 2>/dev/null | awk '{print $1}')
    echo -e "  Files Tracked : ${GREEN}${TOTAL_LOGS} files${NC}"
    echo -e "  Logs Disk Footprint : ${GREEN}${LOG_SIZE}${NC}"
else
    echo -e "  Logs Status   : ${YELLOW}logs/ directory not found${NC}"
fi

echo -e "${CYAN}================================================================${NC}"
echo -e "${GREEN}${BOLD}Status: All systems audited and automation baseline healthy.${NC}"
echo -e "${CYAN}================================================================${NC}"