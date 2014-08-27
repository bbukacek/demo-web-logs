#!/bin/bash

#Create Hive Table
su hdp -c 'hive -f hive/apache_logs.hql'

#Application and Falcon Setup
su hdfs -c 'hadoop fs -mkdir -p /apps/falcon/lib'
su hdfs -c 'hadoop fs -mkdir -p /apps/falcon/pig'
su hdfs -c 'hadoop fs -copyFromLocal lib/*.jar /apps/falcon/lib'
su hdfs -c 'hadoop fs -copyFromLocal /usr/lib/hbase/lib/*.jar /apps/falcon/lib'
su hdfs -c 'hadoop fs -copyFromLocal pig/*.pig /apps/falcon/pig'

su hdp -c 'falcon entity -type cluster -submit -name local-cluster -file falcon/local_cluster.xml'
su hdp -c 'falcon entity -type feed -submit -name logDataIn -file falcon/log_data_in-feed.xml'
su hdp -c 'falcon entity -type feed -submit -name logDataOut -file falcon/log_data_out-feed.xml'
su hdp -c 'falcon entity -type process -submit -name log-load -file falcon/process.xml'
su hdp -c 'faclon entity -type process -name log-load -schedule'

#Start Flume
su hdp -c '/usr/lib/flume/bin/flume-ng agent -n agent -c conf -f /home/hdp/demo-web-logs/flume/flume-onaam.conf -Dflume.root.logger=INFO,console &'

#Compile and Run Application
mvn compile
cp src/main/resources/*.properties target/classes
mvn compile exect:java -exec.classpathScope=compile -Dexec.mainClass=com.hortonworks.demo.dataloader.DataLoader