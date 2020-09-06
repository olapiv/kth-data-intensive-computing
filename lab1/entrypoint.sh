#!/bin/bash

# For some reason does not work if run as actual Docker entrypoint

echo "Starting Hadoop namenode"
$HADOOP_HOME/bin/hdfs --daemon start namenode
echo "Starting Hadoop datanode"
$HADOOP_HOME/bin/hdfs --daemon start datanode

# echo "Generate ssh key without password"
# ssh-keygen -t rsa -P ""

# echo "Copy id_rsa.pub to authorized-keys"
# cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys

echo "Starting the ssh server"
/etc/init.d/ssh start

echo "Starting HBase"
yes | $HBASE_HOME/bin/start-hbase.sh
