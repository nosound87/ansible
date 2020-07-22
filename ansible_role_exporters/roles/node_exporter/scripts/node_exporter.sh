#!/bin/bash
#Simple script for installation node_exporter - tbetler


#Variables
VER="0.18.1"
TAR=/bin/tar
WGET=/usr/bin/wget
MOVE=/bin/mv
TEMP=/tmp
C_USR=/usr/sbin/useradd
SYSCTL=/bin/systemctl
SERVICE='/etc/systemd/system/node_exporter.service'
BIN='/usr/local/bin/'
GIT_URL="https://github.com/prometheus/node_exporter/releases/download/v$VER/node_exporter-$VER.linux-amd64.tar.gz"
REMOVE='/bin/rm'

#Install
cd $TEMP
echo "Download node_exporter from official repository..."
$WGET $GIT_URL &>/dev/null
echo "Extract files:"
$TAR -zxvf node_exporter-*.tar.gz
echo "Moving files to binary location"
$MOVE node_exporter-*/node_exporter $BIN

echo "Creating node_exporter daemon service..."
$C_USR -rs /bin/false node_exporter
cat > $SERVICE <<EOF
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF
$SYSCTL daemon-reload
$SYSCTL start node_exporter.service
$SYSCTL enable node_exporter.service &>/dev/null

$REMOVE -fr $TEMP/node_exporter*
echo "finish."

exit 0
