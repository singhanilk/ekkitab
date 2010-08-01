#!/bin/bash
set +v
if [ -z $EKKITAB_HOME ] ; then
    echo "EKKITAB_HOME is not set..."
    exit 1;
fi;
. $EKKITAB_HOME/bin/db.sh 
echo "generating betacustomer insertqueries...."
cd $EKKITAB_HOME/bin; 
sqlfile=/tmp/betacustomers.sql
php generate_customer_entity.php -i $1 -o $sqlfile 
echo "generated the sql file... updating the database...."
mysql -s -h $host -u $user -p$password <<!
source $sqlfile;
!
rm -f $sqlfile
