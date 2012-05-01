#!/bin/bash
################################################################################
# Perform offline (disconnected) installation of hadoop and hue components
################################################################################
# $1 = Install mode = 'node' or 'full' install
################################################################################
INSTALL_MODE=$1

################################################################################
#echo "Copy repo file needed for offline installation to /etc/yum.repos.d"
################################################################################
#cp /mnt/opt/hadoop-infinite/etc/yum.repos.d/cloudera.repo /etc/yum.repos.d/

################################################################################
echo "modprobe capability"
################################################################################
modprobe capability

################################################################################
echo "Add hadoop group and user"
################################################################################
groupadd hadoop
useradd -g hadoop -p hduser hduser

################################################################################
echo "Create local yum repository"
################################################################################
cd /mnt/opt/hadoop-infinite/rpms
yes | yum localinstall createrepo-0.4.11-3.el5.noarch.rpm --nogpgcheck
createrepo /mnt/opt/hadoop-infinite/rpms

################################################################################
echo "Install hadoop and hue rpms via yum localinstall"
################################################################################
cd /mnt/opt/hadoop-infinite/rpms
yes | yum localinstall redhat-lsb-4.0-2.1.4.el5.x86_64.rpm --nogpgcheck
yes | yum localinstall hadoop-0.20-0.20.2+923.194-1.noarch.rpm --nogpgcheck
yes | yum localinstall hadoop-0.20-native-0.20.2+923.194-1.x86_64.rpm --nogpgcheck
yes | yum localinstall hadoop-0.20-sbin-0.20.2+923.194-1.x86_64.rpm --nogpgcheck
yes | yum localinstall hue-plugins-1.2.0.0+114.4-2.noarch.rpm --nogpgcheck
yes | yum localinstall hadoop-zookeeper-3.3.4+19.3-1.noarch.rpm --nogpgcheck
yes | yum localinstall hadoop-hbase-0.90.4+49.137-1.noarch.rpm --nogpgcheck
yes | yum localinstall oozie-client-2.3.2+27.12-1.noarch.rpm --nogpgcheck
yes | yum localinstall oozie-2.3.2+27.12-1.noarch.rpm --nogpgcheck
yes | yum localinstall cyrus-sasl-gssapi-2.1.22-5.el5_4.3.x86_64.rpm --nogpgcheck
yes | yum localinstall libxslt-1.1.17-2.el5_2.2.x86_64.rpm --nogpgcheck
yes | yum localinstall hue-common-1.2.0.0+114.4-2.x86_64.rpm --nogpgcheck
yes | yum localinstall hue-help-1.2.0.0+114.4-2.noarch.rpm --nogpgcheck
yes | yum localinstall hue-filebrowser-1.2.0.0+114.4-2.noarch.rpm --nogpgcheck
yes | yum localinstall hue-about-1.2.0.0+114.4-2.noarch.rpm --nogpgcheck
yes | yum localinstall hue-jobbrowser-1.2.0.0+114.4-2.noarch.rpm --nogpgcheck
yes | yum localinstall hue-jobsub-1.2.0.0+114.4-2.noarch.rpm --nogpgcheck
yes | yum localinstall hadoop-hive-0.7.1+42.27-2.noarch.rpm --nogpgcheck
yes | yum localinstall hue-beeswax-1.2.0.0+114.4-2.noarch.rpm --nogpgcheck
yes | yum localinstall hue-proxy-1.2.0.0+114.4-2.noarch.rpm --nogpgcheck
yes | yum localinstall hue-shell-1.2.0.0+114.4-2.x86_64.rpm --nogpgcheck
yes | yum localinstall hue-useradmin-1.2.0.0+114.4-2.noarch.rpm --nogpgcheck
yes | yum localinstall hue-1.2.0.0+114.4-2.noarch.rpm --nogpgcheck
sleep 5

################################################################################
echo "Create directories for Infinit.e mapreduce projects"
################################################################################
mkdir /mnt/opt/hadoop-infinite/mapreduce

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

################################################################################
# 
################################################################################
if [ "$INSTALL_MODE" = "full" ]; then
	################################################################################
	echo "Create cloudera-manager directories"
	################################################################################
	mkdir /mnt/opt/hadoop-infinite/webroot/cloudera-manager
	mkdir /mnt/opt/hadoop-infinite/webroot/cloudera-manager/redhat
	mkdir /mnt/opt/hadoop-infinite/webroot/cloudera-manager/redhat/5
	mkdir /mnt/opt/hadoop-infinite/webroot/cloudera-manager/redhat/5/x86_64
	mkdir /mnt/opt/hadoop-infinite/webroot/cloudera-manager/redhat/5/x86_64/cloudera-manager
	mkdir /mnt/opt/hadoop-infinite/webroot/cloudera-manager/redhat/5/x86_64/cloudera-manager/3
	sleep 5
	
	################################################################################
	echo "Install postgresql-server 8.1"
	################################################################################
	cd /mnt/opt/hadoop-infinite/rpms/
	yes | yum localinstall postgresql-libs-8.1.23-1.el5_7.3.x86_64.rpm --nogpgcheck
	yes | yum localinstall postgresql-8.1.23-1.el5_7.3.x86_64.rpm --nogpgcheck
	yes | yum localinstall postgresql-server-8.1.23-1.el5_7.3.x86_64.rpm --nogpgcheck
	sleep 5
	
	################################################################################
	echo "Move the RPMs to:"
	echo "	/mnt/opt/hadoop-infinite/webroot/cloudera-manager/redhat/5/x86_64/cloudera-manager/"
	echo "and"
	echo " 	/mnt/opt/hadoop-infinite/webroot/cloudera-manager/redhat/5/x86_64/cloudera-manager/3/rpms"
	################################################################################
	cd /mnt/opt/hadoop-infinite/rpms/
	cp RPM-GPG-KEY-cloudera /mnt/opt/hadoop-infinite/webroot/cloudera-manager/redhat/5/x86_64/cloudera-manager
	mv *.rpm /mnt/opt/hadoop-infinite/webroot/cloudera-manager/redhat/5/x86_64/cloudera-manager/3/
	sleep 5
	
	################################################################################
	echo "Move .repo files to /etc/yum.repos.d"
	################################################################################
	cd /mnt/opt/hadoop-infinite/etc/yum.repos.d
	cp cloudera-manager.repo /etc/yum.repos.d
	sleep 5

	################################################################################
	echo "Create repo of files in cloudera-manager directory"
	################################################################################
	createrepo /mnt/opt/hadoop-infinite/webroot/cloudera-manager/redhat/5/x86_64/cloudera-manager/3/
	sleep 5

	################################################################################
	#echo "Make archives.cloudera.com resolve to 127.0.0.1 /etc/hosts"
	################################################################################
	cp /etc/hosts /etc/hosts.backup
	HOST_FOUND="FALSE"
	grep "archive.cloudera.com" /etc/hosts -q && HOST_FOUND="TRUE"
	if [[ $HOST_FOUND="FALSE" ]]; then
    	sed -i '/127.0.0.1/s|$| archive.cloudera.com|' /etc/hosts
	fi

	################################################################################
	echo "Start SimpleWebServer webserver to make cloudera-manager directories available via http"
	################################################################################
	cd /mnt/opt/hadoop-infinite/webroot/
	nohup java -jar SimpleWebServer.jar &
	
	################################################################################
	echo "Make scm-installer executable and run it to install cloudera-manager"
	################################################################################
	cd /mnt/opt/hadoop-infinite/
	chmod +x scm-installer.bin
	./scm-installer.bin
	
	################################################################################
	echo "Remove cloudera related repo files"
	################################################################################
	rm -rf /etc/yum.repos.d/cloudera*

fi
