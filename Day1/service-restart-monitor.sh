#!/bin/bash

: <<'COMMENT'
This script the status of the nginx service and restart the service when it is down. 
You can set an cronjob to run this script. 

To set cronjob run this command:- 
crontab -e 

Add :-

* * * * * /bin/bash /root/service-restart-monitor.sh
COMMENT

SERVICE="nginx"
LOG_FILE="/var/log/nginx-watchdog.log"

if ! systemctl is-active --quiet $SERVICE then 
	echo "$(date) $SERVICE down... restarting service" >> $LOG_FILE
systemctl restart $SERVICE 
	if systemctl is-active $SERVICE then 
		echo "$SERVICE restart successfully" >> $LOG_FILE
	else 
		echo "$SERVICE failed to restart" >> $LOG_FILE
       	fi
fi 
