#!/bin/bash

# TODO: Test these commands

echo "Viewing created directory"
$HADOOP_HOME/bin/hdfs dfs -ls /hbase

echo "Start and stop a backup HBase Master server (OPTIONAL ON PRODUCTION ENVIRONMENTS)"
$HBASE_HOME/bin/local-master-backup.sh start 2 3 5

echo "Kill a backup master without killing the entire cluster"
cat /tmp/hbase-USER-2-master.pid | xargs kill -9

echo "Start and stop additional RegionServers (OPTIONAL ON PRODUCTION ENVIRONMENTS)"
$HBASE_HOME/bin/local-regionservers.sh start 2 3 4 5

echo "Stop a RegionServer manually"
$HBASE_HOME/bin/local-regionservers.sh stop 3
