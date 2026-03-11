#!/bin/bash

# Directory where application logs are currently stored
LOG_DIR="/var/log/myapp"

# Directory where old logs will be archived
ARCHIVE_DIR="/var/log/myapp/archive"

# Create archive directory if it does not exist
mkdir -p $ARCHIVE_DIR

# Find all .log files older than 7 days and move them to the archive directory
find $LOG_DIR/*.log -mtime +7 -exec mv {} $ARCHIVE_DIR \;

# Compress archived log files to save disk space
gzip $ARCHIVE_DIR/*.log
# Remove archived log files older than 30 days to free up space
find $ARCHIVE_DIR/*.gz -mtime +30 -exec rm {} \;