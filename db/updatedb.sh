#!/bin/bash
if [ -z $EKKITAB_HOME ] ; then
    echo "EKKITAB_HOME is not set..."
    exit 1;
fi;
. $EKKITAB_HOME/bin/db.sh 
dbversion=-1;
dbversion=`php $EKKITAB_HOME/db/checkdbversion.php`
if (($? != 0)) ; then
  echo "Fatal: Could not retrieve database version number."
  exit 1;
fi 
if (($dbversion < 0)) ; then
  echo "Fatal: Could not initialize version table of database";
  exit 1;
fi
patchdir=$EKKITAB_HOME/db/patches
patches=();
index=0;
cd $patchdir && for i in *.sql ; do
   if [ "$i" == "*.sql" ] ; then
      break;
   fi
   i=${i%.sql}
   i=${i#*-}
   patches[$index]=$i;
   (( index=index+1 ));
done 
max=${#patches[@]};
if (($max == 0)) ; then
  echo "No patches to apply."
  exit 0;
fi

sortedpatches=( $(for (( i=0; i<$max; i++ )) ; do echo "${patches[$i]}" ; done | sort -n) )

max=${#sortedpatches[*]};

# Run the patch sql scripts that are required.
patchnumber=0;
for (( i=0; i<$max; i++ )) ; do
   if ((${sortedpatches[$i]} > $dbversion)) ; then
      patchnumber=${sortedpatches[$i]}
      mysql -u $user -p$password -h $host ekkitab_books < $patchdir/patch-${sortedpatches[$i]}.sql
      mysql -u $user -p$password -h $host ekkitab_books -e "update ekkitab_db_version set version = $patchnumber"
   fi
done

if (($patchnumber > 0)) ; then
  echo "Database updated to version: $patchnumber";
else 
  echo "Database is at version $dbversion and is up to date.";
fi
