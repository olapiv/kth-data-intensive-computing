#!/bin/bash

$HADOOP_HOME/bin/hdfs dfs -ls /hbase
$HBASE_HOME/bin/local-master-backup.sh start 2 3 5
cat /tmp/hbase-USER-2-master.pid | xargs kill -9
$HBASE_HOME/bin/local-regionservers.sh start 2 3 4 5
$HBASE_HOME/bin/local-regionservers.sh stop 3
$HBASE_HOME/bin/hbase shell
