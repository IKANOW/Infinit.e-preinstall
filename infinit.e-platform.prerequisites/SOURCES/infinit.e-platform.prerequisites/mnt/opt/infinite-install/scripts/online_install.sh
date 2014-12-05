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
MONGODB_VERSION="2.6"
if [ $# -gt 0 ]; then
  case $1 in
    dbnode_latest )
     NODE_TYPE="DBNode"
    ;;
    dbnode_0.4 )
     NODE_TYPE="DBNode"
    ;;
    dbnode_v0.3 )
     NODE_TYPE="DBNode" 
     MONGODB_VERSION="2.4"
    ;;
                                                                                                                                                                                                                                                                
    apinode_latest )
     NODE_TYPE="APINode" ;;
    apinode_v0.4 )
     NODE_TYPE="APINode" 
    ;;
    apinode_v0.3 )
     NODE_TYPE="APINode" 
    ;;
    * )
      echo "v0.4 online repo does not support older MongoDB/elasticsearch versions - use the S3 archive"
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
	rpm -Uvh $INSTALL_FILES_DIR/rpms/s3cmd-el6-1.0.0-4.1.x86_64.rpm
else
	rpm -Uvh $INSTALL_FILES_DIR/rpms/s3cmd-el5-1.0.0-4.1.x86_64.rpm
fi
yes | yum install dos2unix
sleep 5


################################################################################
echo "Install Java JDK -"
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
cp $INSTALL_FILES_DIR/etc/yum.repos.d/10gen-mongodb.repo /etc/yum.repos.d/
if [ "$MONGODB_VERSION" = "2.6" ]; then
	yes | yum install mongodb-org-2.6.4
elif [ "$MONGODB_VERSION" = "2.4" ]; then
	yes | yum install mongo-10gen-2.4.10 mongo-10gen-server-2.4.10 -y --exclude=mongodb-org*
else
	yes | yum install mongo-10gen-2.2.3 mongo-10gen-server-2.2.3 -y --exclude=mongodb-org*
fi
sleep 10

################################################################################
echo "Install elasticsearch -"
################################################################################
if [ "$ES_VERSION" = "1.0" ]; then
	# Centos5 doesn't support the ES repo - will need to install separately
	if ! cat /etc/redhat-release | grep -iq 'release 5'; then
		cp $INSTALL_FILES_DIR/etc/yum.repos.d/elasticsearch.repo /etc/yum.repos.d/
		yes | yum install elasticsearch -y -x  --disablerepo=* --enablerepo=elasticsearch*
	else
		curl -o "$INSTALL_FILES_DIR/rpms/elasticsearch-1.0.3.noarch.rpm" -k \
			'https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.0.3.noarch.rpm'
		rpm -i "$INSTALL_FILES_DIR/rpms/elasticsearch-1.0.3.noarch.rpm"
	fi
else
	echo "Elasticsearch version $ES_VERSION no longer supported"
fi
sleep 5


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
