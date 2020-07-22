#!/bin/bash

YUM=/bin/yum

if [[ `grep -i centos  /etc/*-release | wc -l` -gt 1 ]]
then
        $YUM install libselinux-python libsemanage-python policycoreutils-python $>/dev/null
fi


exit 0
