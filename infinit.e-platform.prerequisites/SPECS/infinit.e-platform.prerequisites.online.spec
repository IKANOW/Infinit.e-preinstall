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
	if [ $1 -eq 1 ]; then
		cp /mnt/opt/infinit.e-install/scripts/online_install.sh /mnt/opt/infinit.e-install/install.sh	
	fi

###########################################################################
# FILE LISTS
###########################################################################
%files
%define _unpackaged_files_terminate_build 0

###########################################################################
# Configuration template files
###########################################################################
%attr(-,root,root) /mnt/opt/infinit.e-install/config/infinite.configuration.properties.TEMPLATE

###########################################################################
# Install scripts
###########################################################################
%attr(-,root,root) /mnt/opt/infinit.e-install/scripts/online_install.sh

###########################################################################
# yum repo files
###########################################################################
%attr(-,root,root) /mnt/opt/infinit.e-install/etc/yum.repos.d/10gen-mongodb.repo
%attr(-,root,root) /mnt/opt/infinit.e-install/etc/yum.repos.d/ikanow-infinite.repo

###########################################################################
# rpms to install
###########################################################################
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/jre-6u30-linux-x64-rpm.bin
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/jdk-6u30-linux-x64.bin
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/splunk-4.2.4-110225-linux-2.6-x86_64.rpm

###########################################################################
# s3cmd gpgkey
###########################################################################
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/repomd.xml.key

###########################################################################
# Data files
###########################################################################
# Commented out from online install 
#%attr(-,root,root) /mnt/opt/infinit.e-install/data/feature/geo.bson.tar.gz
