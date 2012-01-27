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
INSTALL_FILES_DIR="/mnt/opt/infinit.e-install"


################################################################################
echo "Create yum repo for /mnt/opt/infinit.e-install/rpms/dependencies -"
################################################################################
yes | yum install createrepo -y
sleep 5


################################################################################
echo "Install rpm-build -"
################################################################################
yes | yum install rpm-build -y
sleep 5


################################################################################
echo "Install jpackage-utils (jpackage.org) and yum-priorities -"
################################################################################
yes | yum install jpackage-utils -y
yes | yum install yum-priorities -y
sleep 5


################################################################################
echo "Install s3cmd -"
################################################################################
cd /etc/yum.repos.d
wget http://s3tools.org/repo/CentOS_5/s3tools.repo
yes | yum install s3cmd -y
sleep 5


################################################################################
echo "Install Java -"
################################################################################
yes | yum install java -y
sleep 5


################################################################################
echo "Install Tomcat -"
################################################################################
rpm -Uvh http://plone.lucidsolutions.co.nz/linux/centos/images/jpackage-utils-compat-el5-0.0.1-1.noarch.rpm
cd /etc/yum.repos.d
wget 'http://www.jpackage.org/jpackage50.repo'
yes | yum update -y
yes | yum install tomcat6 tomcat6-webapps tomcat6-admin-webapps -y
chkconfig tomcat6 off
sleep 5


################################################################################
echo "Install Splunk from INSTALL_FILES_DIR/rpms -"
################################################################################
cd $INSTALL_FILES_DIR/rpms
rpm -i splunk*.rpm


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
yes | yum update -y
yes | yum install mongo-10gen mongo-10gen-server -y

################################################################################
echo "Start mongod service"
################################################################################
service mongod start
sleep 10

################################################################################
# echo "untar geo collection and add it to the MongoDB server via mongorestore"
################################################################################
# cd $INSTALL_FILES_DIR/data/feature
# tar -zxvf geo.bson.tar.gz
# mongorestore $INSTALL_FILES_DIR/data/feature/geo.bson


################################################################################
echo "Install elasticsearch for APINodes Only -"
################################################################################
if [ "$NODE_TYPE" = "APINode" ]; then
	cp $INSTALL_FILES_DIR/etc/yum.repos.d/ikanow-infinite.repo /etc/yum.repos.d/
	yes | yum install elasticsearch -y
	sleep 5
fi


################################################################################
echo "Install curl -"
################################################################################
yes | yum install curl -y


################################################################################
echo "Install hadoop for APINodes Only -"
################################################################################
if [ "$NODE_TYPE" = "APINode" ]; then
	groupadd hadoop
	useradd -g hadoop -p hduser hduser
	cd /etc/yum.repos.d
  	wget 'http://archive.cloudera.com/redhat/cdh/cloudera-cdh3.repo'
	yes | yum install hadoop -y
	yes | yum install hue -y
	mkdir /mnt/opt/hadoop-infinite/
	mkdir /mnt/opt/hadoop-infinite/mapreduce
fi


################################################################################
echo "Update the Yum repository one last time"
################################################################################
yes | yum update -y


echo "################################################################################"
echo "IMPORTANT:"
echo "Copy /mnt/opt/infinit.e-install/config/infinite.configuration.properties.TEMPLATE to"
echo "/mnt/opt/infinit.e-install/config/infinite.configuration.properties and edit the"
echo "properties contained within the file to match your deployment environment."
echo "################################################################################"
