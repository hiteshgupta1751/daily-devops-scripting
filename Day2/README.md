# Day-2 DevOps Daily Scripting Practice

This folder contains scripts related to **log management and cleanup automation**.

## log-rotation.sh

### Purpose

Automates log rotation, compression, and cleanup to prevent logs from consuming too much disk space.

### What the Script Does

* Defines the directory where application logs are stored.
* Creates an archive directory if it does not exist.
* Moves `.log` files **older than 7 days** to the archive folder.
* Compresses archived logs using **gzip**.
* Deletes archived logs **older than 30 days** to free up disk space.

This script simulates a simple **log rotation system used in production servers** to manage growing log files.
