#!/bin/bash

# ----------------------------------------
# Script Name: postgresql_backup_to_s3.sh
# Author: Hitesh Gupta
# Day: 3
# Description: Create, compress, and upload PostgreSQL database backups to Amazon S3
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

# S3 Configuration
S3_BUCKET="s3://hitesh-postgres-backup/postgresql"

# Create backup directory if it does not exist
mkdir -p "$BACKUP_DIR"

# Logging function
log_message() {
  echo "$(date +"%Y-%m-%d_%H-%M-%S") - $*" | tee -a "$LOG_FILE"
}

# Check if pg_dump is installed
if ! command -v pg_dump >/dev/null 2>&1; then
  log_message "ERROR: pg_dump is not installed."
  exit 1
fi

# Check if AWS CLI is installed
if ! command -v aws >/dev/null 2>&1; then
  log_message "ERROR: AWS CLI is not installed."
  exit 1
fi

# Start backup
log_message "Starting PostgreSQL backup for database: $DB_NAME"

sudo -u "$DB_USER" pg_dump "$DB_NAME" > "$BACKUP_FILE"

# Compress the backup file
gzip "$BACKUP_FILE"
log_message "Backup compressed: ${BACKUP_FILE}.gz"

# Upload backup to S3
aws s3 cp "${BACKUP_FILE}.gz" "$S3_BUCKET/"
log_message "Backup uploaded to S3: $S3_BUCKET"

# Delete local backups older than retention period
find "$BACKUP_DIR" -type f -name "*.sql.gz" -mtime +"$RETENTION_DAYS" -delete

log_message "Backups older than $RETENTION_DAYS days deleted"
log_message "Backup completed successfully: ${BACKUP_FILE}.gz"
