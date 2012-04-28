###########################################################################
# Spec file for infinit.e-hadoop-installer.online
###########################################################################
Summary: 	infinit.e-hadoop-installer.online
Name: 		infinit.e-hadoop-installer.online
Version: 	INFINITE_VERSION
Release: 	INFINITE_RELEASE
License: 	None
Group: 		Infinit.e
Vendor: 	IKANOW, LLC.
URL: 		http://www.ikanow.com
BuildArch: 	noarch
Prefix: /mnt/opt
%description
infinit.e-hadoop-installer.online
###########################################################################

###########################################################################
# SCRIPTLETS, IN ORDER OF EXECUTION
###########################################################################
%prep
	# (create build files)
	zcat $RPM_SOURCE_DIR/infinit.e-hadoop-installer-online.tgz | tar -xvf -

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
		cp /mnt/opt/hadoop-infinite/scripts/online_install.sh /mnt/opt/hadoop-infinite/install.sh
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
# jars
###########################################################################
%attr(-,root,root) /mnt/opt/hadoop-infinite/jars/mongo-2.7.2.jar

###########################################################################
# Install scripts
###########################################################################
%attr(-,root,root) /mnt/opt/hadoop-infinite/scripts/online_install.sh
