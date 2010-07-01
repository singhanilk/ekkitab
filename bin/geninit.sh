#!/bin/bash
if [ -z $EKKITAB_HOME ] ; then
    echo "EKKITAB_HOME is not set..."
    exit 1;
fi;
. $EKKITAB_HOME/bin/db.sh
# First check if release directory exists. Create it if it does not.
releasedir="$EKKITAB_HOME/release/init"
if [ ! -d $releasedir ] ; then 
    mkdir -p $releasedir;
fi
dt=`date +%d%b%y-%T`

# Clean release directory first.
rm -rf $releasedir/*

# Copy the necessary scripts over to the release directory.

bindir="$EKKITAB_HOME/bin"
dbdir="$EKKITAB_HOME/db"
datadir="$EKKITAB_HOME/data"
templatedir="$EKKITAB_HOME/release/templates"

cp $templatedir/*  $releasedir
cp $templatedir/.htpasswd  $releasedir
cp "$bindir/serverinit.sh" $releasedir
cp "$bindir/db.sh" $releasedir
cp "$bindir/readdbconfig.pl" $releasedir
cp "$bindir/synchrelease.sh" $releasedir
cp "$bindir/synchcatalog.sh" $releasedir
cp "$EKKITAB_HOME/extern/JavaBridge.war" $releasedir
cp "$dbdir/reset_ekkitab_books.sh" $releasedir
cp "$dbdir/reset_ekkitab_books.sql" $releasedir
cp "$dbdir/backup.sh" $releasedir
cp "$dbdir/create_ekkitab_db.sql" $releasedir
cp "$dbdir/version.sql" $releasedir
cp "$datadir/ekkitab_books_categories.sql" $releasedir
cp "$dbdir/init_ekkitab_books_db.sql" $releasedir
cp "$bindir/sendsms.php" $releasedir

echo "Creating release date file"
echo `date +%D' 'at' '%T` > $releasedir/releasedate
echo "Release directory created on `date +%D' 'at' '%T`" 


