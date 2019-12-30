#!/bin/bash

es_url=${ES_URL-elasticsearch-service:9200}
log_file=/var/log/es_index_clean.log

echo "*************`date '+%Y/%m/%d %T'` begin index clean*************"|tee -a ${log_file}
while read index_line
do
  index_name=`echo ${index_line}|cut -d" " -f1`
  index_expire_days=`echo ${index_line}|cut -d" " -f2`
  index_date_for_clean=`date -d "${index_expire_days} day ago" +"%Y.%m.%d"`
  echo "clean index ${index_name}-${index_date_for_clean}"
  curl -X DELETE "http://${es_url}/${index_name}-${index_date_for_clean}" |tee -a ${log_file}
done < es_index_clean_config
echo "*************`date '+%Y/%m/%d %T'` end index clean*************"|tee -a ${log_file}
