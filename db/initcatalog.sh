#!/bin/bash
if [ -z $EKKITAB_HOME ] ; then
    echo "EKKITAB_HOME is not set..."
    exit 1;
fi;
. $EKKITAB_HOME/bin/db.sh 
if [ $# -lt 1 ] ; then
    echo "Not enough arguments...."; echo "Usage: $0 <config-file> [ -n ]" 
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
  rm $logfile
fi
while read line;
do 
  args=`echo $line | cut -d' ' -f1 | while read z; do echo $z; done | sed 's/\"//g'`; 
  plugin=`echo $line | cut -d' ' -f2 | while read z; do echo $z; done | sed 's/\"//g'`;
  filename=`echo $line | cut -d' ' -f3 | while read z; do echo $z; done | sed 's/\"//g'`;
  #echo php importbooks.php $args $plugin $filename
  if [[ ! $args =~ \#+ ]] ; then
    (cd $EKKITAB_HOME/db; php importbooks.php $args $plugin $filename) ;
  fi
done < $1  
if [ $# -gt 1 ] && [ $2 == '-n' ] ; then
    echo "Not indexing or loading books to production ..." 
else 
   ( cd $EKKITAB_HOME/db; ./loadbooks.sh )
   if [[ $dbid == 0 ]] ; then
        ( cd $EKKITAB_HOME/bin; ./create_index.sh )
   else 
        ( cd $EKKITAB_HOME/bin; ./update_index.sh $dbid )
   fi
fi

