# Day-2 DevOps Daily Scripting Practice

This folder contains scripts related to **log management and cleanup automation**.

## 1. log-rotation.sh

### Purpose

Automates log rotation, compression, and cleanup to prevent logs from consuming too much disk space.

### What the Script Does

* Defines the directory where application logs are stored.
* Creates an archive directory if it does not exist.
* Moves `.log` files **older than 7 days** to the archive folder.
* Compresses archived logs using **gzip**.
* Deletes archived logs **older than 30 days** to free up disk space.

This script simulates a simple **log rotation system used in production servers** to manage growing log files.


## 2. rotate-and-backup-logs.sh

### Purpose

Automates log file rotation, backup, compression, and cleanup for a single application log file.

### What the Script Does

* Checks whether the log file exists before processing it.
* Creates a backup directory if it does not exist.
* Rotates the current log file by renaming it with a timestamp.
* Creates a new empty log file for the application.
* Compresses the rotated log file using **gzip**.
* Deletes compressed backup files older than the defined retention period.

### Important Note

Sometimes after creating a new log file, the application may fail to write logs because the ownership or permissions of the new file may change.

If that happens, update the ownership of the log file based on the user running the application. Example:

```bash
chown app_user:app_user /var/log/myapp.log