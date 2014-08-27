#!/bin/bash


su hdp -c 'falcon entity -type process -name log-load -delete'
su hdp -c 'falcon entity -type feed -name logDataOut -delete'
su hdp -c 'falcon entity -type feed -name logDataIn -delete'
su hdp -c 'falcon entity -type cluster -name local-cluster -delete'


su hdfs -c 'hadoop fs -rm -r /user/hdp/logs'
su hdfs -c 'hadoop fs -rm -r /apps/falcon'