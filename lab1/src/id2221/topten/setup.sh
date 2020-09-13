#!/bin/bash

# Saving data to HDFS

cd $APP_HOME/src/id2221/topten/

$HADOOP_HOME/bin/hdfs dfs -mkdir -p topten_input

$HADOOP_HOME/bin/hdfs dfs -put users.xml topten_input/users.xml

$HADOOP_HOME/bin/hdfs dfs -ls topten_input

# TODO: Create table in HBase
# $HBASE_HOME/bin/hbase shell
# create 'topten', 'info'

# Set environment

export HADOOP_CLASSPATH=$($HADOOP_HOME/bin/hadoop classpath)

export HBASE_CLASSPATH=$($HBASE_HOME/bin/hbase classpath)

export HADOOP_CLASSPATH=$HADOOP_CLASSPATH:$HBASE_CLASSPATH

# Compile code

cd $APP_HOME/src/id2221
mkdir topten_classes
javac -cp $HADOOP_CLASSPATH -d topten_classes topten/TopTen.java
jar -cvf topten.jar -C topten_classes/ .

# Run code

$HADOOP_HOME/bin/hadoop jar topten.jar id2221.topten.TopTen topten_input  # Output is HBase table
# $HADOOP_HOME/bin/hadoop jar topten.jar id2221.topten.TopTen topten_input topten_output

# Check output in HBase... >>
# $HBASE_HOME/bin/hbase shell
# scan 'topten'
