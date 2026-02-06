#!/bin/bash

source ./common.sh
app_name="shipping"
CHECK_ROOT
APP_SETUP
MAVEN_SETUP
systemd_setup



dnf install mysql -y &>> "$LOGFILE"
VALIDATOR $? "installing mysql client"
mysql -h $MYSQL_HOST -uroot -pRoboShop@1 -e "use cities" &>> "$LOGFILE"
if [ $? -ne 0 ]; then
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/schema.sql
    VALIDATOR $? "loading schema data into database"
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/app-user.sql 
    VALIDATOR $? "loading app-user data into database"
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/master-data.sql
    VALIDATOR $? "loading Master data into database"
else 
    echo -e "database alredy exist $Y SKIPPING $N"
fi 
app_restart
TIME