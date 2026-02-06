#!/bin/bash

source ./common.sh
CHECK_ROOT

cp $SCRIPT_DIR/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo &>> "$LOGFILE"
VALIDATOR $? "creating rabbitmq.repo"
dnf install rabbitmq-server -y &>> "$LOGFILE"
VALIDATOR $? "installing rabbitmq"
systemctl enable rabbitmq-server &>> "$LOGFILE"
VALIDATOR $? "enabling rabbitmq"
systemctl start rabbitmq-server &>> "$LOGFILE"
VALIDATOR $? "starting rabbitmq"
rabbitmqctl add_user roboshop roboshop123 &>> "$LOGFILE"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> "$LOGFILE"
VALIDATOR $? "setting up permissions"

TIME