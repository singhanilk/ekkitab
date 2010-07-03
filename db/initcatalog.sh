#!/bin/bash
if [ -z $EKKITAB_HOME ] ; then
    echo "EKKITAB_HOME is not set..."
    exit 1;
fi;
. $EKKITAB_HOME/bin/db.sh 
if [ $# -lt 2 ] ; then
    echo "Not enough arguments...."; echo "Usage: $0 <config-file> <mode> " 
    exit 1;
fi;
dbid=`mysql -e "select max(id) from books" -h $host -u $user -p$password reference`
dbid=`echo $dbid | cut -d' ' -f2`
if [[ $dbid != "NULL" ]] ; then
    let dbid=$dbid+1;
else 
    let dbid=0;
fi
# Ready to process.
# Delete logfile before starting.
s=`grep "log4php.appender.DiskFile.File=" $EKKITAB_HOME/config/logger.properties`; 
logfile=${s#*=};
if [ -f $logfile ] ; then
  mv $logfile "$logfile.old"
fi

case "$2" in 
   "-p") mode="price";;
   "-c") mode="catalog";;
   "-u") mode="update";;
   *)  echo "Fatal: Unknown mode: $2."
         exit 1;;
esac
 
while read line;
do 
  if ! [ "$line" == "" ] ; then 
    args=`echo $line | cut -d' ' -f1`; 
    plugin=`echo $line | cut -d' ' -f2`;
    filename=`echo $line | cut -d' ' -f3`;
    if [[ ! $args =~ \#+ ]] ; then
        if ( [ "$mode" == "price" ] && [ "$args" == "-p" ] ) || ( [ $mode == "catalog" ]  && [ "$args" != "-p" ] ) ; then
            echo "Running $filename ..."
            ( cd $EKKITAB_HOME/db; php importbooks.php $args $plugin $filename ) ;
        fi
    fi
  fi
done < $1  

if [ $mode == "catalog" ] ; then 
    echo "Deleting banned books from database..."
    ( cd $EKKITAB_HOME/db ; ./deletebannedbooks.sh ../data/banned.txt )
fi

if [ "$mode" == "update" ] ; then
   echo "Starting Indexing..." 
   # Set System to maintenance
   ( cd $EKKITAB_HOME/magento ; cp .htaccess.maintenance .htaccess )
   echo "Starting load of books to production database..." 
   ( cd $EKKITAB_HOME/db; ./loadbooks.sh )
   if ( ! $pricemode ) ; then 
      if [[ $dbid == 0 ]] ; then
        ( cd $EKKITAB_HOME/bin; ./create_index.sh )
      else 
        ( cd $EKKITAB_HOME/bin; ./update_index.sh $dbid )
      fi
   fi
   # take System off maintenance
   ( cd $EKKITAB_HOME/magento ; cp .htaccess.prod .htaccess )
fi

