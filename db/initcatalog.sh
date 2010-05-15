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
   (cd $EKKITAB_HOME/db; ./loadbooks.sh)
   (cd $EKKITAB_HOME/bin; ./create_index.sh)
fi

