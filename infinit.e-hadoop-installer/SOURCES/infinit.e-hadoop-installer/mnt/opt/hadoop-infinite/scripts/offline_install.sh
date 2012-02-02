#!/bin/bash
################################################################################
# Perform offline (disconnected) installation of hadoop and hue components
################################################################################
# $1 = Install mode = 'node' or 'full' install
################################################################################
INSTALL_MODE=$1

################################################################################
echo "Copy repo files needed for offline installation to /etc/yum.repos.d"
################################################################################
cp /mnt/opt/hadoop-infinite/etc/yum.repos.d/* /etc/yum.repos.d/

################################################################################
echo "Add hadoop group and user"
################################################################################
groupadd hadoop
useradd -g hadoop -p hduser hduser

################################################################################
echo "Create local yum repository"
################################################################################
createrepo /mnt/opt/hadoop-infinite/rpms

################################################################################
echo "Install files in local repository"
################################################################################
cd /mnt/opt/hadoop-infinite/rpms
yes | yum localinstall hadoop-*.rpm --nogpgcheck
yes | yum localinstall hue-*.rpm --nogpgcheck

################################################################################
# Create directories for Infinit.e mapreduce projects
################################################################################
mkdir /mnt/opt/hadoop-infinite/
mkdir /mnt/opt/hadoop-infinite/mapreduce

################################################################################
echo "Disable autostart for Hue and Oozie"
################################################################################
/sbin/chkconfig hue off
/sbin/chkconfig oozie off

################################################################################
# 
################################################################################
if [ "$INSTALL_MODE" = "full" ]; then
	################################################################################
	echo "Create cloudera-manager directories"
	################################################################################
	mkdir /mnt/opt/hadoop-infinite
	mkdir /mnt/opt/hadoop-infinite/webroot/cloudera-manager
	mkdir /mnt/opt/hadoop-infinite/webroot/cloudera-manager/redhat
	mkdir /mnt/opt/hadoop-infinite/webroot/cloudera-manager/redhat/5
	mkdir /mnt/opt/hadoop-infinite/webroot/cloudera-manager/redhat/5/x86_64
	mkdir /mnt/opt/hadoop-infinite/webroot/cloudera-manager/redhat/5/x86_64/cloudera-manager
	mkdir /mnt/opt/hadoop-infinite/webroot/cloudera-manager/redhat/5/x86_64/cloudera-manager/3
	sleep 5
	
	################################################################################
	echo "Move cloudera-manager related RPMs to:"
	echo "	/mnt/opt/hadoop-infinite/webroot/cloudera-manager/redhat/5/x86_64/cloudera-manager/"
	echo "and"
	echo " 	/mnt/opt/hadoop-infinite/webroot/cloudera-manager/redhat/5/x86_64/cloudera-manager/3/"
	################################################################################
	cd /mnt/opt/hadoop-infinite/rpms/
	cp RPM-GPG-KEY-cloudera /mnt/opt/hadoop-infinite/webroot/cloudera-manager/redhat/5/x86_64/cloudera-manager
	cp *.rpm /mnt/opt/hadoop-infinite/webroot/cloudera-manager/redhat/5/x86_64/cloudera-manager/3
	sleep 5

	################################################################################
	echo "Move .repo files to /etc/yum.repos.d"
	################################################################################
	cd /mnt/opt/hadoop-infinite/etc/yum.repos.d
	cp cloudera.repo /etc/yum.repos.d
	cp cloudera-manager.repo /etc/yum.repos.d
	sleep 5

	################################################################################
	echo "Create repo of files in cloudera-manager directory"
	################################################################################
	createrepo /mnt/opt/hadoop-infinite/webroot/cloudera-manager/redhat/5/x86_64/cloudera-manager/3
	sleep 5
	
	################################################################################
	echo "Install rpms via yum localinstall"
	################################################################################
	yes | yum localinstall hadoop-0.20-0.20.2+923.194-1.noarch.rpm --nogpgcheck
	yes | yum localinstall hadoop-0.20-native-0.20.2+923.194-1.x86_64.rpm --nogpgcheck
	yes | yum localinstall hadoop-0.20-sbin-0.20.2+923.194-1.x86_64.rpm --nogpgcheck
	yes | yum localinstall hue-plugins-1.2.0.0+114.20-1.noarch.rpm --nogpgcheck
	yes | yum localinstall hadoop-zookeeper-3.3.4+19.3-1.noarch.rpm --nogpgcheck
	yes | yum localinstall hadoop-hbase-0.90.4+49.137-1.noarch.rpm --nogpgcheck
	yes | yum localinstall oozie-2.3.2+27.12-1.noarch.rpm --nogpgcheck
	yes | yum localinstall oozie-client-2.3.2+27.12-1.noarch.rpm --nogpgcheck
	yes | yum localinstall hue-1.2.0.0+114.20-1.noarch.rpm --nogpgcheck
	sleep 5
	
	################################################################################
	echo "Make archives.cloudera.com resolve to 127.0.0.1 /etc/hosts"
	################################################################################
	cp /etc/hosts /etc/hosts.backup
	HOST_FOUND="FALSE"
	grep "archives.cloudera.com" /etc/hosts -q && HOST_FOUND="TRUE"
	if [[ $HOST_FOUND="FALSE" ]]; then
    	sed -i '/127.0.0.1/s|$| archives.cloudera.com|' /etc/hosts
	fi

	################################################################################
	echo "Start nano webserver to make cloudera-manager directories available via http"
	################################################################################
	cd /mnt/opt/hadoop-infinite/webroot/
	java -jar nano.jar
	
	################################################################################
	echo "Make scm-installer executable and run it to install cloudera-manager"
	################################################################################
	cd /mnt/opt/hadoop-infinite/
	chmod +x scm-installer.bin
	./scm-installer.bin
fi
