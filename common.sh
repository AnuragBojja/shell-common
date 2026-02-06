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
START_TIMR=$(date +%s)
SCRIPT_DIR=$PWD
MongoDB_IP="mongodb.anuragaws.shop"
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
ROBOSHOP(){
    id roboshop &>> "$LOGFILE"
    if [ $? -ne 0 ]; then
        useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
        VALIDATOR $? "Creating system user roboshop"
    else 
        echo -e "user roboshop already exiest ......$Y SKIPPING $N"
    fi
}
NODEJS_SETUP(){
    dnf module disable nodejs -y &>> "$LOGFILE"
    VALIDATOR $? "Disable nodejs modules"

    dnf module enable nodejs:20 -y &>> "$LOGFILE"
    VALIDATOR $? "Enabling Nodejs 20"

    dnf install nodejs -y &>> "$LOGFILE"
    VALIDATOR $? "Installing Nodejs"

    npm install &>> "$LOGFILE"
    VALIDATOR $? "installed all the dependancies"
}
APP_SETUP(){
    mkdir -p /app 
    VALIDATOR $? "created /app dir"

    curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip &>> "$LOGFILE"
    VALIDATOR $? "Downloaded $app_name.zip in tmp folder"

    cd /app 
    VALIDATOR $? "change directory to /app"

    rm -rf /app/*
    VALIDATOR $? "removing existing code"

    unzip /tmp/$app_name.zip &>> "$LOGFILE"
    VALIDATOR $? "unziped $app_name.zip folder"
}

systemd_setup(){
    cp $SCRIPT_DIR/$app_name.service /etc/systemd/system/$app_name.service
    VALIDATOR $? "created $app_name.service file "

    systemctl daemon-reload
    VALIDATOR $? "completing deamon reload"

    systemctl enable $app_name 
    VALIDATOR $? "enabling $app_name"

    systemctl start $app_name
    VALIDATOR $? "starting $app_name"
}
app_restart(){
    systemctl restart $app_name
    VALIDATOR $? "restarting $app_name"
}
TIME(){
    END_TIMR=$(date +%s)
    TOTAL_TIME=$(( $END_TIME - $START_TIME ))
    echo -e "$Y Total Run Time $N :$Y $TOTAL_TIME seconds $N" 
}