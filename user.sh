#!/bin/bash

source ./common.sh
app_name="user"
CHECK_ROOT
APP_SETUP
NODEJS_SETUP
systemd_setup
app_restart
TIME