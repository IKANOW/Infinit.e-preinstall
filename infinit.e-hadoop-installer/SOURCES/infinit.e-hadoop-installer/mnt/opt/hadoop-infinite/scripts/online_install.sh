#!/bin/bash
################################################################################
# Perform online installation of CDH5
################################################################################
# $1 = Install mode = 'node' or 'full' install
################################################################################
INSTALL_MODE=$1

################################################################################
echo "Create directories required by Hadoop"
################################################################################
mkdir -p /mnt/opt/hadoop-infinite/mapreduce/xmlFiles/
mkdir -p /mnt/opt/hadoop-infinite/mapreduce/jars/
mkdir -p /mnt/opt/hadoop-infinite/mapreduce/hadoop/

#Cloudera monitors use a huge amount of disk space, so set up a symlink for the offending dirs
DATA_PREFIX="/mnt"
if [ -d /raidarray ]; then
	DATA_PREFIX="/raidarray"
elif [ -d /dbarray ]; then
	DATA_PREFIX="/dbarray"
fi

if [ ! -d $DATA_PREFIX/cloudera-service-monitor/ ]; then
	if [ -d /var/lib/cloudera-service-monitor/ ]; then
		mv /var/lib/cloudera-service-monitor/ $DATA_PREFIX/cloudera-service-monitor
	else
		mkdir $DATA_PREFIX/cloudera-service-monitor/
		chmod a+wrx $DATA_PREFIX/cloudera-service-monitor/
	fi
	cd /var/lib
	ln -s $DATA_PREFIX/cloudera-service-monitor/
	cd -
fi
if [ ! -d $DATA_PREFIX/cloudera-host-monitor/ ]; then
	if [ -d /var/lib/cloudera-host-monitor/ ]; then
		mv /var/lib/cloudera-host-monitor/ $DATA_PREFIX/cloudera-host-monitor
	else
		mkdir $DATA_PREFIX/cloudera-host-monitor/
		chmod a+wrx $DATA_PREFIX/cloudera-host-monitor/
	fi
	cd /var/lib
	ln -s $DATA_PREFIX/cloudera-host-monitor/
	cd -
fi

# Can't use root for Centos6+, set-up ec2-user...
if grep -q "^ec2-user" /etc/passwd; then
	chmod -R g+w /mnt/opt/hadoop-infinite/
	usermod -G tomcat ec2-user
fi
chown -R tomcat.tomcat /mnt/opt/hadoop-infinite/

# For amazon linux, fake redhat-release:
if [ -f /etc/redhat-release ]; then
	if grep -q 'Amazon Linux' /etc/redhat-release; then
		mv /etc/redhat-release /etc/redhat-release.OLD
		echo 'CentOS release 6.3 (Final)' > /etc/redhat-release		
	fi	
else
	echo 'CentOS release 6.3 (Final)' > /etc/redhat-release
fi

#Update the symlink for the library:
#TODO: let's stick with the standalone libs for the moment
#if [ "$INSTALL_MODE" != "partial" ]; then
	#	rm -f /opt/hadoop-infinite/lib
	#ln -sf /opt/cloudera/parcels/CDH/lib/hadoop/client-0.20/ /opt/hadoop-infinite/lib
#fi

################################################################################
# Install the cloudera manager applications
################################################################################
if [ "$INSTALL_MODE" = "full" ]; then

	#(pre-emptively fixing postgres issue)
	rm -rf  /var/run/postgresql/
	mkdir /var/run/postgresql
	chmod a+wrx /var/run/postgresql
	
	/opt/hadoop-infinite/cloudera-manager-installer.bin
fi
