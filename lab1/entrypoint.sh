#!/bin/bash

# For some reason does not work if run as actual Docker entrypoint

echo "Starting Hadoop namenode"
$HADOOP_HOME/bin/hdfs --daemon start namenode
echo "Starting Hadoop datanode"
$HADOOP_HOME/bin/hdfs --daemon start datanode

echo "Starting HBase"
$HBASE_HOME/bin/start-hbase.sh
