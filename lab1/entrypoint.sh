#!/bin/bash

echo "Starting Hadoop"
$HADOOP_HOME/bin/hdfs --daemon start namenode
$HADOOP_HOME/bin/hdfs --daemon start datanode

echo "Starting HBase"
$HBASE_HOME/bin/start-hbase.sh
