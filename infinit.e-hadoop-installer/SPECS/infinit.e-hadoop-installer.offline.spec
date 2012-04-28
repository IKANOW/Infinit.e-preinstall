###########################################################################
# Spec file for infinit.e-hadoop-installer.offline
###########################################################################
Summary: 	infinit.e-hadoop-installer.offline
Name: 		infinit.e-hadoop-installer.offline
Version: 	INFINITE_VERSION
Release: 	INFINITE_RELEASE
License: 	None
Group: 		Infinit.e
Vendor: 	IKANOW, LLC.
URL: 		http://www.ikanow.com
BuildArch: 	noarch
Prefix: /mnt/opt
Requires: 	jdk >= 1.6
%description
infinit.e-hadoop-installer.offline
###########################################################################

###########################################################################
# SCRIPTLETS, IN ORDER OF EXECUTION
###########################################################################
%prep
	# (create build files)
	zcat $RPM_SOURCE_DIR/infinit.e-hadoop-installer-offline.tgz | tar -xvf -

###########################################################################
# 
###########################################################################
%post
	# Handle relocation:
	if [ "$RPM_INSTALL_PREFIX" != "/opt" ]; then
		echo "(Creating links from /opt to $RPM_INSTALL_PREFIX)"
	 	if [ -d /opt/hadoop-infinite ] && [ ! -h /opt/hadoop-infinite ]; then
			echo "Error: /opt/infinite-install exits"
			exit 1
		else
			ln -sf $RPM_INSTALL_PREFIX/hadoop-infinite /opt
		fi 
	fi
	
	if [ $1 -eq 1 ]; then
		cp /mnt/opt/hadoop-infinite/scripts/offline_install.sh /mnt/opt/hadoop-infinite/install.sh	
	fi

###########################################################################
# FILE LISTS
###########################################################################
%files
%define _unpackaged_files_terminate_build 0
%define _binaries_in_noarch_packages_terminate_build 0

###########################################################################
# Cloudera-manager installation application
###########################################################################
%attr(-,root,root) /mnt/opt/hadoop-infinite/scm-installer.bin

###########################################################################
# Install scripts
###########################################################################
%attr(-,root,root) /mnt/opt/hadoop-infinite/scripts/offline_install.sh

###########################################################################
# yum repo files
###########################################################################
%attr(-,root,root) /mnt/opt/hadoop-infinite/etc/yum.repos.d/cloudera.repo
%attr(-,root,root) /mnt/opt/hadoop-infinite/etc/yum.repos.d/cloudera-manager.repo

###########################################################################
# rpms dependencies
###########################################################################
%attr(-,root,root) /mnt/opt/hadoop-infinite/rpms/cloudera-manager-agent-3.7.2.143-1.x86_64.rpm
%attr(-,root,root) /mnt/opt/hadoop-infinite/rpms/cloudera-manager-daemons-3.7.2.143-1.noarch.rpm
%attr(-,root,root) /mnt/opt/hadoop-infinite/rpms/cloudera-manager-plugins-3.7.2.143-1.noarch.rpm
%attr(-,root,root) /mnt/opt/hadoop-infinite/rpms/cloudera-manager-server-3.7.2.143-1.noarch.rpm
%attr(-,root,root) /mnt/opt/hadoop-infinite/rpms/cloudera-manager-server-db-3.7.2.143-1.noarch.rpm
%attr(-,root,root) /mnt/opt/hadoop-infinite/rpms/createrepo-0.4.11-3.el5.noarch.rpm
%attr(-,root,root) /mnt/opt/hadoop-infinite/rpms/cyrus-sasl-gssapi-2.1.22-5.el5_4.3.x86_64.rpm
%attr(-,root,root) /mnt/opt/hadoop-infinite/rpms/hadoop-0.20-0.20.2+923.194-1.noarch.rpm
%attr(-,root,root) /mnt/opt/hadoop-infinite/rpms/hadoop-0.20-native-0.20.2+923.194-1.x86_64.rpm
%attr(-,root,root) /mnt/opt/hadoop-infinite/rpms/hadoop-0.20-sbin-0.20.2+923.194-1.x86_64.rpm
%attr(-,root,root) /mnt/opt/hadoop-infinite/rpms/hadoop-hbase-0.90.4+49.137-1.noarch.rpm
%attr(-,root,root) /mnt/opt/hadoop-infinite/rpms/hadoop-hive-0.7.1+42.27-2.noarch.rpm
%attr(-,root,root) /mnt/opt/hadoop-infinite/rpms/hadoop-zookeeper-3.3.4+19.3-1.noarch.rpm
%attr(-,root,root) /mnt/opt/hadoop-infinite/rpms/hue-1.2.0.0+114.4-2.noarch.rpm
%attr(-,root,root) /mnt/opt/hadoop-infinite/rpms/hue-about-1.2.0.0+114.4-2.noarch.rpm
%attr(-,root,root) /mnt/opt/hadoop-infinite/rpms/hue-beeswax-1.2.0.0+114.4-2.noarch.rpm
%attr(-,root,root) /mnt/opt/hadoop-infinite/rpms/hue-common-1.2.0.0+114.4-2.x86_64.rpm
%attr(-,root,root) /mnt/opt/hadoop-infinite/rpms/hue-filebrowser-1.2.0.0+114.4-2.noarch.rpm
%attr(-,root,root) /mnt/opt/hadoop-infinite/rpms/hue-hadoop-auth-plugin-3.7.2.1-1.noarch.rpm
%attr(-,root,root) /mnt/opt/hadoop-infinite/rpms/hue-shelp-1.2.0.0+114.4-2.noarch.rpm
%attr(-,root,root) /mnt/opt/hadoop-infinite/rpms/hue-jobbrowser-1.2.0.0+114.4-2.noarch.rpm
%attr(-,root,root) /mnt/opt/hadoop-infinite/rpms/hue-jobsub-1.2.0.0+114.4-2.noarch.rpm
%attr(-,root,root) /mnt/opt/hadoop-infinite/rpms/hue-oozie-auth-plugin-3.7.2.1-1.noarch.rpm
%attr(-,root,root) /mnt/opt/hadoop-infinite/rpms/hue-plugins-1.2.0.0+114.4-2.noarch.rpm
%attr(-,root,root) /mnt/opt/hadoop-infinite/rpms/hue-proxy-1.2.0.0+114.4-2.noarch.rpm
%attr(-,root,root) /mnt/opt/hadoop-infinite/rpms/hue-shell-1.2.0.0+114.4-2.x86_64.rpm
%attr(-,root,root) /mnt/opt/hadoop-infinite/rpms/hue-useradmin-1.2.0.0+114.4-2.noarch.rpm
%attr(-,root,root) /mnt/opt/hadoop-infinite/rpms/libxslt-1.1.17-2.el5_2.2.x86_64.rpm
%attr(-,root,root) /mnt/opt/hadoop-infinite/rpms/oozie-2.3.2+27.12-1.noarch.rpm
%attr(-,root,root) /mnt/opt/hadoop-infinite/rpms/oozie-client-2.3.2+27.12-1.noarch.rpm
%attr(-,root,root) /mnt/opt/hadoop-infinite/rpms/postgresql-8.1.23-1.el5_7.3.x86_64.rpm
%attr(-,root,root) /mnt/opt/hadoop-infinite/rpms/postgresql-libs-8.1.23-1.el5_7.3.x86_64.rpm
%attr(-,root,root) /mnt/opt/hadoop-infinite/rpms/postgresql-server-8.1.23-1.el5_7.3.x86_64.rpm
%attr(-,root,root) /mnt/opt/hadoop-infinite/rpms/redhat-lsb-4.0-2.1.4.el5.x86_64.rpm
%attr(-,root,root) /mnt/opt/hadoop-infinite/rpms/RPM-GPG-KEY-cloudera

###########################################################################
# jars
###########################################################################
%attr(-,root,root) /mnt/opt/hadoop-infinite/jars/mongo-2.7.2.jar

###########################################################################
# SimpleWebServer webserver
###########################################################################
%attr(-,root,root) /mnt/opt/hadoop-infinite/webroot/SimpleWebServer.jar
