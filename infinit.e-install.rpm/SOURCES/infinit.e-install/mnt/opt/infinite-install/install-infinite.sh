#!/bin/bash
yum -y --nogpgcheck install infinit.e-platform.prerequisites.online
                                                
cd /opt/infinite-install/
sh install.sh apinode --slow

echo 'Now go to /opt/infinite-install/config and edit infinite.configuration.properties, for more details see: https://ikanow.jira.com/wiki/pages/viewpage.action?pageId=8519753'
while [ true ]; do
	read -p 'Press "y" to indicate that you have completed the configuration, or "c" to use the example install file (to get up and running quickly)' yc
	if [ "$yc" = "y" ]; then
		if [ -f "/opt/infinite-install/config/infinite.configuration.properties" ]; then
			break;
		else
			echo "Untrue! /opt/infinite-install/config/infinite.configuration.properties does not exist..."
		fi
	elif [ "$yc" = "c" ]; then
		cp /opt/infinite-install/example_configurations/infinite.configuration.properties.BASIC_SINGLE_SERVER /opt/infinite-install/config/infinite.configuration.properties
		break;
	else
		echo '"y" or "c" please, lower case.'
	fi	
done

yum -y --nogpgcheck install infinit.e-hadoop-installer.online
yum -y --nogpgcheck install infinit.e-config
yum -y --nogpgcheck install infinit.e-index-engine
yum -y --nogpgcheck install infinit.e-db-instance
yum -y --nogpgcheck install infinit.e-processing-engine
yum -y --nogpgcheck install infinit.e-interface-engine

echo "Note standalone Hadoop not installed, to do so run /opt/hadoop-infinite/install.sh (not necessary for single node installations)"