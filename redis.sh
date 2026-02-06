#!/bin/bash

source ./common.sh
CHECK_ROOT


dnf module disable redis -y &>> "$LOGFILE"
VALIDATOR $? "Disabling  default redis"
dnf module enable redis:7 -y &>> "$LOGFILE"
VALIDATOR $? "Enabling redis 7"
dnf install redis -y &>> "$LOGFILE"
VALIDATOR $? "Installing redis"

sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf
VALIDATOR $? "allowing remote connetion to redis"

systemctl enable redis &>> "$LOGFILE"
VALIDATOR $? "Enabling redis"
systemctl start redis &>> "$LOGFILE"
VALIDATOR $? "Starting redis"

TIME