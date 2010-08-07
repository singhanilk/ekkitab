#!/bin/bash
if [ -z $EKKITAB_HOME ] ; then
    echo "EKKITAB_HOME is not set..."
    exit 1;
fi;
. $EKKITAB_HOME/bin/db.sh 
if [ $# -ne 2 ] ; then
    echo "Not enough arguments...."; echo "Usage: $0 -o <backupfile>" 
    exit 1;
fi;
backupfile=""
if [ "$1" == "-o" ] ; then
   backupfile=$2
else 
   echo "[Error] Argument '$1' is not understood."
   exit 1;
fi
if [ "$backupfile" == "" ] ; then
   echo "[Error] Backup filename is empty. "
   exit 1;
fi

mysqldump -h $host -u $user -p$password ekkitab_books customer_entity > $backupfile 2>/dev/null 
mysqldump -h $host -u $user -p$password ekkitab_books customer_entity_datetime >> $backupfile 2>/dev/null 
mysqldump -h $host -u $user -p$password ekkitab_books customer_entity_decimal >> $backupfile 2>/dev/null 
mysqldump -h $host -u $user -p$password ekkitab_books customer_entity_int >> $backupfile 2>/dev/null 
mysqldump -h $host -u $user -p$password ekkitab_books customer_entity_text >> $backupfile 2>/dev/null 
mysqldump -h $host -u $user -p$password ekkitab_books customer_entity_varchar >> $backupfile 2>/dev/null 
mysqldump -h $host -u $user -p$password ekkitab_books customer_address_entity >> $backupfile 2>/dev/null 
mysqldump -h $host -u $user -p$password ekkitab_books customer_address_entity_datetime >> $backupfile 2>/dev/null 
mysqldump -h $host -u $user -p$password ekkitab_books customer_address_entity_decimal >> $backupfile 2>/dev/null 
mysqldump -h $host -u $user -p$password ekkitab_books customer_address_entity_int >> $backupfile 2>/dev/null 
mysqldump -h $host -u $user -p$password ekkitab_books customer_address_entity_text >> $backupfile 2>/dev/null 
mysqldump -h $host -u $user -p$password ekkitab_books customer_address_entity_varchar >> $backupfile 2>/dev/null 
mysqldump -h $host -u $user -p$password ekkitab_books eav_entity_store >> $backupfile 2>/dev/null 
