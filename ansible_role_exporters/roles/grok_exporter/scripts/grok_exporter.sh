#!/bin/bash
#Simple script for installation grok_exporter - tbetler


#Variables
VER="0.2.8"
UZIP=/bin/unzip
WGET=/usr/bin/wget
MOVE=/bin/mv
TEMP=/tmp
C_USR=/usr/sbin/useradd
SYSCTL=/bin/systemctl
MAKED=/bin/mkdir
YUM=/bin/yum
APT=/usr/bin/apt-get
CONF_DIR=/etc/grok_exporter
SERVICE='/etc/systemd/system/grok_exporter.service'
BIN='/usr/local/bin/'
GIT_URL="https://github.com/fstab/grok_exporter/releases/download/v$VER/grok_exporter-$VER.linux-amd64.zip"
REMOVE='/bin/rm'
REQUIRE="unzip"

if [[ `grep -i debian  /etc/*-release | wc -l` -gt 1 ]]
then
        INSTALL=$APT
fi

if [[ `grep -i centos  /etc/*-release | wc -l` -gt 1 ]]
then
        INSTALL=$YUM
fi

$INSTALL install -y $REQUIRE $>/dev/null

#Install
cd $TEMP
echo "Download grok_exporter from official repository..."
$WGET $GIT_URL &>/dev/null
echo "Extract files:"
$UZIP grok_exporter-*.zip
echo "Moving files to binary location"
$MOVE grok_exporter-*/grok_exporter $BIN
echo "Moving configuration file to /etc"
$MAKED $CONF_DIR
$MOVE grok_exporter-*/* $CONF_DIR 

echo "Creating grok_exporter daemon service..."
$C_USR -rs /bin/nologin grok_exporter
cat > $SERVICE <<EOF
[Unit]
Description=Grok Exporter
After=network.target

[Service]
User=grok_exporter
Group=grok_exporter
Type=simple
ExecStart=/usr/local/bin/grok_exporter -config /etc/grok_exporter/example/config.yml

[Install]
WantedBy=multi-user.target
EOF
$SYSCTL daemon-reload
$SYSCTL enable grok_exporter.service &>/dev/null

$REMOVE -fr $TEMP/grok_exporter*
echo "finish."

exit 0
