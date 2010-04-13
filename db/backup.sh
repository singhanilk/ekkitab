#!/bin/bash
if [ -z $EKKITAB_HOME ] ; then
    echo "EKKITAB_HOME is not set..."
    exit 1;
fi;
. $EKKITAB_HOME/bin/db.sh 
#if [ $# -ne 3 ] ; then
#    echo "Not enough arguments...."; echo "Usage: $0 <host> <user> <password>" 
#    exit 1;
#fi;
mysqldump -h $host -u $user -p$password ekkitab_books customer_entity > $EKKITAB_HOME/data/backup.sql 2>/dev/null 
mysqldump -h $host -u $user -p$password ekkitab_books customer_entity_datetime >> $EKKITAB_HOME/data/backup.sql 2>/dev/null 
mysqldump -h $host -u $user -p$password ekkitab_books customer_entity_decimal >> $EKKITAB_HOME/data/backup.sql 2>/dev/null 
mysqldump -h $host -u $user -p$password ekkitab_books customer_entity_int >> $EKKITAB_HOME/data/backup.sql 2>/dev/null 
mysqldump -h $host -u $user -p$password ekkitab_books customer_entity_text >> $EKKITAB_HOME/data/backup.sql 2>/dev/null 
mysqldump -h $host -u $user -p$password ekkitab_books customer_entity_varchar >> $EKKITAB_HOME/data/backup.sql 2>/dev/null 
mysqldump -h $host -u $user -p$password ekkitab_books customer_address_entity >> $EKKITAB_HOME/data/backup.sql 2>/dev/null 
mysqldump -h $host -u $user -p$password ekkitab_books customer_address_entity_datetime >> $EKKITAB_HOME/data/backup.sql 2>/dev/null 
mysqldump -h $host -u $user -p$password ekkitab_books customer_address_entity_decimal >> $EKKITAB_HOME/data/backup.sql 2>/dev/null 
mysqldump -h $host -u $user -p$password ekkitab_books customer_address_entity_int >> $EKKITAB_HOME/data/backup.sql 2>/dev/null 
mysqldump -h $host -u $user -p$password ekkitab_books customer_address_entity_text >> $EKKITAB_HOME/data/backup.sql 2>/dev/null 
mysqldump -h $host -u $user -p$password ekkitab_books customer_address_entity_varchar >> $EKKITAB_HOME/data/backup.sql 2>/dev/null 
mysqldump -h $host -u $user -p$password ekkitab_books eav_entity_store >> $EKKITAB_HOME/data/backup.sql 2>/dev/null 
