#!/bin/bash

# ----------------------------------------
# Script Name: postgresql_backup.sh
# Author: Hitesh Gupta
# Day: 3
# Description: Create, compress, and retain local PostgreSQL database backups
# ----------------------------------------

# Exit immediately if any command fails
set -euo pipefail

# Configuration
BACKUP_DIR="/backups/postgresql"
DB_NAME="mydb"
DB_USER="postgres"
RETENTION_DAYS=7
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="$BACKUP_DIR/${DB_NAME}_$TIMESTAMP.sql"
LOG_FILE="/var/log/postgresql_backup.log"

# Create backup directory if it does not exist
mkdir -p "$BACKUP_DIR"

# Logging function
log_message() {
  echo "$(date +"%Y-%m-%d %H:%M:%S") - $1" | tee -a "$LOG_FILE"
}

# Check if pg_dump is installed
if ! command -v pg_dump >/dev/null 2>&1; then
  log_message "ERROR: pg_dump is not installed."
  exit 1
fi

# Start backup
log_message "Starting PostgreSQL backup for database: $DB_NAME"

pg_dump -U "$DB_USER" "$DB_NAME" > "$BACKUP_FILE"

# Compress the backup file
gzip "$BACKUP_FILE"
log_message "Backup compressed: ${BACKUP_FILE}.gz"

# Delete backups older than retention period
find "$BACKUP_DIR" -type f -name "*.sql.gz" -mtime +"$RETENTION_DAYS" -delete

log_message "Backups older than $RETENTION_DAYS days deleted"
log_message "Backup completed successfully: ${BACKUP_FILE}.gz"
