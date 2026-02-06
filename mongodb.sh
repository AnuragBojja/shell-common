#!/bin/bash

source ./common.sh
CHECK_ROOT


cp mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATOR $? "Adding mongo repo"

dnf install mongodb-org -y &>> "$LOGFILE"
VALIDATOR $? "Installing MongoDB"

systemctl enable mongod &>> "$LOGFILE"
VALIDATOR $? "Enable MongoDb"

systemctl start mongod &>> "$LOGFILE"
VALIDATOR $? "start MongoDb"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
VALIDATOR $? "Allowing remote connections"

systemctl restart mongod &>> "$LOGFILE"
VALIDATOR $? "restarted MongoDb"

TIME