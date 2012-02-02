#!/bin/bash
################################################################################
# Perform online installation of hadoop and hue components
################################################################################
# $1 = Install mode = 'node' or 'full' install
################################################################################
INSTALL_MODE=$1

################################################################################
echo "Add hadoop group and user"
################################################################################
groupadd hadoop
useradd -g hadoop -p hduser hduser

################################################################################
echo "Install cloudera-cdh3.repo and perform yum installs on hadoop and hue"
################################################################################
cd /etc/yum.repos.d
wget 'http://archive.cloudera.com/redhat/cdh/cloudera-cdh3.repo'
yes | yum -y install hadoop-0.20 hadoop-0.20-native.x86_64 hadoop-0.20-sbin.x86_64 hue-plugins hadoop-zookeeper hadoop-hbase oozie oozie-client
yes | yum install hue -y

################################################################################
echo "Disable autostart for Hue and Oozie"
################################################################################
/sbin/chkconfig hue off
/sbin/chkconfig oozie off

################################################################################
# Install the cloudera manager applications
################################################################################
if [ "$INSTALL_MODE" = "full" ]; then
	cd /mnt/opt/hadoop-infinite/
	chmod +x scm-installer.bin
	./scm-installer.bin
fi
