#!/bin/bash

YUM=/bin/yum
APT=/usr/bin/apt-get

if [[ `grep -i debian  /etc/*-release | wc -l` -gt 1 ]]
then
	$APT update
        $APT install -y sudo 
fi

if [[ `grep -i centos  /etc/*-release | wc -l` -gt 1 ]]
then
	$RPM -Uvh $CENTOS_REPO
	$YUM install -y sudo
fi

exit 0
