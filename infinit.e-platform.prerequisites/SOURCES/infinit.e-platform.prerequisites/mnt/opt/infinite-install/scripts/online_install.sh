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
# apinode_(latest|v0.3|v0.2|v0.1) [--fast] 
# dbnode_(latest|v0.3|v0.2|v0.1) [--fast]
# apinode_latest is default
# "--fast" bypasses installing latest java/jpackage (for AMIs)
################################################################################
NODE_TYPE="APINode"
ES_VERSION="1.0"
MONGODB_VERSION="2.4"
if [ $# -gt 0 ]; then
  case $1 in
    dbnode_latest )
     NODE_TYPE="DBNode" ;;
    dbnode_v0.3 )
     NODE_TYPE="DBNode" ;;
    dbnode )
     NODE_TYPE="DBNode" ;;        
    dbnode_v0.2 )
     NODE_TYPE="DBNode" ;;
    dbnode_v0.1 )
     NODE_TYPE="DBNode" 
     MONGODB_VERSION="2.2"
    	;;	     
                                                                                                                                                                                                                                                                
    apinode_latest )
     NODE_TYPE="APINode" ;;
    apinode_v0.3 )
     NODE_TYPE="APINode" ;;
    apinode_v0.2 )
     NODE_TYPE="APINode"
     ES_VERSION="0.19"
    ;; 
    apinode_v0.1 )
     NODE_TYPE="APINode"
     MONGODB_VERSION="2.2"
     ES_VERSION="0.19" 
    ;; 
    apinode )
     NODE_TYPE="APINode"
     ES_VERSION="0.19" 
    ;;
  esac
 shift
fi
FASTARG=$2
echo "Online Installation: $NODE_TYPE (es=$ES_VERSION mongo=$MONGODB_VERSION fast=$FASTARG)"

if uname -a | grep -q amzn; then
	echo "CentOS Linux release 6 (Amazon Linux)" > /etc/redhat-release
		#(Amazon is close enough to Redhat for us to make this present, ie it's not debian etc)
		#(this precise string is required for Cloudera hadoop to install) 
fi

################################################################################
# Directory install files are copied too
################################################################################
INSTALL_FILES_DIR="/mnt/opt/infinite-install"

################################################################################
echo "Checking for heartbleed fix -"
################################################################################
yes | yum update openssl openssl-devel -y

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

# This repo is a little bit flaky and the current ones work fine, so just use local caches
if cat /etc/redhat-release | grep -iq "centos.*release 6"; then
	wget http://s3tools.org/repo/RHEL_6/s3tools.repo
	rpm -Uvh $INSTALL_FILES_DIR/rpms/s3cmd-el6-1.0.0-4.1.x86_64.rpm
else
	wget http://s3tools.org/repo/RHEL_5/s3tools.repo
	rpm -Uvh $INSTALL_FILES_DIR/rpms/s3cmd-el5-1.0.0-4.1.x86_64.rpm
fi
yes | yum install dos2unix
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
	yes | yum install tomcat6 tomcat6-webapps tomcat6-admin-webapps -y
	chkconfig tomcat6 off
	sleep 5
fi
# Some versions of tomcat appear to force tomcat user to /sbin/nologin, so change it back:
chsh -s /bin/sh tomcat


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
if [ "$MONGODB_VERSION" = "2.4" ]; then
	yes | yum install mongo-10gen-2.4.10 mongo-10gen-server-2.4.10 -y --exclude=mongodb-org*
else
	yes | yum install mongo-10gen-2.2.3 mongo-10gen-server-2.2.3 -y --exclude=mongodb-org*
fi
sleep 10


################################################################################
echo "Install elasticsearch for APINodes Only -"
################################################################################
if [ "$NODE_TYPE" = "APINode" ]; then
	cp $INSTALL_FILES_DIR/etc/yum.repos.d/elasticsearch.repo /etc/yum.repos.d/
	if [ "$ES_VERSION" = "1.0" ]; then
		yes | yum install elasticsearch -y -x  --disablerepo=* --enablerepo=elasticsearch*
	else
		if [ ! -f /etc/yum.repos.d/ikanow.repo ]; then
			curl -O 'http://www.ikanow.com/infinit.e-preinstall/ikanow.repo'
			cp ikanow.repo /etc/yum.repos.d/
		fi
		yes | yum install elasticsearch -y --disablerepo=* --enablerepo=ikanow*
fi
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

echo "################################################################################"
echo "IMPORTANT NOTES:"
echo "Copy /mnt/opt/infinite-install/config/infinite.configuration.properties.TEMPLATE to"
echo "/mnt/opt/infinite-install/config/infinite.configuration.properties and edit the"
echo "properties contained within the file to match your deployment environment."
echo "################################################################################"
