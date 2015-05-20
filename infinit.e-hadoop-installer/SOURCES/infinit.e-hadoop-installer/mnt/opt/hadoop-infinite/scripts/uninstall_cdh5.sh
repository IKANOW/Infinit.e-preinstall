#!/bin/bash

# UNTESTED utility to uninstall CDH5 - parcel mode (in case something goes wrong)

#FIRST ENSURE YOU'VE SHUT THE CLUSTER DOWN 	
			
if [ -f /usr/share/cmf/uninstall-cloudera-manager.sh ]; then
	/usr/share/cmf/uninstall-cloudera-manager.sh
fi

service cloudera-scm-agent hard_stop || echo '(WARNING: hard stop failed)'

yes | yum remove 'cloudera-manager-*' || echo '(WARNING: failed to remove cloudera-manager-*)'

for u in cloudera-scm flume hadoop hdfs hbase hive httpfs hue impala llama mapred oozie solr spark sqoop sqoop2 yarn zookeeper; do kill $(ps -u $u -o pid=) || echo "(WARNING: Failed to remove $u)"; done
	
umount /var/run/cloudera-scm-agent/process || echo '(WARNING: failed to unmount /var/run/cloudera-scm-agent/process)' 

rm -Rf /etc/yum.repos.d/cloudera* /etc/cloudera-* /var/cache/yum/cloudera*
			
rm -Rf /usr/share/cmf /var/lib/cloudera* /var/cache/yum/cloudera* /var/log/cloudera* /var/run/cloudera*

rm -f /tmp/.scm_prepare_node.lock || echo '(WARNING: failed to remove lock file)'

rm -Rf /var/lib/flume-ng /var/lib/hadoop* /var/lib/hue /var/lib/navigator /var/lib/oozie /var/lib/solr /var/lib/sqoop* /var/lib/zookeeper
	
rm -Rf /mnt/dfs /mnt/mapred /mnt/yarn /raidarray/dfs /raidarray/mapred /raidarray/yarn

# Update the symlink:
rm -f /opt/hadoop-infinite/lib
ln -sf /opt/hadoop-infinite/standalone_lib /opt/hadoop-infinite/lib
