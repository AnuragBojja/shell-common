# RoboShop – Refactored Shell Deployment with Shared Common Library

An improved and refactored version of the RoboShop microservices deployment automation. This iteration introduces a **shared `common.sh` library** that eliminates code duplication across all service scripts — reducing individual service scripts from ~70 lines to as few as 6 lines while maintaining full functionality.

---

## What Changed from v1

| Feature | v1 (Individual Scripts) | v2 (common.sh refactor) |
|---|---|---|
| Lines per service script | ~60–80 lines | **5–10 lines** |
| VALIDATOR function | Duplicated in every file | Defined once in `common.sh` |
| Logging setup | Duplicated in every file | Centralized in `common.sh` |
| Root check | Duplicated in every file | `CHECK_ROOT()` in `common.sh` |
| Runtime tracking | Manual in some scripts | `TIME()` called consistently |
| Runtime setup (Node/Maven/Python) | Inline per script | `NODEJS_SETUP()`, `MAVEN_SETUP()`, `PYTHON_SETUP()` |
| App lifecycle (download/unzip/install) | Inline per script | `APP_SETUP()` + `systemd_setup()` |

---

## Architecture Overview

```
common.sh  (shared library)
    │
    ├── CHECK_ROOT()       — enforces root privilege
    ├── VALIDATOR()        — exit-code checker with color output + logging
    ├── APP_SETUP()        — user creation, artifact download, unzip
    ├── NODEJS_SETUP()     — Node.js 20 module enable + npm install
    ├── MAVEN_SETUP()      — Maven build + jar rename
    ├── PYTHON_SETUP()     — Python3 install + pip requirements
    ├── NGINX_SETUP()      — Nginx 1.24 module enable + install + start
    ├── systemd_setup()    — systemd service copy, daemon-reload, enable, start
    ├── app_restart()      — systemctl restart $app_name
    └── TIME()             — prints total execution time in seconds
```

---

## Project Structure

```
roboshop-shell-common/
├── common.sh           # Shared library — all reusable functions
├── ec2-create.sh       # Provision EC2 instances + Route53 DNS
├── mongodb.sh          # MongoDB install & remote config
├── redis.sh            # Redis 7 install & remote config
├── mysql.sh            # MySQL Server install & secure setup
├── rabbitMQ.sh         # RabbitMQ install + user/permissions
├── catalogue.sh        # Node.js catalogue service + MongoDB data load
├── user.sh             # Node.js user service
├── cart.sh             # Node.js cart service
├── shipping.sh         # Java/Maven shipping service + MySQL schema
├── payment.sh          # Python payment service
└── frontend.sh         # Nginx frontend deployment
```

---

## Service Scripts — How Clean They Are Now

Thanks to `common.sh`, most service scripts are self-documenting and minimal:

**payment.sh**
```bash
#!/bin/bash
app_name="payment"
source ./common.sh
CHECK_ROOT
APP_SETUP
PYTHON_SETUP
systemd_setup
TIME
```

**cart.sh / user.sh**
```bash
#!/bin/bash
source ./common.sh
app_name="cart"   # or "user"
CHECK_ROOT
APP_SETUP
NODEJS_SETUP
systemd_setup
app_restart
TIME
```

---

## Services & Technology Stack

| Service    | Runtime         | Database       |
|------------|-----------------|----------------|
| Frontend   | Nginx 1.24      | —              |
| Catalogue  | Node.js 20      | MongoDB        |
| User       | Node.js 20      | MongoDB, Redis |
| Cart       | Node.js 20      | Redis          |
| Shipping   | Java (Maven)    | MySQL          |
| Payment    | Python 3        | RabbitMQ       |
| MongoDB    | MongoDB Org     | —              |
| Redis      | Redis 7         | —              |
| MySQL      | MySQL Server    | —              |
| RabbitMQ   | RabbitMQ Server | —              |

---

## Key Features

- **DRY shared library** — `common.sh` sourced by all scripts; all shared logic defined once
- **Parameterized app setup** — `$app_name` variable drives artifact URLs, service file names, and systemd config dynamically
- **Function-based design** — `APP_SETUP`, `NODEJS_SETUP`, `MAVEN_SETUP`, `PYTHON_SETUP`, `NGINX_SETUP`, `systemd_setup` are composable and reusable
- **Centralized logging** — all logs written to `/var/log/shell-logs/<script>.log`
- **Consistent execution timing** — `TIME()` function reports total runtime for every script
- **Idempotent service scripts** — existing users and databases are detected and skipped safely
- **AWS CLI automation** — EC2 provisioning + Route53 DNS registration for all services

---

## Prerequisites

- RHEL / Amazon Linux 2023 EC2 instances
- AWS CLI configured with EC2 + Route53 IAM permissions
- A registered domain in Route53 (used: `anuragaws.shop`)

---

## Usage

### Step 1 — Provision Infrastructure
```bash
chmod +x ec2-create.sh
./ec2-create.sh mongodb catalogue redis mysql rabbitmq user cart shipping payment frontend
```

### Step 2 — Deploy Each Service
Run on the respective EC2 instance, always from the directory containing `common.sh`:

```bash
sudo bash mongodb.sh
sudo bash redis.sh
sudo bash mysql.sh
sudo bash rabbitMQ.sh
sudo bash catalogue.sh
sudo bash user.sh
sudo bash cart.sh
sudo bash shipping.sh
sudo bash payment.sh
sudo bash frontend.sh
```

---

## Logging

```
/var/log/shell-logs/<script-name>.log
```

Each log captures timestamped success/failure of every step.

---

## Author

**Anurag Bojja**  
Milwaukee, WI | [LinkedIn](https://www.linkedin.com/in/anurag-bojja-81a405192/) | [GitHub](https://github.com/AnuragBojja)
