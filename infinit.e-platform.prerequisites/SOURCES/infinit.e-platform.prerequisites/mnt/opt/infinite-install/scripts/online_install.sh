#!/bin/bash
################################################################################
# install.sh
################################################################################
# API Node   - Tested, Red Hat 5.5 1/11/2012
# DB Node    - Tested, Red Hat 5.5 1/11/2012
################################################################################

################################################################################
# Commandline arguments
################################################################################
# $1 - APINode or DBNode (API is default) 
# $2 is "--fast" to bypassing installing latest java/jpackage/splunk (for AMIs)
################################################################################
NODE_TYPE="APINode"
if [ $# -gt 0 ]; then
  case $1 in
    dbnode )
      NODE_TYPE="DBNode" ;;
    apinode )
      NODE_TYPE="APINode" ;;
  esac
fi
echo "Online Installation: $NODE_TYPE"


################################################################################
# Directory install files are copied too
################################################################################
INSTALL_FILES_DIR="/mnt/opt/infinite-install"


################################################################################
echo "Create yum repo for /mnt/opt/infinite-install/rpms/dependencies -"
################################################################################
if [ "$2" != "--fast" ]; then

	yes | yum install createrepo -y
	sleep 5
fi

################################################################################
echo "Install rpm-build -"
################################################################################
if [ "$2" != "--fast" ]; then

	yes | yum install rpm-build -y
	sleep 5
fi

################################################################################
echo "Install jpackage-utils (jpackage.org) and yum-priorities -"
################################################################################
if [ "$2" != "--fast" ]; then

	yes | yum install jpackage-utils -y
	yes | yum install yum-priorities -y
	sleep 5
fi

################################################################################
echo "Install s3cmd -"
################################################################################
cd /etc/yum.repos.d
wget http://s3tools.org/repo/CentOS_5/s3tools.repo
yes | yum install s3cmd -y
sleep 5


################################################################################
echo "Install Java JRE and JDK -"
################################################################################

if [ "$2" != "--fast" ]; then

	cd $INSTALL_FILES_DIR/rpms
	chmod a+x jre-*-linux-x64-rpm.bin
	sh jre-*-linux-x64-rpm.bin
	chmod a+x jdk-*-linux-x64-rpm.bin
	sh jdk-*-linux-x64.bin
	mv jdk1.6.*/ /usr/java/
	sleep 5
fi

################################################################################
echo "Install Tomcat -"
################################################################################

if [ "$2" != "--fast" ]; then

	# rpm -Uvh http://plone.lucidsolutions.co.nz/linux/centos/images/jpackage-utils-compat-el5-0.0.1-1.noarch.rpm
	cd $INSTALL_FILES_DIR/rpms
	rpm -Uvh jpackage-utils-compat-el5-0.0.1-1.noarch.rpm
	
	cd /etc/yum.repos.d
	wget 'http://www.jpackage.org/jpackage50.repo'
	yes | yum update -y
	yes | yum install tomcat6 tomcat6-webapps tomcat6-admin-webapps -y
	chkconfig tomcat6 off
	sleep 5
fi


################################################################################
echo "Install Splunk from INSTALL_FILES_DIR/rpms -"
################################################################################
if [ "$2" != "--fast" ]; then

	cd $INSTALL_FILES_DIR/rpms
	rpm -i splunk*.rpm
fi

################################################################################
echo "Install MongoDB -"
################################################################################
echo "Create default data directories -"
################################################################################
sudo mkdir -p /data/db/
sudo chown `id -u` /data/db
################################################################################
echo "Install MongoDB -"
################################################################################
cp $INSTALL_FILES_DIR/etc/yum.repos.d/10gen-mongodb.repo /etc/yum.repos.d/
if [ "$2" != "--fast" ]; then
	yes | yum update -y
fi
yes | yum install mongo-10gen mongo-10gen-server -y
sleep 10


################################################################################
echo "Install elasticsearch for APINodes Only -"
################################################################################
if [ "$NODE_TYPE" = "APINode" ]; then
	if [ ! -f /etc/yum.repos.d/ikanow.repo ]; then
		curl -O 'http://www.ikanow.com/infinit.e-preinstall/ikanow.repo'
		cp ikanow.repo /etc/yum.repos.d/
	fi
	yes | yum install elasticsearch -y
	sleep 5
fi


################################################################################
echo "Install curl -"
################################################################################
yes | yum install curl -y


################################################################################
echo "Update the Yum repository one last time"
################################################################################
if [ "$2" != "--fast" ]; then
	yes | yum update -y
fi


echo "################################################################################"
echo "IMPORTANT NOTES:"
echo "Copy /mnt/opt/infinite-install/config/infinite.configuration.properties.TEMPLATE to"
echo "/mnt/opt/infinite-install/config/infinite.configuration.properties and edit the"
echo "properties contained within the file to match your deployment environment."
echo "################################################################################"
