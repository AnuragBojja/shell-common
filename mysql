#!/bin/bash

source ./common.sh
CHECK_ROOT

dnf install mysql-server -y &>> "$LOGFILE"
VALIDATOR $? "installing mySQL Server "
systemctl enable mysqld &>> "$LOGFILE"
VALIDATOR $? "Enabling mySQL "
systemctl start mysqld &>> "$LOGFILE"
VALIDATOR $? "Starting mySQL "
mysql_secure_installation --set-root-pass RoboShop@1 &>> "$LOGFILE"
VALIDATOR $? "setting root password "

TIME 