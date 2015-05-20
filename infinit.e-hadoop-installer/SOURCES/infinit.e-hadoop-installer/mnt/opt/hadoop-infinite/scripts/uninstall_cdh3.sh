#!/bin/bash

# UNTESTED utility to uninstall CDH3 - eg prior to installing CDH5

#FIRST ENSURE YOU'VE SHUT THE CLUSTER DOWN 	
			
#RPMs:

yes | yum remove hadoop-0.20 hadoop-0.20-native hadoop-0.20-sbin hadoop-zookeeper hadoop-hive hadoop-hbase hadoop-pig hue* oozie-client

yes | yum remove cdh3-repository-1.0-1

#(this doesn't always work first time? can't do any harm to try again...)
yes | yum remove hue*

yes | yum remove 'cloudera-manager-*' || echo '(WARNING: failed to remove cloudera-manager-*)'

#Some files:

rm -Rf /etc/yum.repos.d/cloudera* /etc/cloudera-* /var/cache/yum/cloudera*

umount /var/run/cloudera-scm-agent/process || echo '(WARNING: failed to unmount /var/run/cloudera-scm-agent/process)' 

rm -Rf /usr/share/cmf /var/lib/cloudera* /var/cache/yum/cloudera* /var/log/cloudera* /var/run/cloudera*

rm -f /tmp/.scm_prepare_node.lock || echo '(WARNING: failed to remove lock file)'

rm -Rf /var/lib/flume-ng /var/lib/hadoop* /var/lib/hue /var/lib/navigator /var/lib/oozie /var/lib/solr /var/lib/sqoop* /var/lib/zookeeper
	
#Some more files:

rm -Rf /mnt/dfs /mnt/mapred /mnt/yarn /raidarray/dfs /raidarray/mapred /raidarray/yarn

# Remove some old repo stuff:

find /var/cache/yum -type d | grep cloudera- | xargs rm -rf

yum clean all
