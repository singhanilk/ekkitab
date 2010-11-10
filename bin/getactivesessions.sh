#!/bin/bash
if [ -z $EKKITAB_HOME ] ; then
    echo "EKKITAB_HOME is not set..."
    exit 1;
fi;
. $EKKITAB_HOME/bin/db.sh 
query="select count(distinct(http_user_agent)) from log_visitor_info where visitor_id in (select distinct visitor_id from log_visitor where last_visit_at >=(now() -INTERVAL 10 MINUTE)) and http_user_agent not like '%Googlebot%' and http_user_agent not like '%SiteUptime.com%' and http_user_agent not like '%Slurp%' and http_user_agent not like '%AskTb%'";
activesessions=`mysql -u $user -p$password -h $host ekkitab_books -e "$query"` ; 
activesessions=`echo ${activesessions##count(distinct(http_user_agent))}`
echo $activesessions
