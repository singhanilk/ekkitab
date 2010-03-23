#To load 1k test Data set EKKITAB_HOME = 
echo ""

if [ -n $EKKITAB_HOME ]
then
  export EKKITAB_HOME=/var/www/scm
fi

echo "EKKITAB_HOME: $EKKITAB_HOME "
echo ""
uid=root
pswd=root
dbhost=localhost

if [ $# -ne 3 ]
then
   echo "Usage: $0 db_uid db_passwd dbhost "
   echo "You have entered less than 3 args"
   echo "The command will be run as :$0  $uid $pswd $dbhost "
   echo ""
   echo "PRESS RETURN TO CONTINUE"
   read response
else
   uid=$1
   pswd=$2
   dbhost=$3
   echo "The command will be run as :$0  $uid $pswd $dbhost "
   echo ""
   echo "PRESS RETURN TO CONTINUE"
   read response
fi

echo "Continuing....."

##########################################################
### Reset Ekkitab_Books and Reference Databases.
##########################################################
 mysql -u $uid -p$pswd < reset_ekkitab_books.sql
 mysql -u $uid -p$pswd < reset_refdb.sql

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
. loadbooks.sh $3 $1 $2

##########################################################
### Create the search index. 
##########################################################
#12. (cd $EKKITAB_HOME/bin; ./create_index.sh <db host> <db user> <db password>;)

(cd $EKKITAB_HOME/bin; ./create_index.sh $dbhost $uid $pswd;)


