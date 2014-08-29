#!/bin/bash


falcon entity -type process -name log-load -delete
falcon entity -type feed -name logDataOut -delete
falcon entity -type feed -name logDataIn -delete
falcon entity -type cluster -name local-cluster -delete

hadoop fs -rm -r /user/hdp/logs
hadoop fs -rm -r /apps/apache_logs