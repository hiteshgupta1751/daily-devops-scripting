# Day-1 DevOps Daily Scripting Practice

This repository contains simple automation scripts written in Bash as part of daily DevOps practice.
The goal is to build hands-on scripting skills commonly used in real-world infrastructure and operations tasks.

---

## 1. install_nginx.sh

### Purpose

This script installs and configures the **Nginx web server** and creates a custom index page.

### What the Script Does

1. **Stops execution if any command fails**

   * `set -e` ensures the script exits immediately if an error occurs.

2. **Updates the package list**

   * Runs `apt update -y` to fetch the latest package information.

3. **Checks if Nginx is already installed**

   * Uses `dpkg -l | grep nginx`.
   * If Nginx is already installed, the script skips installation.

4. **Installs Nginx if not installed**

   * Runs `apt install nginx -y`.

5. **Creates a custom index page**

   * Writes a simple message to:

   ```
   /var/www/html/index.html
   ```

6. **Enables Nginx to start automatically on boot**

   ```
   systemctl enable nginx
   ```

7. **Starts or restarts the Nginx service**

   ```
   systemctl restart nginx
   ```

8. **Verifies Nginx status**

   * Uses `systemctl is-active --quiet nginx`.
   * If Nginx fails to start, the script exits with an error.

9. **Displays completion message**

   * Prints **"Setup complete."**

---

## 2. service-restart-monitor.sh

### Purpose

This script works as a **service watchdog** that monitors the Nginx service and restarts it automatically if it stops.

### What the Script Does

1. **Defines the service to monitor**

   ```
   SERVICE="nginx"
   ```

2. **Defines a log file**

   ```
   /var/log/nginx-watchdog.log
   ```

   This file records restart attempts and service failures.

3. **Checks if the service is running**

   ```
   systemctl is-active --quiet nginx
   ```

4. **If the service is down**

   * Logs the failure with a timestamp
   * Attempts to restart the service

5. **Verifies the restart result**

   * Logs whether the restart succeeded or failed.

6. **Can be automated with cron**
   Example cron job to check every minute:

```bash
* * * * * /bin/bash /root/service-restart-monitor.sh
```

This ensures the **Nginx service automatically recovers if it crashes.**

---

## Learning Goals

This day focuses on practicing core DevOps automation concepts:

* Bash scripting fundamentals
* Service installation automation
* Service monitoring
* Automatic recovery mechanisms
* Logging operational events
* Using cron for scheduled automation
