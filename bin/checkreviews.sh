#!/bin/bash
if [ -z $EKKITAB_HOME ] ; then
    echo "EKKITAB_HOME is not set..."
    exit 1;
fi;
. $EKKITAB_HOME/bin/db.sh 
rundate=$(date +"%D-%T")
pendingreviewcount=`mysql -u $user -p$password -h $host ekkitab_books -e  "select count(*) from review where status_id=2"` ; 
pendingreviewcount=`echo ${pendingreviewcount##count(*)}`
if (( $pendingreviewcount > 0 )) ; then
  echo -e "Dear Administrator,\nThe following reviews require clearance for display on the website, as of $rundate.\nPlease login to admin to view and approve them.\n-----------------------------------------------------------------------------"
  for (( i=0; i<$pendingreviewcount; i++ )) ; do
     review=`mysql -u $user -p$password -h $host ekkitab_books -e  "select rd.title,'->',rd.nickname from review r, review_detail rd where r.review_id=rd.review_id and r.status_id=2 limit $i,1"` ; 
     review=`echo ${review##*nickname}`;
     title=`echo ${review%%->*}`
     name=`echo ${review##*->}`
     echo "Review: '$title'  by '$name'"
  done
  echo "-----------------------------------------------------------------------------"
fi
