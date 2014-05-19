#!/bin/bash
echo
echo "*******************************************"
echo
yum -y --nogpgcheck install infinit.e-platform.prerequisites.online
                                                
echo
echo "*******************************************"
echo
cd /opt/infinite-install/
sh install.sh apinode_latest --slow

echo
echo "*******************************************"
echo
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

echo
echo "*******************************************"
echo
yum -y --nogpgcheck install infinit.e-hadoop-installer.online
yum -y --nogpgcheck install infinit.e-config
yum -y --nogpgcheck install infinit.e-index-engine
yum -y --nogpgcheck install infinit.e-db-instance
yum -y --nogpgcheck install infinit.e-processing-engine
yum -y --nogpgcheck install infinit.e-interface-engine
yum -y --nogpgcheck install infinit.e-record-engine && sh /opt/logstash-infinite/scripts/logstash_online_install.sh full

echo
echo "*******************************************"
echo
echo "Note standalone Hadoop not installed, to do so run /opt/hadoop-infinite/install.sh (not necessary for single node installations)"

echo
echo "*******************************************"
echo
echo "Install complete - preparing system..... (will take a few minutes)";
chown -R tomcat.tomcat /opt/infinite-install
for i in 1 2 3 4; do
	sleep 60
	echo "(still preparing)"
done

while [ true ]; do
	echo
	echo "*******************************************"
	echo
	read -p "Finally, would you like to load some sample data into the tool? (y/n)" yn
	if [ "$yn" = "y" ]; then
		cd /opt/infinite-install/
		curl -o 'preload_data.tgz' 'https://ikanow.jira.com/wiki/download/attachments/28377207/preload_data.tgz?api=v2'
		curl -o 'preload_data_wits.tgz' 'https://ikanow.jira.com/wiki/download/attachments/28377207/preload_data_wits.tgz?api=v2'
		curl -o 'preload_data_enron.tgz' 'https://ikanow.jira.com/wiki/download/attachments/28377207/preload_data_enron.tgz?api=v2'
		curl -o 'preload_data_netflow.tgz' 'https://ikanow.jira.com/wiki/download/attachments/28377207/preload_data_netflow.tgz?api=v2'
		
		if [ ! -f preload_data.tgz ]; then
			echo
			echo "*******************************************"
			echo
			echo "Failed to load data for some reason, aborting"
			break;
		fi
		
		if [ "$yc" = "c" ]; then
			mongo social --eval 'db.person.drop()'
			mongo social --eval 'db.community.drop()'
		fi
		mongo gui --eval 'db.setup.drop()'
		
		tar xzvf preload_data.tgz
		mongorestore saved/
		rm -rf saved/
		
		if [ "$yc" = "y" ]; then
			mongo social --eval 'db.community.update({"isSystemCommunity":false,"isPersonalCommunity":false},{$set:{members:[],numberOfMembers:0}},false,true)'
		fi		
		
		/etc/init.d/infinite-px-engine stop
		cd /opt/infinite-home/bin
		sh infinite_indexer.sh --doc --verify --query '{}'
		sh infinite_indexer.sh --assoc --rebuild --query '{}'
		sh infinite_indexer.sh --entity --rebuild --query '{}'
		/etc/init.d/infinite-px-engine start
				
		mkdir -p /mnt/infinite_data/netflow
		if [ -f /opt/infinite-install/preload_data_netflow.tgz ]; then
			cd /mnt/infinite_data/netflow
			tar xzvf /opt/infinite-install/preload_data_netflow.tgz
		fi		
		mkdir -p /mnt/infinite_data/enron
		if [ -f /opt/infinite-install/preload_data_enron.tgz ]; then
			cd /mnt/infinite_data/enron
			tar xzvf /opt/infinite-install/preload_data_enron.tgz
		fi
		mkdir -p /mnt/infinite_data/wits
		if [ -f /opt/infinite-install/preload_data_wits.tgz ]; then
			cd /
			tar xzvf /opt/infinite-install/preload_data_wits.tgz
		fi		
		chown -R tomcat.tomcat /mnt/infinite_data
		
		if [ "$yc" = "y" ]; then
			echo
			echo "*******************************************"
			echo
			echo "You will need to add your users to the newly created communities from the '/manager' webapp"
		fi	
		break;
	elif [ "$yn" = "n" ]; then
		break;
	else
		echo '"y" or "n" please, lower case.'
	fi	
	cd /opt/infinite-install
done
echo
echo "*******************************************"
echo
echo "All done!"
