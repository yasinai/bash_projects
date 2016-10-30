#!/bin/bash
# Nagios Plugin Bash Script - slp_status.sh
# This script checks count of SLP. Standard status we have more,that 15 machines installed at least.
# Check for missing parameters
machines_slp=$(slptool findattrs service:Dell-NAS.standby | sort -u | wc -l)
if [[ -z "$1" ]] 
then
        echo "Missing parameters! Syntax: ./slp_status.sh machine_count"
        exit 3

fi
if [[ $machines_slp -gt $machine_count ]] 
then
    echo "OK, $SERVICE service is running"
        exit 0
else
    echo "CRITICAL , $SERVICE service is not running"
        exit 2
fi