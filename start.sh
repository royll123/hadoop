
/etc/init.d/ssh start

bin/hdfs namenode -format
sbin/start-dfs.sh
bin/hdfs dfs -mkdir /user
bin/hdfs dfs -mkdir /user/root
sbin/start-yarn.sh

mapred --daemon start historyserver

tail -f /dev/null
