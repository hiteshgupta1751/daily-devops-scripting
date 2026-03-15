#!/bin/bash

# Exit if a command fails
set -e

# Main log file
LOG_FILE="/var/log/myapp.log"

# Directory to store rotated logs
BACKUP_DIR="/var/log/myapp-backup"

# Retention in days
RETENTION_DAYS=30

# Timestamp for unique backup name
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

# Create backup directory if it does not exist
mkdir -p "$BACKUP_DIR"

# Check if log file exists
if [ ! -f "$LOG_FILE" ]; then
  echo "Log file not found: $LOG_FILE"
  exit 1
fi

# Rotate the current log file
mv "$LOG_FILE" "$BACKUP_DIR/myapp.log.$TIMESTAMP"

# Create a new empty log file
touch "$LOG_FILE"

# Compress the rotated log file
gzip "$BACKUP_DIR/myapp.log.$TIMESTAMP"

# Delete compressed backups older than 30 days
find "$BACKUP_DIR" -name "*.gz" -mtime +$RETENTION_DAYS -delete

echo "Log rotated, compressed, and old backups cleaned up successfully."
