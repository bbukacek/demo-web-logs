#!/bin/bash

#Create Hive Table
hive -f hive/apache_logs.hql

#Application and Falcon Setup
hadoop fs -mkdir -p /apps/apache_logs/lib
hadoop fs -mkdir -p /apps/apache_logs/pig
hadoop fs -copyFromLocal lib/*.jar /apps/apache_logs/lib
hadoop fs -copyFromLocal /usr/lib/hbase/lib/*.jar /apps/apache_logs/lib
hadoop fs -copyFromLocal pig/*.pig /apps/apache_logs/pig

falcon entity -type cluster -submit -name demo-cluster -file falcon/cluster.xml
falcon entity -type feed -submit -name logDataIn -file falcon/log_data_in-feed.xml
falcon entity -type feed -submit -name logDataOut -file falcon/log_data_out-feed.xml
falcon entity -type process -submit -name log-load -file falcon/process.xml
faclon entity -type process -name log-load -schedule

mkdir -p ~/demo-output/flume

#Start Flume
#/usr/lib/flume/bin/flume-ng agent -n agent -c conf -f flume/flume-onaam.conf

#Compile and Run Application
mvn compile
cp src/main/resources/*.properties target/classes
mvn compile exect:java -exec.classpathScope=compile -Dexec.mainClass=com.hortonworks.demo.dataloader.DataLoader