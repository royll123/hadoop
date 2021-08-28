FROM ubuntu:18.04

RUN apt-get update && apt-get install -y openjdk-8-jdk-headless wget ssh vim
RUN wget https://dlcdn.apache.org/hadoop/common/hadoop-3.3.1/hadoop-3.3.1.tar.gz
RUN tar -xzf hadoop-3.3.1.tar.gz > /dev/null

RUN /etc/init.d/ssh start
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys

WORKDIR hadoop-3.3.1
COPY ./hadoop/ etc/hadoop/
COPY start.sh .

RUN echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> etc/hadoop/hadoop-env.sh \
    && echo "export HDFS_NAMENODE_USER=root" >> etc/hadoop/hadoop-env.sh \
    && echo "export HDFS_DATANODE_USER=root" >> etc/hadoop/hadoop-env.sh \
    && echo "HDFS_SECONDARYNAMENODE_USER=root" >> etc/hadoop/hadoop-env.sh \
    && echo "export YARN_RESOURCEMANAGER_USER=root" >> etc/hadoop/hadoop-env.sh \
    && echo "export YARN_NODEMANAGER_USER=root" >> etc/hadoop/hadoop-env.sh 

ENV PATH $PATH:/hadoop-3.3.1/bin

CMD ["sh", "start.sh"]
