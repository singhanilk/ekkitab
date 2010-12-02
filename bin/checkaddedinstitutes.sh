#!/bin/bash
if [ -z $EKKITAB_HOME ] ; then
    echo "EKKITAB_HOME is not set..."
    exit 1;
fi;
. $EKKITAB_HOME/bin/db.sh 
rundate=$(date +"%D-%T")
addedcount=`mysql -u $user -p$password -h $host ekkitab_books -e  "select count(1) from ek_social_institutes where is_valid=0"` ; 
addedcount=`echo ${addedcount##count(1)}`
if (( $addedcount > 0 )) ; then
  echo -e "Dear Administrator,\nThe following institutes have been added , as of $rundate.\nPlease login to http://www.ekkitab.com/internalutils/validateInstitutes.phtml to view and approve them.\n-----------------------------------------------------------------------------"
  for (( i=0; i<$addedcount; i++ )) ; do
     institute=`mysql -u $user -p$password -h $host ekkitab_books -e  "select name from ek_social_institutes eksi where eksi.is_valid=0 limit $i,1"` ; 
     name=`echo ${institute##*->}`
     echo "Institute: $name"
  done
  echo "-----------------------------------------------------------------------------"
fi
