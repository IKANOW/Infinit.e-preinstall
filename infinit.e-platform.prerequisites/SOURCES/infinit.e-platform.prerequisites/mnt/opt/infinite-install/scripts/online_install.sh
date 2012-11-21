#!/bin/bash
################################################################################
# install.sh
################################################################################
# API Node   - Tested, Red Hat 5.5 1/11/2012
# DB Node    - Tested, Red Hat 5.5 1/11/2012
# API/DB     - Tested, Amazon Linux 2012.09 (equivalent to RHEL6/CentOS6)
################################################################################

################################################################################
# Commandline arguments
################################################################################
# $1 - APINode or DBNode (API is default) 
# $FASTARG is "--fast" to bypassing installing latest java/jpackage (for AMIs)
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

FASTARG=$2
# For Amazon build, always use "slow" (which is actually pretty fast anyway, Amazon is pretty up-to-date)
if uname -a | grep -q amzn; then
	FASTARG=""
fi

################################################################################
# Directory install files are copied too
################################################################################
INSTALL_FILES_DIR="/mnt/opt/infinite-install"


################################################################################
echo "Create yum repo for /mnt/opt/infinite-install/rpms/dependencies -"
################################################################################
if [ "$FASTARG" != "--fast" ]; then

	yes | yum install createrepo -y
	sleep 5
fi

################################################################################
echo "Install rpm-build -"
################################################################################
if [ "$FASTARG" != "--fast" ]; then

	yes | yum install rpm-build -y
	sleep 5
fi

################################################################################
echo "Install jpackage-utils (jpackage.org) and yum-priorities -"
################################################################################
if [ "$FASTARG" != "--fast" ]; then

	yes | yum install jpackage-utils -y
	yes | yum install yum-priorities -y
	sleep 5
fi

################################################################################
echo "Install s3cmd -"
################################################################################
cd /etc/yum.repos.d

if uname -r | grep -q "^3"; then
	wget http://s3tools.org/repo/CentOS_6/s3tools.repo
else
	wget http://s3tools.org/repo/CentOS_5/s3tools.repo
fi
yes | yum install s3cmd -y
sleep 5


################################################################################
echo "Install Java JRE and JDK -"
################################################################################

if [ "$FASTARG" != "--fast" ]; then

	cd $INSTALL_FILES_DIR/rpms
	chmod a+x jre-*-linux-x64-rpm.bin
	sh jre-*-linux-x64-rpm.bin
	chmod a+x jdk-*-linux-x64-rpm.bin
	sh jdk-*-linux-x64.bin
	mv jdk1.6.*/ /usr/java/
	sleep 5
fi

#RH installs makes /usr/bin/java point to /etc/alternatives/java (which points to some old version)
ln -sf /usr/java/default/bin/java /usr/bin/java 

################################################################################
echo "Install Tomcat -"
################################################################################

if [ "$FASTARG" != "--fast" ]; then

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
if [ "$FASTARG" != "--fast" ]; then
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
echo "Install extra Python dependency needed for MongoDB monitoring"
################################################################################
cd $INSTALL_FILES_DIR/rpms
rpm -Uvh python-devel-2.4.3-27.el5_5.3.x86_64.rpm

################################################################################
echo "Update the Yum repository one last time"
################################################################################
if [ "$FASTARG" != "--fast" ]; then
	yes | yum update -y
fi


echo "################################################################################"
echo "IMPORTANT NOTES:"
echo "Copy /mnt/opt/infinite-install/config/infinite.configuration.properties.TEMPLATE to"
echo "/mnt/opt/infinite-install/config/infinite.configuration.properties and edit the"
echo "properties contained within the file to match your deployment environment."
echo "################################################################################"
