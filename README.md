Docker container for learning and testing Hadoop MapReduce in Single Node Cluster

# Getting started

1. build the container
```
docker build -t hadoop:0.1 .
```

2. start the container and run bash
```
docker run --name hadoop -p 127.0.0.1:9870:9870 -p 127.0.0.1:8088:8088 -p 127.0.0.1:19888:19888 -it hadoop:0.1 /bin/bash
```

3. start HDFS and YARN
```
sh start.sh
```

4. run sample MapReduce app

```
hdfs dfs -mkdir input
hdfs dfs -put etc/hadoop/*.xml input
hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.1.jar grep input output 'dfs[a-z.]+'
mkdir output
hdfs dfs -get output/* output
cat output/*
```

5. browse web interface for NameNode and ResourceManager
- NameNode: http://localhost:9870/
- ResourceManager: http://localhost:8088/
- HistoryServer: http://localhost:19888/

# Reference
https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/SingleCluster.html
