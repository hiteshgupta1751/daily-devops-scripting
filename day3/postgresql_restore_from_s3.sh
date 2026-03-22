#!/bin/bash

# ----------------------------------------
# Script Name: postgresql_restore_from_s3.sh
# Author: Hitesh Gupta
# Day: 3
# Description: Download the latest PostgreSQL backup from Amazon S3, extract it, and restore the database
# ----------------------------------------

# Exit immediately if any command fails
set -euo pipefail

# Configuration
DB_NAME="mydb"
DB_USER="postgres"
RESTORE_DIR="/backups/postgresql_restore"
S3_BUCKET="s3://hitesh-postgres-backup/postgresql"
LOG_FILE="/var/log/postgresql_restore.log"

# Create restore directory if it does not exist
mkdir -p "$RESTORE_DIR"

# Logging function
log_message() {
  echo "$(date +"%Y-%m-%d_%H-%M-%S") - $*" | tee -a "$LOG_FILE"
}

# Check if AWS CLI is installed
if ! command -v aws >/dev/null 2>&1; then
  log_message "ERROR: AWS CLI is not installed."
  exit 1
fi

# Check if psql is installed
if ! command -v psql >/dev/null 2>&1; then
  log_message "ERROR: psql is not installed."
  exit 1
fi

# Get latest backup file from S3
LATEST_BACKUP=$(aws s3 ls "$S3_BUCKET/" | sort | tail -n 1 | awk '{print $4}')

if [ -z "$LATEST_BACKUP" ]; then
  log_message "ERROR: No backup file found in S3 bucket."
  exit 1
fi

log_message "Latest backup found: $LATEST_BACKUP"

# Download latest backup
aws s3 cp "$S3_BUCKET/$LATEST_BACKUP" "$RESTORE_DIR/"
log_message "Backup downloaded to: $RESTORE_DIR/$LATEST_BACKUP"

# Unzip backup file
gunzip -f "$RESTORE_DIR/$LATEST_BACKUP"

# Remove .gz extension for restore file
RESTORE_FILE="${RESTORE_DIR}/${LATEST_BACKUP%.gz}"

log_message "Backup extracted: $RESTORE_FILE"

# Restore database
log_message "Starting restore for database: $DB_NAME"
sudo -u "$DB_USER" psql "$DB_NAME" < "$RESTORE_FILE"

log_message "Database restore completed successfully"
