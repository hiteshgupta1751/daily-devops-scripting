# Day-3 DevOps Daily Scripting Practice

This folder contains scripts related to **database backup, storage, and recovery automation**.

## 1. postgresql_backup.sh

### Purpose

Automates PostgreSQL database backup by creating, compressing, and retaining backups on the local server.

### What the Script Does

* Checks if `pg_dump` is installed before taking backup.
* Creates a backup directory if it does not exist.
* Takes a database backup with a timestamp.
* Compresses the backup file using **gzip**.
* Deletes old backups based on the defined retention period.
* Logs all operations for better tracking and debugging.

---

## 2. postgresql_backup_to_s3.sh

### Purpose

Extends the backup process by storing backups in **Amazon S3** for off-server storage and disaster recovery.

### What the Script Does

* Takes a PostgreSQL database backup.
* Compresses the backup file.
* Uploads the backup to an S3 bucket.
* Maintains local backups with retention policy.
* Logs all operations.

---

## 3. postgresql_restore_from_s3.sh

### Purpose

Restores the PostgreSQL database using the **latest backup from S3**.

### What the Script Does

* Fetches the latest backup file from S3.
* Downloads it to the local server.
* Extracts the compressed backup file.
* Restores the database using `psql`.
* Logs all restore operations.

---

## Summary

These scripts together implement a complete **DevOps backup and recovery workflow**:

- Local Backup  
- Remote Backup (S3)  
- Restore from Latest Backup  

This simulates real-world production practices for ensuring **data safety, disaster recovery, and system reliability**.
