#!/bin/bash
if [ -z $EKKITAB_HOME ] ; then
    echo "EKKITAB_HOME is not set..."
    exit 1;
fi;
if [ $# -ne 4 ] ; then
    echo "Not enough arguments...."; echo "Usage: $0 <host> <user> <password> <config-file>" 
    exit 1;
fi;
while read line;
do 
  args=`echo $line | cut -d' ' -f1 | while read z; do echo $z; done | sed 's/\"//g'`; 
  plugin=`echo $line | cut -d' ' -f2 | while read z; do echo $z; done | sed 's/\"//g'`;
  filename=`echo $line | cut -d' ' -f3 | while read z; do echo $z; done | sed 's/\"//g'`;
  #echo php importbooks.php $args $plugin $filename
  (cd $EKKITAB_HOME/db; php importbooks.php $args $plugin $filename)
done < $4  

