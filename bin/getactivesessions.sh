#!/bin/bash
if [ -z $EKKITAB_HOME ] ; then
    echo "EKKITAB_HOME is not set..."
    exit 1;
fi;
. $EKKITAB_HOME/bin/db.sh 
activesessions=`mysql -u $user -p$password -h $host ekkitab_books -e  "select count(distinct(session_id))  from log_visitor where last_visit_at >=(now() -INTERVAL 10 MINUTE)"` ; 
activesessions=`echo ${activesessions##count(distinct(session_id))}`
echo $activesessions
