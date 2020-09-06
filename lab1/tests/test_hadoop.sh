#!/bin/bash

echo "Create a new directory /kth on HDFS"
$HADOOP_HOME/bin/hdfs dfs -mkdir /kth

echo "Create a file, call it big, on your local filesystem and upload it to HDFS under /kth"
touch big
$HADOOP_HOME/bin/hdfs dfs -put big /kth

echo "View the content of /kth directory"
$HADOOP_HOME/bin/hdfs dfs -ls /kth

echo "Determine the size of file big on HDFS"
$HADOOP_HOME/bin/hdfs dfs -du -h /kth/big

echo "Print the first 5 lines of the file big to screen (the big file is empty, so you can add some lines of text to it before uploading it on the HDFS)"
$HADOOP_HOME/bin/hdfs dfs -cat /kth/big | head -n 5

echo "Make a copy of the file big on HDFS, and call it big hdfscopy"
$HADOOP_HOME/bin/hdfs dfs -cp /kth/big /kth/big_hdfscopy

echo "Copy the file big to the local filesystem and name it big localcopy"
$HADOOP_HOME/bin/hdfs dfs -get /kth/big big_localcopy

echo "Check the entire HDFS filesystem for inconsistencies/problems"
$HADOOP_HOME/bin/hdfs fsck /

echo "Delete the file big from HDFS"
$HADOOP_HOME/bin/hdfs dfs -rm /kth/big

echo "Delete the folder /kth from HDFS"
$HADOOP_HOME/bin/hdfs dfs -rm -r /kth
