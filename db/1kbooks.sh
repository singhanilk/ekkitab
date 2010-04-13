#To load 1k test Data set EKKITAB_HOME = 
echo ""
if [ -n $EKKITAB_HOME ]
then
  export EKKITAB_HOME=/var/www/scm
fi

echo "EKKITAB_HOME: $EKKITAB_HOME "
echo ""
. $EKKITAB_HOME/bin/db.sh 

echo "The command will be run with host: $host, user: $user, password: $password"
echo ""
echo "PRESS RETURN TO CONTINUE"
read response
echo "Continuing....."

##########################################################
### Reset Ekkitab_Books and Reference Databases.
##########################################################
# mysql -u $uid -p$pswd < reset_ekkitab_books.sql
(cd $EKKITAB_HOME/db; ./reset_ekkitab_books.sh)
mysql -h $host -u $user -p$password < reset_refdb.sql

##########################################################
###  import the 1k test data
##########################################################
php importbooks.php -a 1ktestdata   ../data/1ktestdata.txt
##########################################################
###  import the 50 low-cost books.
##########################################################
php importbooks.php -a 1ktestdata   ../data/50lowcostbooks.txt
##########################################################
### Copy the books table to ekkitab_books database. 
##########################################################
./loadbooks.sh
##########################################################
### Create the search index. 
##########################################################
#12. (cd $EKKITAB_HOME/bin; ./create_index.sh <db host> <db user> <db password>;)

(cd $EKKITAB_HOME/bin; ./create_index.sh)


