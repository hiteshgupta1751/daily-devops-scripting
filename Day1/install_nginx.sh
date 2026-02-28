#!/bin/bash

# ----------------------------------------
# Script Name: 01_install_nginx.sh
# Author: Hitesh Gupta
# Day: 1
# Description: Install and configure Nginx with a custom index page
# ----------------------------------------

# Exit immediately if any command fails
set -e

# Updates your local package list

echo "Updating packages..."
apt update -y

# Check if nginx is already installed
if dpkg -l | grep -q nginx; then
  echo "Nginx is already installed."
else
  echo "Installing Nginx..."
  apt install nginx -y
fi

# Create custom index page
echo "Hello World from Hitesh DevOps Practice" > /var/www/html/index.html

# Enable and start nginx
systemctl enable nginx
systemctl restart nginx

# Verify nginx status
if systemctl is-active --quiet nginx; then
  echo "Nginx is running successfully."
else
  echo "Nginx failed to start."
  exit 1
fi

echo "Setup complete."
