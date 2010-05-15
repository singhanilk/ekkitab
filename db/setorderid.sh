#!/bin/bash
if [ -z $EKKITAB_HOME ] ; then
    echo "EKKITAB_HOME is not set..."
    exit 1;
fi;
. $EKKITAB_HOME/bin/db.sh 
if [ $# -ne 1 ] ; then
    echo "Not enough arguments...."; echo "Usage: $0 <orderid>" 
    exit 1;
fi;
mysql -e "delete from eav_entity_store where entity_type_id = '11' and store_id = '1' " -h $host -u $user -p$password ekkitab_books
mysql -e "insert into eav_entity_store (entity_type_id, store_id, increment_prefix, increment_last_id) values ('11', '1', '1', '$1') " -h $host -u $user -p$password ekkitab_books
