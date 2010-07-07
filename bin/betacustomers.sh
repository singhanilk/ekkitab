#!/bin/bash
if [ -z $EKKITAB_HOME ] ; then
    echo "EKKITAB_HOME is not set..."
    exit 1;
fi;
. $EKKITAB_HOME/bin/db.sh 
echo "generating betacustomer insertqueries...."
cd $EKKITAB_HOME/bin; 
php generate_customer_entity.php -i ../data/allusers.txt
echo "generated the sql file... updating the database...."
mysql -s -h $host -u $user -p$password <<!
source $EKKITAB_HOME/db/beta_customers.sql;
!