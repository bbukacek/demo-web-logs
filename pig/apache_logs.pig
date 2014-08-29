DEFINE MD5 datafu.pig.hash.MD5();

set solr.collection 'access_logs';

raw_logs = load '$onoaamInput' USING TextLoader as (line:chararray);
logs_base = foreach raw_logs generate MD5(line) as (id:chararray), flatten (
     REGEX_EXTRACT_ALL(line, '^(\\S+) (\\S+) (\\S+) \\[([\\w:/]+\\s[+\\-]\\d{4})\\] "(.+?)" (\\S+) (\\S+) "([^"]*)" "([^"]*)"'))
     as (remoteaddr:   chararray,
        remotelogname: chararray,
        user:          chararray,
        time:          chararray,
        request:       chararray,
        status:        chararray,
        bytes_string:  chararray,
        referrer:      chararray,
        browser:       chararray);

final_log_data = foreach logs_base generate remoteaddr, remotelogname, user, time, request, status, bytes_string, referrer, browser, SUBSTRING(time,3,LAST_INDEX_OF(time, '/')) as month, SUBSTRING(time, LAST_INDEX_OF(time, '/')+1,11) as year;

solr_log_data = FOREACH logs_base GENERATE id, 'remoteaddr', remoteaddr, 'remotelogname', remotelogname, 'user', user, 'time', time, 'request', request, 'status', status, 'bytes_string', bytes_string, 'referrer', referrer, 'browser', browser, 'year', SUBSTRING(time, LAST_INDEX_OF(time, '/')+1,11) as year, 'month', SUBSTRING(time,3,LAST_INDEX_OF(time, '/')) as month;

final_log_data_min = foreach final_log_data generate CONCAT(remoteaddr,time) as key, remoteaddr, time, request, status, bytes_string, referrer, browser;

store final_log_data into 'demo.apache_logs' using org.apache.hcatalog.pig.HCatStorer('date=$falcon_onoaamOutput_dated_partition_value');

store solr_log_data into 'http://current.hortonworks.local:8983/solr' using com.lucidworks.hadoop.pig.SolrStoreFunc();

store final_log_data_min into 'hbase://logs' using org.apache.pig.backend.hadoop.hbase.HBaseStorage('a:key a:remoteaddr a:time a:request b:status b:bytes_string b:referrer b:browser');