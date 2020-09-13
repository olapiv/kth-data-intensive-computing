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

RUN sed --in-place "s|export JAVA_HOME=.*|export JAVA_HOME=$JAVA_HOME|g" $HADOOP_CONFIG/hadoop-env.sh

ENV NAMENODE_PATH=$APP_HOME/namenode
ENV DATANODE_PATH=$APP_HOME/datanode
RUN mkdir -p $NAMENODE_PATH
RUN mkdir -p $DATANODE_PATH

ADD core-site.xml $HADOOP_CONFIG

# TODO: Output: "<value>file:///home/dataintensive/namenode </value>"; Maybe remove one dash
ADD hdfs-site.xml $HADOOP_CONFIG
RUN sed --in-place "s|PATH_TO_NAMENODE|$NAMENODE_PATH|g" $HADOOP_CONFIG/hdfs-site.xml
RUN sed --in-place "s|PATH_TO_DATANODE|$DATANODE_PATH|g" $HADOOP_CONFIG/hdfs-site.xml

RUN $HADOOP_HOME/bin/hdfs namenode -format

##################
##### HBase ######
##################

RUN yes | apt-get install openssh-server
RUN apt-get update

RUN wget https://archive.apache.org/dist/hbase/1.4.10/hbase-1.4.10-bin.tar.gz 
RUN tar -xvf hbase-1.4.10-bin.tar.gz

ENV HBASE_HOME=$APP_HOME/hbase-1.4.10
ENV HBASE_CONF=$HBASE_HOME/conf
ENV PATH=$HBASE_HOME/bin:$PATH

RUN sed --in-place "s|# export JAVA_HOME=.*|export JAVA_HOME=$JAVA_HOME|g" $HBASE_CONF/hbase-env.sh

ENV ZOOKEEPER_PATH=$HBASE_HOME/zookeeper
RUN mkdir -p $ZOOKEEPER_PATH

ADD hbase-site.xml $HBASE_CONF
RUN sed --in-place "s|PATH_TO_ZOOKEEPER|$ZOOKEEPER_PATH|g" $HBASE_CONF/hbase-site.xml

#########################
##### Apache Spark ######
#########################
RUN wget https://archive.apache.org/dist/spark/spark-2.4.3/spark-2.4.3-bin-hadoop2.7.tgz 
RUN tar -xvf spark-2.4.3-bin-hadoop2.7.tgz
ENV SPARK_HOME=$APP_HOME/spark-2.4.3-bin-hadoop2.7
ENV PATH=$SPARK_HOME/bin:$PATH

################
##### SBT ######
################
RUN echo "deb https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823 
RUN apt-get update
RUN yes | apt-get install sbt

#############################
##### Jupyter Notebook ######
#############################
RUN yes | apt install python3-pip
RUN pip3 install jupyter
ENV PIP_LIBS_BINS="/home/dataintensive/.local/bin" 
ENV PATH=$PIP_LIBS_BINS:$PATH

#########################
##### Apache Toree ######
#########################
RUN pip3 install --upgrade toree
RUN jupyter toree install --user --python_exec=’python3’ --spark_home=$SPARK_HOME --spark_opts=’--master=local[*]’

# Generate ssh key without password
RUN mkdir -p $HOME/.ssh
RUN ssh-keygen -t rsa -P "" -f $HOME/.ssh/id_rsa

# Copy id_rsa.pub to authorized-keys
RUN mkdir -p $HOME/.ssh
RUN cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys

# ADD ./src $APP_HOME/src
ADD ./tests $APP_HOME/tests
ADD ./entrypoint.sh $APP_HOME

RUN chmod -R +x $APP_HOME/tests
RUN chmod +x $APP_HOME/entrypoint.sh

EXPOSE 9864
EXPOSE 8888
EXPOSE 9870
EXPOSE 4040

# ENTRYPOINT $APP_HOME/entrypoint.sh
