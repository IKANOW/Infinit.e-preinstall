#!/bin/bash
################################################################################
# Perform online installation of hadoop and hue components
################################################################################
# $1 = Install mode = 'node' or 'full' install
################################################################################
INSTALL_MODE=$1

################################################################################
echo "modprobe capability"
################################################################################
modprobe capability

################################################################################
echo "Add hadoop group and user"
################################################################################
groupadd hadoop
useradd -g hadoop -p hduser hduser
# (Also need to add tomcat as a hadoop-permitted user)
usermod -G hadoop tomcat

################################################################################
echo "Install cloudera-cdh3.repo and perform yum installs on hadoop and hue"
################################################################################
cd /etc/yum.repos.d
if cat /etc/redhat-release | grep -iq "centos.*release 6"; then
	wget 'http://archive.cloudera.com/redhat/6/x86_64/cdh/cloudera-cdh3.repo'
else
	wget 'http://archive.cloudera.com/redhat/cdh/cloudera-cdh3.repo'
fi
yes | yum -y install hadoop-0.20 hadoop-0.20-native.x86_64 hadoop-0.20-sbin.x86_64 hue-plugins hadoop-zookeeper hadoop-hbase oozie oozie-client
yes | yum install hue -y

################################################################################
echo "Disable autostart for Hue and Oozie"
################################################################################
/sbin/chkconfig hue off
/sbin/chkconfig oozie off

################################################################################
echo "Copy mongo-2.7.2.jar to /usr/lib/hadoop/lib"
################################################################################
cp /mnt/opt/hadoop-infinite/jars/mongo-2.7.2.jar /usr/lib/hadoop/lib
	
################################################################################
echo "Create directories required by Hadoop"
################################################################################
mkdir -p /mnt/opt/hadoop-infinite/mapreduce/xmlFiles/
mkdir -p /mnt/opt/hadoop-infinite/mapreduce/jars/
mkdir -p /mnt/opt/hadoop-infinite/mapreduce/hadoop/

# Can't use root for Centos6+, set-up ec2-user...
if grep -q "^ec2-user" /etc/passwd; then
	chmod -R g+w /mnt/opt/hadoop-infinite/
	usermod -G tomcat ec2-user
fi

################################################################################
# Install the cloudera manager applications
################################################################################
if [ "$INSTALL_MODE" = "full" ]; then
	#(on some OS versions appear to need different permissions)
	mkdir -p /var/run/postgresql
	chmod a+wrx /var/run/postgresql

	cd /mnt/opt/hadoop-infinite/
	chmod +x scm-installer.bin
	./scm-installer.bin
fi

