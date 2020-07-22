#!/bin/bash
#Simple script for installation apache_exporter - tbetler

#Variables
VER="0.7.0"
TAR=/bin/tar
WGET=/usr/bin/wget
MOVE=/bin/mv
YUM=/bin/yum
APT=/usr/bin/apt-get
TEMP=/tmp
C_USR=/usr/sbin/useradd
SYSCTL=/bin/systemctl
SERVICE='/etc/systemd/system/apache_exporter.service'
SYSCFG_FILE='/etc/sysconfig/apache_exporter'
BIN='/usr/local/bin/'
GIT_URL="https://github.com/Lusitaniae/apache_exporter/releases/download/v$VER/apache_exporter-$VER.linux-amd64.tar.gz"
REQUIRE="daemonize"
REMOVE='/bin/rm'

#Install
cd $TEMP
echo "Download apache_exporter from official repository..."
$WGET $GIT_URL &>/dev/null
echo "Extract files:"
$TAR -zxvf apache_exporter-*.tar.gz
echo "Moving files to binary location"
$MOVE apache_exporter-*/apache_exporter $BIN

echo "Creating apache_exporter daemon service..."
$C_USR -rs /bin/nologin apache_exporter
cat > $SERVICE << EOF
[Unit]
Description=Apache Exporter
Documentation=https://github.com/Lusitaniae/apache_exporter
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
User=apache_exporter
Group=apache_exporter
ExecReload=/bin/kill -HUP \$MAINPID
ExecStart=/usr/local/bin/apache_exporter \
  --insecure \
  --scrape_uri=http://localhost/server-status/?auto \
  --telemetry.address=0.0.0.0:9117 \
  --telemetry.endpoint=/metrics

SyslogIdentifier=apache_exporter
Restart=always

[Install]
WantedBy=multi-user.target
EOF

if [[ `grep -i debian  /etc/*-release | wc -l` -gt 1 ]]
then
        INSTALL=$APT
fi

if [[ `grep -i centos  /etc/*-release | wc -l` -gt 1 ]]
then
        INSTALL=$YUM
fi

$INSTALL install -y $REQUIRE $>/dev/null

cat > $SYSCFG_FILE << EOF
ARGS="--insecure --scrape_uri=http://localhost/server-status/?auto --telemetry.address=0.0.0.0:9117 --telemetry.endpoint=/metrics"
EOF

$SYSCTL daemon-reload
$SYSCTL start apache_exporter.service
$SYSCTL enable apache_exporter.service &>/dev/null

$REMOVE -fr $TEMP/apache_exporter*
echo "finish."

exit 0
                                                            
