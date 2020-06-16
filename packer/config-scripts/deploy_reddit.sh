#!/bin/bash
set -e

# Забираем приложение из источника
cd ~
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install

# Описание сервиса для systemd
cat <<EOF > /etc/systemd/system/reddit.service
[Unit]
Description=Reddit App for DevOps Practice
After=network.target
After=mongod.service

[Service]
ExecStart=/usr/local/bin/puma -d --dir /home/squid/reddit
KillMode=process

Restart=always
RestartSec=5

User=squid
Group=squid

PrivateTmp=true
PrivateDevices=true
ProtectSystem=full
ProtectHome=read-only

RuntimeDirectory=reddit
SyslogIdentifier=reddit
SyslogFacility=local0
SyslogLevel=debug

[Install]
WantedBy=multi-user.target
EOF

# Запускаем reddit
sudo chmod 664 /etc/systemd/system/reddit.service
sudo systemctl daemon-reload
sudo systemctl enable reddit
