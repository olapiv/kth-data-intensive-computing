#!/bin/bash

# For some reason does not work if run as actual Docker entrypoint

echo "Starting Hadoop namenode"
$HADOOP_HOME/bin/hdfs --daemon start namenode
echo "Starting Hadoop datanode"
$HADOOP_HOME/bin/hdfs --daemon start datanode

echo "Starting the ssh server"
/etc/init.d/ssh start

echo "Starting HBase"
yes | $HBASE_HOME/bin/start-hbase.sh

echo "Starting the Jupyter Notebook server"
jupyter notebook --ip=0.0.0.0 --allow-root --no-browser -y
