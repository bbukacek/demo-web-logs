DROP TABLE IF EXISTS DEMO.APACHE_LOGS;

CREATE DATABASE IF NOT EXISTS DEMO;

USE DEMO;

CREATE EXTERNAL TABLE IF NOT EXISTS APACHE_LOGS(
	remoteaddr string, 
	remotelogname string, 
	user string, 
	time string, 
	request string, 
	status string, 
	bytes_string string, 
	referrer string, 
	browser string,
	month string,
	year string) 
PARTITIONED BY (date string) STORED AS ORC 
LOCATION '/user/hdp/logs';