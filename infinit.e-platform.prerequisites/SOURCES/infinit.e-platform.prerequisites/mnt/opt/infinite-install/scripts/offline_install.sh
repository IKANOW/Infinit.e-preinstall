#!/bin/bash
################################################################################
# install.sh
################################################################################
# API Node   - Tested, Red Hat 5.5 1/11/2012
# DB Node    - 
################################################################################

NONOREPO='--disablerepo=*'
NOREPO='--disablerepo=* --enablerepo=infinite'

################################################################################
# Commandline arguments
################################################################################
# apinode_(latest|v0.3|v0.2|v0.1) 
# dbnode_(latest|v0.3|v0.2|v0.1)
# apinode_latest is default
################################################################################
NODE_TYPE="APINode"
ES_VERSION="1.0"
MONGODB_VERSION="2.6"
if [ $# -gt 0 ]; then
  case $1 in
    dbnode_latest )
     NODE_TYPE="DBNode" ;;
    dbnode_v0.4 )
     NODE_TYPE="DBNode" ;;
                                                                                                                                                                                                                                                                
    apinode_latest )
     NODE_TYPE="APINode" ;;
    apinode_v0.4 )
     NODE_TYPE="APINode" ;;
    * )
      echo "v0.4 offline repo does not support older MongoDB/elasticsearch versions - use the S3 archive"
    ;;            
  esac
 shift
fi
echo "Off-line (Disconnected) Installation: $NODE_TYPE (es=$ES_VERSION mongo=$MONGODB_VERSION)"

if uname -a | grep -q amzn; then
	echo "CentOS Linux release 6 (Amazon Linux)" > /etc/redhat-release
		#(Amazon is close enough to Redhat for us to make this present, ie it's not debian etc)
		#(this precise string is required for Cloudera hadoop to install) 
fi
if cat /etc/redhat-release | grep -iq "centos.*release 6"; then
	#This file needs to be removed for Centos6 (etc) installs:
	rm /opt/infinite-install/rpms/dependencies/eclipse-ecj-*.rpm
fi

################################################################################
# Directory install files are copied too
################################################################################
INSTALL_FILES_DIR="/mnt/opt/infinite-install"


################################################################################
echo "Create yum repo for /mnt/opt/infinite-install/rpms/dependencies -"
################################################################################
cd $INSTALL_FILES_DIR/rpms/dependencies
yes | yum $NONOREPO localinstall libxml2-python-*.rpm --nogpgcheck
yes | yum $NONOREPO localinstall createrepo-*.rpm --nogpgcheck
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
yes | yum $NOREPO localinstall rpm-build-*.rpm --nogpgcheck
sleep 5


################################################################################
echo "Install jpackage-utils (jpackage.org) and yum-priorities -"
################################################################################
cd $INSTALL_FILES_DIR/rpms
yes | yum $NOREPO localinstall jpackage-utils-*.rpm --nogpgcheck
yes | yum $NOREPO localinstall yum-priorities-*.rpm --nogpgcheck
sleep 5


################################################################################
echo "Install s3cmd -"
################################################################################
cd $INSTALL_FILES_DIR/rpms
yes | yum $NOREPO localinstall s3cmd-*.rpm --nogpgcheck
yes | yum $NOREPO localinstall dos2unix-*.rpm --nogpgcheck
sleep 5


################################################################################
echo "Install Java JRE and JDK -"
################################################################################
cd $INSTALL_FILES_DIR/rpms
rpm -U --force jdk-7*.rpm
rm -rf /usr/java/latest
ln -sf /usr/java/jdk1.7.0_71 /usr/java/latest
rm -rf /usr/java/default
ln -sf /usr/java/latest /usr/java/default
sleep 5

#RH installs makes /usr/bin/java point to /etc/alternatives/java (which points to some old version)
ln -sf /usr/java/default/bin/java /usr/bin/java 

################################################################################
echo "Install Tomcat -"
################################################################################
#(remove some stuff that can conflict)
rpm --quiet -ql logwatch && rpm -e --nodeps logwatch
rpm --quiet -ql smartmontools && rpm -e --nodeps smartmontools
rpm --quiet -ql mailx && rpm -e --nodeps mailx
#(tomcat install)
cd $INSTALL_FILES_DIR/rpms
rpm -Uvh jpackage-utils-compat-el5-0.0.1-1.noarch.rpm
cd $INSTALL_FILES_DIR/rpms/dependencies
yes | yum $NOREPO localinstall pango-*.rpm --nogpgcheck
yes | yum $NOREPO localinstall gtk2-*.rpm --nogpgcheck
cd $INSTALL_FILES_DIR/rpms
yes | yum $NOREPO localinstall tomcat6-*.rpm --nogpgcheck
yes | yum $NOREPO localinstall tomcat6-admin-webapps-*.rpm --nogpgcheck
yes | yum $NOREPO localinstall tomcat6-webapps-*.rpm --nogpgcheck
chkconfig tomcat6 off
sleep 5
# Some versions of tomcat appear to force tomcat user to /sbin/nologin, so change it back:
chsh -s /bin/sh tomcat

################################################################################
echo "Install MongoDB -"
################################################################################
cd $INSTALL_FILES_DIR/rpms
if [ "$MONGODB_VERSION" = "2.6" ]; then
	yes | yum $NOREPO localinstall mongodb-org-* --nogpgcheck
else
	echo "MongoDB $MONGODB_VERSION Not supported"
fi
sleep 10


################################################################################
echo "Install elasticsearch  -"
################################################################################
cd $INSTALL_FILES_DIR/rpms
if [ "$ES_VERSION" = "1.0" ]; then
	yes | yum $NOREPO localinstall elasticsearch-1.0*.rpm --nogpgcheck
else
	echo "Elasticsearch $ES_VERSION Not supported"
fi

################################################################################
echo "Install curl -"
################################################################################
cd $INSTALL_FILES_DIR/rpms
yes | yum $NOREPO localinstall curl-*.rpm --nogpgcheck


echo "################################################################################"
echo "IMPORTANT:"
echo "Copy /mnt/opt/infinite-install/config/infinite.configuration.properties.TEMPLATE to"
echo "/mnt/opt/infinite-install/config/infinite.configuration.properties and edit the"
echo "properties contained within the file to match your deployment environment."
echo "################################################################################"
