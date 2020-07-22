#!/bin/bash

#YUM=/bin/yum
#APT=/usr/bin/apt-get
ZABBIX="zabbix-agent"
#RPM=/bin/rpm
SELINUX=/sbin/semanage
FIREWALL=/bin/firewall-cmd
CENTOS7_REPO="http://repo.zabbix.com/zabbix/4.2/rhel/7/x86_64/zabbix-release-4.2-1.el7.noarch.rpm"
CENTOS6_REPO="http://repo.zabbix.com/zabbix/4.2/rhel/6/x86_64/zabbix-release-4.2-1.el6.noarch.rpm"

if [[ `grep -i debian  /etc/*-release | wc -l` -gt 1 ]]
then
        apt-get update
        apt-get install -y $ZABBIX
        apt-get install iptables-persistent fail2ban -y

fi

if [[ `grep -i centos  /etc/*-release | wc -l` -gt 1 ]]
then
        if [[ `grep 6 /etc/*-release | wc -l` -gt 1 ]]
        then
                rpm -Uvh $CENTOS6_REPO
                yum clean all
                yum install policycoreutils-python -y
                yum install -y $ZABBIX
                $SELINUX permissive -a zabbix_agent_t
                $FIREWALL --zone=public --add-port=10050/tcp
                $FIREWALL --permanent --add-port=10050/tcp
        else
                rpm -Uvh $CENTOS7_REPO
                yum clean all
                yum install policycoreutils-python -y
                yum install -y $ZABBIX
                $SELINUX permissive -a zabbix_agent_t
                $FIREWALL --zone=public --add-port=10050/tcp
                $FIREWALL --permanent --add-port=10050/tcp
        fi
fi

exit 0

