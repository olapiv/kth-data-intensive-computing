FROM ubuntu:18.04

ENV APP_HOME=/home/dataintensive

################
##### JVM ######
################

RUN apt-get update
RUN yes | apt-get install curl
RUN apt-get update
RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata wget
RUN apt-get update
RUN yes | apt-get install software-properties-common
RUN apt-get update
RUN yes | add-apt-repository ppa:openjdk-r/ppa
RUN apt-get update
RUN yes | apt-get install openjdk-8-jdk-headless
RUN apt-get update

#############################
##### Hadoop MapReduce ######
#############################

WORKDIR $APP_HOME
RUN wget https://archive.apache.org/dist/hadoop/common/hadoop-3.1.2/hadoop-3.1.2.tar.gz
RUN tar -xvf hadoop-3.1.2.tar.gz

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV HADOOP_HOME=$APP_HOME/hadoop-3.1.2
ENV HADOOP_CONFIG=$HADOOP_HOME/etc/hadoop
ENV PATH=$JAVA_HOME/bin:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$PATH

RUN sed "s|export JAVA_HOME=.*|export JAVA_HOME='/usr/lib/jvm/java-8-openjdk-amd64'|g" $HADOOP_CONFIG/hadoop-env.sh

ENV NAMENODE_PATH=$APP_HOME/namenode
ENV DATANODE_PATH=$APP_HOME/datanode
RUN mkdir -p $NAMENODE_PATH
RUN mkdir -p $DATANODE_PATH

# WORKDIR $HADOOP_HOME

# RUN echo "\
#     <configuration>\
#         <property>\
#             <name>fs.defaultFS</name>\
#             <value>hdfs://127.0.0.1:9000</value>\
#             <description>NameNode URI</description>\
#         </property>\
#     </configuration>" >> $HADOOP_CONFIG/core-site.xml

RUN apt-get install -y xmlstarlet

RUN bash -c 'cat $HADOOP_CONFIG/core-site.xml'

RUN xmlstarlet ed -s '//configuration'  -t elem -n 'property'  \
	-s '//configuration/property'  -t elem -n 'name' -v 'fs.defaultFS' \
	-s '//configuration/property'  -t elem -n 'value' -v 'hdfs://127.0.0.1:9000' \
	-s '//configuration/property'  -t elem -n 'description' -v 'NameNode URI' $HADOOP_CONFIG/core-site.xml

RUN bash -c 'cat $HADOOP_CONFIG/core-site.xml'

RUN sed -i "s|PATH_TO_NAMENODE|$NAMENODE_PATH |g" $HADOOP_CONFIG/hdfs-site.xml
RUN sed -i "s|PATH_TO_DATANODE|$DATANODE_PATH |g" $HADOOP_CONFIG/hdfs-site.xml

RUN $HADOOP_HOME/bin/hdfs namenode -format

##################
##### HBase ######
##################

RUN yes | apt-get install openssh-server
RUN apt-get update

RUN wget https://archive.apache.org/dist/hbase/1.4.10/hbase-1.4.10-bin.tar.gz 
RUN tar -xvf hbase-1.4.10-bin.tar.gz

ENV HBASE_HOME=$APP_HOME/hbase
ENV HBASE_CONF=$HBASE_HOME/conf
ENV PATH=$HBASE_HOME/bin:$PATH

# TODO: Edit JAVA_HOME in $HBASE_CONF/hbase-env.sh. >>export JAVA_HOME="/path/to/the/java/folder"

ENV ZOOKEEPER_PATH=$HBASE_HOME/zookeeper
RUN mkdir -p $ZOOKEEPER_PATH

RUN sed -i "s|PATH_TO_ZOOKEEPER|$ZOOKEEPER_PATH |g" $HBASE_CONF/hbase-site.xml

ADD ./src $APP_HOME/src

# Hadoop: 
# ENTRYPOINT $HADOOP_HOME/bin/hdfs --daemon start namenode && $HADOOP_HOME/bin/hdfs --daemon start datanode

# HBase:
# ENTRYPOINT $HBASE_HOME/bin/start-hbase.sh

EXPOSE 9864
EXPOSE 8888
EXPOSE 9870
EXPOSE 4040
