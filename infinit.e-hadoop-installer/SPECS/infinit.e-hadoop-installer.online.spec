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
Requires: 	tomcat6
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
	
	if [ -d /raidarray ]; then
		mkdir /raidarray/dfs
		mkdir /raidarray/mapred
		ln -sf /raidarray/dfs /mnt/dfs
		ln -sf /raidarray/mapred /mnt/mapred
		#(can't set any permissions yet)
	fi
	#Fix for old mongo jar left in Hadoop folder:
	rm -f /usr/lib/hadoop/lib/mongo-2.7.2.jar
	
	#Ensure /opt/hadoop-infinite/lib points to the right place
	rm -f /opt/hadoop-infinite/lib
	#TODO: for now just always point to standalone lib
#	if [ -d /opt/cloudera/parcels/CDH/lib/hadoop/client-0.20 ]; then
#		ln -sf /opt/cloudera/parcels/CDH/lib/hadoop/client-0.20/ /opt/hadoop-infinite/lib
#	else  
#		ln -sf /opt/hadoop-infinite/standalone_lib /opt/hadoop-infinite/lib
#	fi
	ln -sf /opt/hadoop-infinite/standalone_lib /opt/hadoop-infinite/lib

###########################################################################
# FILE LISTS
###########################################################################
%files
%define _unpackaged_files_terminate_build 0
%define _binaries_in_noarch_packages_terminate_build 0
%defattr(-,tomcat,tomcat)
%dir /mnt/opt/hadoop-infinite/
%dir /mnt/opt/hadoop-infinite/mapreduce/
%dir /mnt/opt/hadoop-infinite/jars/

###########################################################################
# Cloudera-manager installation application
###########################################################################
%attr(755,tomcat,tomcat) /mnt/opt/hadoop-infinite/cloudera-manager-installer.bin

###########################################################################
# jars
###########################################################################

%dir /mnt/opt/hadoop-infinite/standalone_lib/
/mnt/opt/hadoop-infinite/standalone_lib/avro.jar
/mnt/opt/hadoop-infinite/standalone_lib/commons-configuration-1.6.jar
/mnt/opt/hadoop-infinite/standalone_lib/hadoop-annotations-2.5.0-cdh5.3.1.jar
/mnt/opt/hadoop-infinite/standalone_lib/hadoop-auth-2.5.0-cdh5.3.1.jar
/mnt/opt/hadoop-infinite/standalone_lib/hadoop-hdfs-2.5.0-cdh5.3.1.jar
/mnt/opt/hadoop-infinite/standalone_lib/protobuf-java-2.5.0.jar

###########################################################################
# Install scripts
###########################################################################
%attr(755,tomcat,tomcat) /mnt/opt/hadoop-infinite/scripts/online_install.sh
%attr(755,tomcat,tomcat) /mnt/opt/hadoop-infinite/scripts/install_fuse.sh
%attr(755,tomcat,tomcat) /mnt/opt/hadoop-infinite/scripts/uninstall_cdh3.sh
%attr(755,tomcat,tomcat) /mnt/opt/hadoop-infinite/scripts/uninstall_cdh5.sh

###########################################################################
# Maintenance scripts
###########################################################################
%attr(-,root,root) /etc/cron.d/infinite-hadoop