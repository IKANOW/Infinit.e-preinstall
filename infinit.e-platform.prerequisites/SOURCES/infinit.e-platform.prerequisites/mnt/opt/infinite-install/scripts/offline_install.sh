#!/bin/bash
################################################################################
# install.sh
################################################################################
# API Node   - Tested, Red Hat 5.5 1/11/2012
# DB Node    - 
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
echo "Off-line (Disconnected) Installation: $NODE_TYPE"


################################################################################
# Directory install files are copied too
################################################################################
INSTALL_FILES_DIR="/mnt/opt/infinite-install"


################################################################################
echo "Create yum repo for /mnt/opt/infinite-install/rpms/dependencies -"
################################################################################
cd $INSTALL_FILES_DIR/rpms/dependencies
yes | yum localinstall libxml2-python-*.rpm --nogpgcheck
yes | yum localinstall createrepo-*.rpm --nogpgcheck
createrepo $INSTALL_FILES_DIR/rpms/dependencies
sleep 5


################################################################################
echo "Copy files to /etc/yum.repos.d/ -"
################################################################################
cp $INSTALL_FILES_DIR/etc/yum.repos.d/infinite.repo /etc/yum.repos.d/
sleep 5


################################################################################
echo "Install rpm-build -"
################################################################################
cd $INSTALL_FILES_DIR/rpms
yes | yum localinstall rpm-build-*.rpm --nogpgcheck
sleep 5


################################################################################
echo "Install jpackage-utils (jpackage.org) and yum-priorities -"
################################################################################
cd $INSTALL_FILES_DIR/rpms
yes | yum localinstall jpackage-utils-*.rpm --nogpgcheck
yes | yum localinstall yum-priorities-*.rpm --nogpgcheck
sleep 5


################################################################################
echo "Install s3cmd -"
################################################################################
cd $INSTALL_FILES_DIR/rpms
yes | yum localinstall s3cmd-*.rpm --nogpgcheck
sleep 5


################################################################################
echo "Install Java JRE and JDK -"
################################################################################
cd $INSTALL_FILES_DIR/rpms
chmod a+x jre-*-linux-x64-rpm.bin
sh jre-*-linux-x64-rpm.bin
chmod a+x jdk-*-linux-x64-rpm.bin
sh jdk-*-linux-x64.bin
mv jdk1.6.*/ /usr/java/
sleep 5

#RH installs makes /usr/bin/java point to /etc/alternatives/java (which points to some old version)
ln -sf /usr/java/default/bin/java /usr/bin/java 

################################################################################
echo "Install Tomcat -"
################################################################################
cd $INSTALL_FILES_DIR/rpms
rpm -Uvh jpackage-utils-compat-el5-0.0.1-1.noarch.rpm
cd $INSTALL_FILES_DIR/rpms/dependencies
yes | yum localinstall pango-*.rpm --nogpgcheck
yes | yum localinstall gtk2-*.rpm --nogpgcheck
cd $INSTALL_FILES_DIR/rpms
yes | yum localinstall tomcat6-*.rpm --nogpgcheck
yes | yum localinstall tomcat6-admin-webapps-*.rpm --nogpgcheck
yes | yum localinstall tomcat6-webapps-*.rpm --nogpgcheck
chkconfig tomcat6 off
sleep 5

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
cd $INSTALL_FILES_DIR/rpms
yes | yum localinstall mongo-10gen-*.rpm --nogpgcheck
yes | yum localinstall mongo-10gen-server-*.rpm --nogpgcheck
sleep 10


################################################################################
echo "Install elasticsearch for APINodes Only -"
################################################################################
if [ "$NODE_TYPE" = "APINode" ]; then
	cd $INSTALL_FILES_DIR/rpms
	yes | yum localinstall elasticsearch-*.rpm --nogpgcheck
fi


################################################################################
echo "Install curl -"
################################################################################
cd $INSTALL_FILES_DIR/rpms
yes | yum localinstall curl-*.rpm --nogpgcheck


echo "################################################################################"
echo "IMPORTANT:"
echo "Copy /mnt/opt/infinite-install/config/infinite.configuration.properties.TEMPLATE to"
echo "/mnt/opt/infinite-install/config/infinite.configuration.properties and edit the"
echo "properties contained within the file to match your deployment environment."
echo "################################################################################"
