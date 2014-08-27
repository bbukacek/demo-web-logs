raw_logs = load '$onoaamInput' USING PigStorage as (line:chararray);
logs_base = foreach raw_logs generate flatten (
     REGEX_EXTRACT_ALL(line, '^(\\S+) (\\S+) (\\S+) \\[([\\w:/]+\\s[+\\-]\\d{4})\\] "(.+?)" (\\S+) (\\S+) "([^"]*)" "([^"]*)"'))
    as (remoteaddr:    chararray,
        remotelogname: chararray,
        user:          chararray,
        time:          chararray,
        request:       chararray,
        status:        chararray,
        bytes_string:  chararray,
        referrer:      chararray,
        browser:       chararray);
final_log_data = foreach logs_base generate remoteaddr, remotelogname, user, time, request, status, bytes_string, referrer, browser, SUBSTRING(time, LAST_INDEX_OF(time, '/')+1,11) as year, SUBSTRING(time,3,LAST_INDEX_OF(time, '/')) as month;
store final_log_data into 'apache_logs' using org.apache.hcatalog.pig.HCatStorer('date=$falcon_onoaamOutput_dated_partition_value');