###########################################################################
# Spec file for infinit.e-platform.prerequisites.online
###########################################################################
Summary: 	infinit.e-platform.prerequisites.online
Name: 		infinit.e-platform.prerequisites.online
Version: 	INFINITE_VERSION
Release: 	INFINITE_RELEASE
License: 	None
Group: 		Infinit.e
Vendor: 	IKANOW, LLC.
URL: 		http://www.ikanow.com
BuildArch: 	noarch
Prefix: /mnt/opt
%description
infinit.e-platform.prerequisites.online
###########################################################################

###########################################################################
# SCRIPTLETS, IN ORDER OF EXECUTION
###########################################################################
%prep
	# (create build files)
	zcat $RPM_SOURCE_DIR/infinit.e-platform.prerequisites-online.tgz | tar -xvf -

###########################################################################
# 
###########################################################################
%post
	# Handle relocation:
	if [ "$RPM_INSTALL_PREFIX" != "/opt" ]; then
		echo "(Creating links from /opt to $RPM_INSTALL_PREFIX)"
	 	if [ -d /opt/infinite-install ] && [ ! -h /opt/infinite-install ]; then
			echo "Error: /opt/infinite-install exits"
			exit 1
		else
			ln -sf $RPM_INSTALL_PREFIX/infinite-install /opt
		fi 
	fi
	
	if [ $1 -eq 1 ]; then
		cp /mnt/opt/infinite-install/scripts/online_install.sh /mnt/opt/infinite-install/install.sh	
	fi

###########################################################################
# FILE LISTS
###########################################################################
%files
%define _unpackaged_files_terminate_build 0

###########################################################################
# Configuration template files
###########################################################################
%attr(-,root,root) /mnt/opt/infinite-install/config/infinite.configuration.properties.TEMPLATE.OFFLINE
%attr(-,root,root) /mnt/opt/infinite-install/config/infinite.configuration.properties.TEMPLATE.ONLINE

###########################################################################
# Install scripts
###########################################################################
%attr(-,root,root) /mnt/opt/infinite-install/scripts/online_install.sh

###########################################################################
# yum repo files
###########################################################################
%attr(-,root,root) /mnt/opt/infinite-install/etc/yum.repos.d/10gen-mongodb.repo

###########################################################################
# rpms to install
###########################################################################
%attr(-,root,root) /mnt/opt/infinite-install/rpms/jre-6u30-linux-x64-rpm.bin
%attr(-,root,root) /mnt/opt/infinite-install/rpms/jdk-6u30-linux-x64.bin
%attr(-,root,root) /mnt/opt/infinite-install/rpms/jpackage-utils-compat-el5-0.0.1-1.noarch.rpm
%attr(-,root,root) /mnt/opt/infinite-install/rpms/splunk-4.2.4-110225-linux-2.6-x86_64.rpm

###########################################################################
# s3cmd gpgkey
###########################################################################
%attr(-,root,root) /mnt/opt/infinite-install/rpms/repomd.xml.key

###########################################################################
# Data files
###########################################################################
# Commented out from online install 
%dir /mnt/opt/infinite-install/data/feature
#%attr(-,root,root) /mnt/opt/infinite-install/data/feature/geo.bson.tar.gz
