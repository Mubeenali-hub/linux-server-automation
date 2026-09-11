#!/usr/bin/env bash

# ==========================================================
# Script Name : 01_system_info.sh
# Description : Collects basic system hardware and OS specs
# Author      : Mubeen Ali
# ==========================================================

set -euo pipefail

echo "=========================================="
echo "         LINUX SYSTEM INFORMATION         "
echo "=========================================="
echo "Hostname      : $(hostname)"
echo "Current User  : $(whoami)"
echo "Date & Time   : $(date '+%Y-%m-%d %H:%M:%S')"
echo "Uptime        : $(uptime -p)"
echo "OS Name       : $(grep -w 'PRETTY_NAME' /etc/os-release | cut -d= -f2 | tr -d '\"')"
echo "Kernel Version: $(uname -r)"
echo "Architecture  : $(uname -m)"
echo "------------------------------------------"
echo "CPU Model     : $(lscpu | grep 'Model name' | sed 's/Model name:[ \t]*//')"
echo "Total Cores   : $(nproc)"
echo "Memory Usage  :"
free -h | awk 'NR==1{printf "  %-10s %-10s %-10s\n", $1,$2,$3} NR==2{printf "  %-10s %-10s %-10s\n", "RAM", $2, $3}'
echo "Disk Usage (/):"
df -h / | awk 'NR==2 {print "  Total: "$2" | Used: "$3" | Available: "$4" ("$5" used)"}'
echo "IP Addresses  :"
ip -4 addr show | awk '/inet / {print "  - "$2" ("$NF")"}'
echo "=========================================="