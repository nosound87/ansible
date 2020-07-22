#!/bin/bash
#Simple script for installation mysqld_exporter - tbetler

#Variables
VER="0.12.1"
TAR=/bin/tar
WGET=/usr/bin/wget
MOVE=/bin/mv
YUM=/bin/yum
APT=/usr/bin/apt
TEMP=/tmp
C_USR=/usr/sbin/useradd
SYSCTL=/bin/systemctl
SERVICE='/etc/systemd/system/mysqld_exporter.service'
BIN='/usr/local/bin/'
GIT_URL="https://github.com/prometheus/mysqld_exporter/releases/download/v${VER}/mysqld_exporter-${VER}.linux-amd64.tar.gz"
REMOVE='/bin/rm'

#Install
cd $TEMP
echo "Download mysqld_exporter from official repository..."
$WGET $GIT_URL &>/dev/null
echo "Extract files:"
$TAR -zxvf mysqld_exporter-*.tar.gz
echo "Moving files to binary location"
$MOVE mysqld_exporter-*/mysqld_exporter $BIN

echo "Creating mysqld_exporter daemon service..."
$C_USR -rs /sbin/nologin mysqld_exporter
cat > $SERVICE << EOF
[Unit]
Description=Prometheus MySQL Exporter
After=network.target
User=mysqld_exporter
Group=mysqld_exporter

[Service]
Type=simple
Restart=always
ExecStart=/usr/local/bin/mysqld_exporter \
--config.my-cnf /etc/.mysqld_exporter.cnf \
--collect.global_status \
--collect.info_schema.innodb_metrics \
--collect.auto_increment.columns \
--collect.info_schema.processlist \
--collect.binlog_size \
--collect.info_schema.tablestats \
--collect.global_variables \
--collect.info_schema.query_response_time \
--collect.info_schema.userstats \
--collect.info_schema.tables \
--collect.perf_schema.tablelocks \
--collect.perf_schema.file_events \
--collect.perf_schema.eventswaits \
--collect.perf_schema.indexiowaits \
--collect.perf_schema.tableiowaits \
--collect.slave_status \
--web.listen-address=0.0.0.0:9104

[Install]
WantedBy=multi-user.target
EOF


if [[ `grep -i debian  /etc/*-release | wc -l` -gt 1 ]]
then
        $APT install -y python-mysqldb $>/dev/null
fi

if [[ `grep -i centos  /etc/*-release | wc -l` -gt 1 ]]
then
        $YUM install -y MySQL-python.x86_64 $>/dev/null
fi

$SYSCTL daemon-reload
$SYSCTL enable mysqld_exporter.service &>/dev/null

$REMOVE -fr $TEMP/mysqld_exporter*
echo "finish."

exit 0
                                                            
