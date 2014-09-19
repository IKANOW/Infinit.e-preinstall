###########################################################################
# Spec file for infinit.e-logstash-installer.offline
###########################################################################
Summary: 	infinit.e-logstash-installer.offline
Name: 		infinit.e-logstash-installer.offline
Version: 	INFINITE_VERSION
Release: 	INFINITE_RELEASE
License: 	None
Group: 		Infinit.e
Vendor: 	IKANOW, LLC.
URL: 		http://www.ikanow.com
Requires: 	tomcat6
BuildArch: 	noarch
Prefix: /mnt/opt
%description
infinit.e-logstash-installer.offline
###########################################################################

###########################################################################
# SCRIPTLETS, IN ORDER OF EXECUTION
###########################################################################
%prep
	# (create build files)
	zcat $RPM_SOURCE_DIR/infinit.e-logstash-installer-offline.tgz | tar -xvf -

###########################################################################
# 
###########################################################################
%post

###########################################################################
# FILE LISTS
###########################################################################
%files
	/mnt/opt/infinite-install/rpms/logstash-1.4.0-1_c82dc09.noarch.rpm
	/mnt/opt/infinite-install/rpms/logstash-contrib-1.4.0-1_b37bbca.noarch.rpm
	/mnt/opt/infinite-install/install_logstash.sh
