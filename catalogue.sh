#!/bin/bash

source ./common.sh
app_name="catalogue"
CHECK_ROOT
APP_SETUP
ROBOSHOP
NODEJS_SETUP

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATOR $? "Adding mongo repo"

dnf install mongodb-mongosh -y &>> "$LOGFILE"
VALIDATOR $? "installing mondoDB client"

mongosh --host mongodb.anuragaws.shop --quiet --eval "db.adminCommand('listDatabases').databases.map(db => db.name)" | grep catalogue &>> "$LOGFILE"
if [ $? -ne 0 ]; then
    mongosh --host $MongoDB_IP </app/db/master-data.js &>> "$LOGFILE"
    VALIDATOR $? "load catalogue products"
else
    echo -e "Database Alredy exist......$Y SKIPPING $N"
fi 


app_restart
TIME