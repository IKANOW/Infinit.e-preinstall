###########################################################################
# Spec file for infinit.e-platform.prerequisites.offline
###########################################################################
Summary: 	infinit.e-platform.prerequisites.offline
Name: 		infinit.e-platform.prerequisites.offline
Version: 	INFINITE_VERSION
Release: 	INFINITE_RELEASE
License: 	None
Group: 		Infinit.e
Vendor: 	IKANOW, LLC.
URL: 		http://www.ikanow.com
BuildArch: 	noarch
%description
infinit.e-platform.prerequisites.offline
###########################################################################

###########################################################################
# SCRIPTLETS, IN ORDER OF EXECUTION
###########################################################################
%prep
	# (create build files)
	zcat $RPM_SOURCE_DIR/infinit.e-platform.prerequisites-offline.tgz | tar -xvf -

###########################################################################
# 
###########################################################################
%post
	if [ $1 -eq 1 ]; then
		cp /mnt/opt/infinit.e-install/scripts/offline_install.sh /mnt/opt/infinit.e-install/install.sh	
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
%attr(-,root,root) /mnt/opt/infinit.e-install/scripts/offline_install.sh

###########################################################################
# yum repo files
###########################################################################
%attr(-,root,root) /mnt/opt/infinit.e-install/etc/yum.repos.d/10gen-mongodb.repo
%attr(-,root,root) /mnt/opt/infinit.e-install/etc/yum.repos.d/ikanow-infinite.repo
%attr(-,root,root) /mnt/opt/infinit.e-install/etc/yum.repos.d/infinite.repo

###########################################################################
# rpms dependencies
###########################################################################
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/alsa-lib-1.0.17-1.el5.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/antlr-2.7.6-6.jpp5.noarch.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/at-3.1.8-84.el5.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/atk-1.12.2-1.fc6.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/bc-1.06-21.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/bitstream-vera-fonts-1.10-7.noarch.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/cairo-1.2.4-5.el5.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/chkfontpath-1.10.1-1.1.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/cpio-2.6-23.el5_4.1.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/createrepo-0.4.11-3.el5.noarch.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/cups-libs-1.3.7-26.el5_6.1.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/ecj-3.3.1.1-3.jpp5.noarch.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/eclipse-ecj-3.2.1-19.el5.centos.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/elfutils-0.137-3.el5.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/elfutils-libs-0.137-3.el5.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/exim-4.63-10.el5.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/expat-1.95.8-8.3.el5_5.3.i386.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/expat-1.95.8-8.3.el5_5.3.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/fontconfig-2.4.1-7.el5.i386.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/fontconfig-2.4.1-7.el5.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/freetype-2.2.1-28.el5_7.2.i386.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/freetype-2.2.1-28.el5_7.2.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/gettext-0.17-1.el5.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/giflib-4.1.3-7.3.3.el5.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/gjdoc-0.7.7-12.el5.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/gtk2-2.10.4-21.el5_5.6.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/gtk2-2.10.4-21.el5_7.7.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/hicolor-icon-theme-0.9-2.1.noarch.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/jakarta-commons-collections-tomcat5-3.2-2jpp.3.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/jakarta-commons-daemon-1.0.1-7.jpp5.noarch.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/jakarta-commons-dbcp-tomcat5-1.2.2-2.jpp5.noarch.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/jakarta-commons-logging-1.1-8.jpp5.noarch.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/jakarta-commons-pool-tomcat5-1.3-11.jpp5.noarch.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/jakarta-taglibs-standard-1.1.2-7.jpp5.noarch.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/java-1.4.2-gcj-compat-1.4.2.0-40jpp.115.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/java-1.6.0-openjdk-1.6.0.0-1.23.1.9.10.el5_7.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/jpackage-utils-1.7.3-1jpp.2.el5.noarch.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/libart_lgpl-2.3.17-4.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/libfontenc-1.0.2-2.2.el5.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/libFS-1.0.0-3.1.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/libgcj-4.1.2-51.el5.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/libgomp-4.4.4-13.el5.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/libICE-1.0.1-2.1.i386.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/libICE-1.0.1-2.1.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/libidn-0.6.5-1.1.i386.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/libidn-0.6.5-1.1.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/libjpeg-6b-37.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/libpng-1.2.10-7.1.el5_7.5.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/libSM-1.0.1-3.1.i386.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/libSM-1.0.1-3.1.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/libtiff-3.8.2-7.el5_6.7.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/libX11-1.0.3-11.el5_7.1.i386.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/libX11-1.0.3-11.el5_7.1.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/libXau-1.0.1-3.1.i386.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/libXau-1.0.1-3.1.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/libXcursor-1.1.7-1.1.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/libXdmcp-1.0.1-2.1.i386.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/libXdmcp-1.0.1-2.1.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/libXext-1.0.1-2.1.i386.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/libXext-1.0.1-2.1.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/libXfixes-4.0.1-2.1.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/libXfont-1.2.2-1.0.4.el5_7.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/libXft-2.1.10-1.1.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/libXi-1.0.1-4.el5_4.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/libXinerama-1.0.1-2.1.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/libxml2-python-2.6.26-2.1.12.el5_7.1.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/libXmu-1.0.2-5.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/libXrandr-1.1.1-3.3.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/libXrender-0.9.1-3.1.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/libXt-1.0.2-3.2.el5.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/libXtst-1.0.1-3.1.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/m4-1.4.5-3.el5.1.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/make-3.81-3.el5.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/mysql-5.0.77-4.el5_6.6.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/pango-1.14.9-8.el5_7.3.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/pango-1.14.9-8.el5.centos.3.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/patch-2.5.4-31.el5.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/pax-3.4-2.el5_4.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/perl-DBI-1.52-2.el5.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/popt-1.10.2.3-22.el5_7.2.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/postgresql-libs-8.1.23-1.el5_7.3.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/redhat-lsb-4.0-2.1.4.el5.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/rpm-4.4.2.3-22.el5_7.2.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/rpm-libs-4.4.2.3-22.el5_7.2.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/rpm-python-4.4.2.3-22.el5_7.2.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/time-1.7-27.2.2.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/tomcat5-jsp-2.0-api-5.5.27-7.jpp5.noarch.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/tomcat5-servlet-2.4-api-5.5.27-7.jpp5.noarch.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/tomcat6-6.0.29-1.jpp5.noarch.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/tomcat6-admin-webapps-6.0.29-1.jpp5.noarch.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/tomcat6-el-1.0-api-6.0.29-1.jpp5.noarch.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/tomcat6-jsp-2.1-api-6.0.29-1.jpp5.noarch.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/tomcat6-lib-6.0.29-1.jpp5.noarch.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/tomcat6-servlet-2.5-api-6.0.29-1.jpp5.noarch.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/tomcat6-webapps-6.0.29-1.jpp5.noarch.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/ttmkfdir-3.0.9-23.el5.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/tzdata-java-2011l-4.el5.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/unzip-5.52-3.el5.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/xalan-j2-2.7.0-10.jpp5.noarch.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/xorg-x11-filesystem-7.1-2.fc6.noarch.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/xorg-x11-fonts-base-7.1-2.1.el5.noarch.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/xorg-x11-font-utils-7.1-3.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/xorg-x11-xauth-1.0.1-2.1.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/zip-2.31-2.el5.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/xorg-x11-xfs-1.0.2-5.el5_6.1.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/cyrus-sasl-gssapi-2.1.22-5.el5_4.3.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/libxslt-1.1.17-2.el5_2.2.x86_64.rpm

###########################################################################
# yum repo files for dependencies
###########################################################################
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/repodata/filelists.xml.gz
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/repodata/other.xml.gz
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/repodata/primary.xml.gz
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/dependencies/repodata/repomd.xml

###########################################################################
# rpms to install
###########################################################################
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/curl-7.15.5-9.el5_7.4.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/elasticsearch-0.18.7-1.noarch.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/jpackage-utils-5.0.0-2.jpp5.noarch.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/jpackage-utils-compat-el5-0.0.1-1.noarch.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/jre-6u30-linux-x64-rpm.bin
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/jdk-6u30-linux-x64.bin
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/mongo-10gen-2.0.2-mongodb_1.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/mongo-10gen-server-2.0.2-mongodb_1.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/rpm-build-4.4.2.3-22.el5_7.2.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/s3cmd-1.0.0-4.1.i386.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/s3cmd-1.0.0-4.1.x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/splunk-4.2.4-110225-linux-2.6-x86_64.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/tomcat6-6.0.29-1.jpp5.noarch.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/tomcat6-admin-webapps-6.0.29-1.jpp5.noarch.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/tomcat6-webapps-6.0.29-1.jpp5.noarch.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/yum-downloadonly-1.1.16-16.el5.centos.noarch.rpm
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/yum-priorities-1.1.16-16.el5.centos.noarch.rpm

###########################################################################
# s3cmd gpgkey
###########################################################################
%attr(-,root,root) /mnt/opt/infinit.e-install/rpms/repomd.xml.key

###########################################################################
# Data files
###########################################################################
%attr(-,root,root) /mnt/opt/infinit.e-install/data/feature/geo.bson.tar.gz
