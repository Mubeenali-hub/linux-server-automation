 # Linux Server Automation & Hardening Suite

A production-ready collection of Bash automation scripts designed for modern Linux sysadmins and DevOps engineers. This suite covers system telemetry, security hardening, resource monitoring, automated backups, and unified health reporting.

---

## Architecture & Project Structure

```text
linux-server-automation/
├── scripts/
│   ├── 01_system_info.sh       # Hardware specs & telemetry
│   ├── 02_pkg_installer.sh      # Essential sysadmin toolchains
│   ├── 03_user_management.sh   # User creation & secure sudo access
│   ├── 04_firewall_setup.sh    # UFW firewall & port security
│   ├── 05_backup_routine.sh    # Automated backups & 7-day retention
│   ├── 06_resource_monitor.sh  # Storage & RAM utilization alarms
│   ├── 07_service_watchdog.sh  # Daemon monitor & auto-recovery
│   ├── 08_log_rotator.sh       # Log compression & failed SSH audit
│   ├── 09_cron_automation.sh   # Crontab scheduler automation
│   └── 10_master_dashboard.sh  # Unified ASCII health dashboard
├── logs/                       # Automated execution logs
└── README.md
```

---

## 10-Day Automation Roadmap

- [x] **Day 1:** `scripts/01_system_info.sh` — Hardware baseline and telemetry collection
- [x] **Day 2:** `scripts/02_pkg_installer.sh` — Automated package management and core utilities setup
- [x] **Day 3:** `scripts/03_user_management.sh` — Secure user isolation, group assignment, and sudo elevation
- [x] **Day 4:** `scripts/04_firewall_setup.sh` — UFW policy enforcement, SSH hardening, and rate limiting
- [x] **Day 5:** `scripts/05_backup_routine.sh` — Tarball archive rotation with automated 7-day retention purge
- [x] **Day 6:** `scripts/06_resource_monitor.sh` — CPU, RAM, and Disk threshold monitoring with alerting
- [x] **Day 7:** `scripts/07_service_watchdog.sh` — Autonomous daemon watchdog and self-healing service loops
- [x] **Day 8:** `scripts/08_log_rotator.sh` — Log compression routine and failed SSH intrusion auditing
- [x] **Day 9:** `scripts/09_cron_automation.sh` — Idempotent crontab registration for end-to-end automation
- [x] **Day 10:** `scripts/10_master_dashboard.sh` — Terminal-based unified master telemetry and health console

---

## Quick Start & Usage

Clone the repository and make scripts executable:

```bash
git clone [https://github.com/Mubeenali-hub/linux-server-automation.git](https://github.com/Mubeenali-hub/linux-server-automation.git)
cd linux-server-automation
chmod +x scripts/*.sh
```

Run the master health dashboard:

```bash
./scripts/10_master_dashboard.sh
```

To configure automated schedules across your host:

```bash
./scripts/09_cron_automation.sh
```

---

## Author
**Mubeen Ali**  
DevOps & Linux Automation Portfolio