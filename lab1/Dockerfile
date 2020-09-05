FROM ubuntu:18.04

################
##### JVM ######
################

RUN yes | apt-get install curl
RUN apt-get update
RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata wget
RUN apt-get update
RUN yes | apt-get install software-properties-common
RUN apt-get update
RUN yes | add-apt-repository ppa:openjdk-r/ppa
RUN apt-get update
RUN yes | apt-get install openjdk-8-jdk-headless

#############################
##### Hadoop MapReduce ######
#############################

# ~
WORKDIR / 
RUN wget https://archive.apache.org/dist/hadoop/common/hadoop-3.1.2/hadoop-3.1.2.tar.gz tar -xvf hadoop-3.1.2.tar.gz

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV HADOOP_HOME=/home/dataintensive/hadoop-3.1.2
ENV HADOOP_CONFIG=$HADOOP_HOME/etc/hadoop
ENV PATH=$JAVA_HOME/bin:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$PATH

ENV NAMENODE_PATH=/home/namenode
ENV DATANODE_PATH=/home/datanode
RUN mkdir -p $NAMENODE_PATH
RUN mkdir -p $DATANODE_PATH

WORKDIR $HADOOP_HOME

RUN echo "\
    <configuration>\
        <property>\
            <name>fs.defaultFS</name>\
            <value>hdfs://127.0.0.1:9000</value>\
            <description>NameNode URI</description>\
        </property>\
    </configuration>" >> $HADOOP CONFIG/core-site.xml

RUN sed -i "s|PATH_TO_NAMENODE|$NAMENODE_PATH |g" $HADOOP CONFIG/hdfs-site.xml
RUN sed -i "s|PATH_TO_DATANODE|$DATANODE_PATH |g" $HADOOP CONFIG/hdfs-site.xml

RUN $HADOOP_HOME/bin/hdfs namenode -format

EXPOSE 9864
EXPOSE 8888
EXPOSE 9870
EXPOSE 4040

ENTRYPOINT $HADOOP_HOME/bin/hdfs --daemon start namenode && $HADOOP_HOME/bin/hdfs --daemon start datanode
