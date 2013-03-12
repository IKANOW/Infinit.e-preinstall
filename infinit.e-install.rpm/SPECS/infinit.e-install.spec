###########################################################################
#
# Spec file for Infinit.e system configuration.
#
Summary: Infinit.e installation RPM
Name: infinit.e-raid-amazon
Version: INFINITE_VERSION
Release: online
License: None
Group: Infinit.e
BuildArch: noarch
Prefix: /mnt/opt
%description
Infinit.e installation RPM

###########################################################################
#
# SCRIPTLETS, IN ORDER OF EXECUTION
#

%prep
	# (create build files)
	# (nothing to do)
	zcat $RPM_SOURCE_DIR/infinit.e-install.tgz | tar -xvf -

%pre
	if [ $1 -eq 1 ]; then
#
# THIS IS AN INSTALL ONLY
#
		echo > /dev/null
	fi
	if [ $1 -eq 2 ]; then
#
# THIS IS AN UPGRADE NOT AN INSTALL
#
		echo > /dev/null
	fi
	
%install
#
# INSTALL *AND* UPGRADE
#	
	# (All files created from the tarball)

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
#
# INSTALL ONLY
#	
		echo > /dev/null
	fi
#
# INSTALL *AND* UPGRADE
#	
	echo "Now run /opt/infinite-install/install-infinite.sh to install Infinit.e"	
	
%preun
#
# UNINSTALL *AND* UPGRADE
#	
		
	if [ $1 -eq 0 ]; then
#
# THIS IS AN *UN"INSTALL NOT AN UPGRADE
#
		echo > /dev/null
	fi

%postun
	# (Nothing to do)

%posttrans
#
# FINAL STEP FOR INSTALLS AND UPGRADES
#

###########################################################################
#
# FILE LISTS
#

%files
%defattr(-,tomcat,tomcat)
%attr(-,root,root) /etc/yum.repos.d/ikanow.repo
%attr(-,root,root) /etc/yum.repos.d/ikanow-infinite.repo
%attr(755,tomcat,tomcat) /mnt/opt/infinite-install/install-infinite.sh
%dir /mnt/opt/infinite-install/example_configurations
/mnt/opt/infinite-install/example_configurations/infinite.configuration.properties.BASIC_SINGLE_SERVER