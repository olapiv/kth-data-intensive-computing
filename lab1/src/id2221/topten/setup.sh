#!/bin/bash

# Run this as:
# source $APP_HOME/src/id2221/topten/setup.sh

echo "Saving data to HDFS"
cd $APP_HOME/src/id2221/topten/
$HADOOP_HOME/bin/hdfs dfs -mkdir -p topten_input
$HADOOP_HOME/bin/hdfs dfs -put users.xml topten_input/users.xml
$HADOOP_HOME/bin/hdfs dfs -ls topten_input

echo "Setup environment"
export HADOOP_CLASSPATH=$($HADOOP_HOME/bin/hadoop classpath)
export HBASE_CLASSPATH=$($HBASE_HOME/bin/hbase classpath)
export HADOOP_CLASSPATH=$HADOOP_CLASSPATH:$HBASE_CLASSPATH

echo "Compile code"
cd $APP_HOME/src/id2221
mkdir -p topten_classes
javac -cp $HADOOP_CLASSPATH -d topten_classes topten/TopTen.java
jar -cvf topten.jar -C topten_classes/ .

# Create table in HBase:
# $HBASE_HOME/bin/hbase shell
#   >> create 'topten', 'info'

# Run code:
# $HADOOP_HOME/bin/hadoop jar topten.jar id2221.topten.TopTen topten_input  # Output is HBase table

# Check output in HBase:
# $HBASE_HOME/bin/hbase shell
#   >> scan 'topten'
