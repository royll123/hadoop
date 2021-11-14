FROM ubuntu:20.04

RUN apt-get update && apt-get install -y openjdk-8-jdk-headless wget ssh vim

RUN /etc/init.d/ssh start
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys

RUN ARCH=`uname -m` \
    && if [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ] ; then \
        wget https://dlcdn.apache.org/hadoop/common/hadoop-3.3.1/hadoop-3.3.1-aarch64.tar.gz && \
        tar -xzf hadoop-3.3.1-aarch64.tar.gz > /dev/null; \
       else \
        wget https://dlcdn.apache.org/hadoop/common/hadoop-3.3.1/hadoop-3.3.1.tar.gz && \
        tar -xzf hadoop-3.3.1.tar.gz > /dev/null; \
       fi 

WORKDIR hadoop-3.3.1
COPY ./hadoop/ etc/hadoop/
COPY start.sh .

RUN ARCH=`uname -m` \
    && if [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ] ; then \
        echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-arm64" >> etc/hadoop/hadoop-env.sh; \
       else \
        echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> etc/hadoop/hadoop-env.sh; \
       fi \
    && echo "export HDFS_NAMENODE_USER=root \n \
            export HDFS_DATANODE_USER=root \n \
            export HDFS_SECONDARYNAMENODE_USER=root \n \
            export YARN_RESOURCEMANAGER_USER=root \n \
            export YARN_NODEMANAGER_USER=root \n \
            export PATH=\${JAVA_HOME}/bin:\${PATH} \n \
            export HADOOP_CLASSPATH=\${JAVA_HOME}/lib/tools.jar " >> etc/hadoop/hadoop-env.sh

ENV PATH $PATH:/hadoop-3.3.1/bin

RUN apt-get install -y rsyslog

CMD ["sh", "start.sh"]
