#!/bin/bash

source ./common.sh
CHECK_ROOT
NGINX_SETUP
rm -rf /usr/share/nginx/html/* 
VALIDATOR $? "removing default nginx frontend code"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip
VALIDATOR $? "downloading project code"
cd /usr/share/nginx/html 
unzip /tmp/frontend.zip
VALIDATOR $? "unzipping project code"
cp $SCRIPT_DIR/nginx.conf /etc/nginx/nginx.conf
VALIDATOR $? "creating nginx.conf"
systemctl restart nginx 
VALIDATOR $? "restarted nginx"
TIME