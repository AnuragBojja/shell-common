#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
LOGFOLDER="/var/log/shell-logs"
mkdir -p "$LOGFOLDER"
LOGFILENAME=$( echo $0 | cut -d "." -f1)
LOGFILE="$LOGFOLDER/$LOGFILENAME.log"
START_TIMR=$(date -%s)
echo "Log File Created at $LOGFILE"

CHECK_ROOT(){
    if [ "$USERID" -ne 0 ]; then
        echo "Run this file with Root Privilage" &>> "$LOGFILE"
        echo "Run this file with Root Privilage"
    exit 1
    else 
        echo "This files running with Root Privilage" &>> "$LOGFILE"
        echo "This files running with Root Privilage"
    fi

}

VALIDATOR(){
    if [ "$1" -eq 0 ]; then
        echo " $2 SUCCESSFUL" &>> "$LOGFILE"
        echo -e "$Y  $2 SUCCESSFUL $N"
    else
        echo "ERROR  $2" &>> "$LOGFILE"
        echo -e "$R ERROR  $2 $N"
        exit 1
    fi 
    echo " ................................... " &>> "$LOGFILE"
    echo -e "$G ................................... $N"
}

TIME(){
    END_TIMR=$(date -%s)
    TOTAL_TIME=$(($END_TIME-$START_TIME))
    echo "Total Run Time :$Y $TOTAL_TIME seconds $N" 
}