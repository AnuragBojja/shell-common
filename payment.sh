#!/bin/bash
app_name="payment"
source ./common.sh
CHECK_ROOT
APP_SETUP
PYTHON_SETUP
systemd_setup
TIME