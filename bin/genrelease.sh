#!/bin/bash
if [ -z $EKKITAB_HOME ] ; then
    echo "EKKITAB_HOME is not set..."
    exit 1;
fi;
. $EKKITAB_HOME/bin/db.sh
# First check if release directory exists. Create it if it does not.
releasedir="$EKKITAB_HOME/release/app"
echo -n "Checking for directory $releasedir ..."

if [ ! -d $releasedir ] ; then 
    mkdir -p $releasedir;
fi
echo "done."

echo -n "Zipping magento directory..."
dt=`date +%d%b%y-%T`
# Zip the full magento directory, except the search indexes and other misc directories.
( cd "$EKKITAB_HOME" ; zip -rq "$releasedir/release-$dt.zip" magento -x magento/search_index_dir/\* -x magento/search_index_dir_spell_author/\* -x magento/search_index_dir_spell_title/\* -x magento/categories.xml -x magento/media/catalog/product/\* -x magento/var/cache/\* -x magento/var/session/\* -x magento/var/log/\* -x magento/downloader/\* ) 
echo "done."

echo -n "Copying search related files.."
cp -r $EKKITAB_HOME/java/lib  $releasedir
cp $EKKITAB_HOME/java/bin/ekkitabsearch.jar  $releasedir
cp $EKKITAB_HOME/java/bin/*.properties  $releasedir
echo "done."

echo `date +%D' 'at' '%T` > $releasedir/releasedate
echo "Release directory created on `date +%D' 'at' '%T`" 


