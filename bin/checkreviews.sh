#!/bin/bash
if [ -z $EKKITAB_HOME ] ; then
    echo "EKKITAB_HOME is not set..."
    exit 1;
fi;
. $EKKITAB_HOME/bin/db.sh 
tomail=""
while [ $# -gt 0 ] ; do 
    tomail="$tomail $1"
    shift
done 
if [ "$tomail" == "" ] ; then
    tomail=anisha@ekkitab.com # Default recipient
fi

tomail=`echo $tomail`
rundate=$(date +"%D-%T")
pendingreviewcount=`mysql -u $user -p$password -h $host ekkitab_books -e  "select count(*) from review where status_id=2"` ; 
pendingreviewcount=`echo ${pendingreviewcount##count(*)}`
z="Hi \n Below are the reviews which need your attention. Please login to admin to view and approve them.\n"
reviews=`mysql -u $user -p$password -h $host ekkitab_books -e  "select rd.title,rd.nickname from review r, review_detail rd where r.review_id=rd.review_id and r.status_id=2"` ; 
z= "$z \n Regards"
echo "$z"