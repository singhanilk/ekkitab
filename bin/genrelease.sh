#!/bin/bash
if [ -z $EKKITAB_HOME ] ; then
    echo "EKKITAB_HOME is not set..."
    exit 1;
fi;
. $EKKITAB_HOME/bin/db.sh
# First check if release directory exists. Create it if it does not.
releasedir="$EKKITAB_HOME/release/app"
if [ ! -d $releasedir ] ; then 
    mkdir -p $releasedir;
fi
dt=`date +%d%b%y-%T`
# Zip the full magento directory, except the search indexes and other misc directories.
( cd "$EKKITAB_HOME" ; zip -rq "$releasedir/release-$dt.zip" magento -x magento/search_index_dir/\* -x magento/search_index_dir_spell_author/\* -x magento/search_index_dir_spell_title/\* -x magento/categories.xml -x magento/media/catalog/product/\* -x magento/var/cache/\* -x magento/var/session/\* -x magento/var/log/\* -x magento/downloader/\* ) 
echo "Copying search related files.."
cp -r $EKKITAB_HOME/java/lib  $releasedir
cp $EKKITAB_HOME/java/bin/ekkitabsearch.jar  $releasedir
cp $EKKITAB_HOME/java/bin/*.properties  $releasedir
echo "Copying .htaccess files..."
cp $EKKITAB_HOME/magento/.htaccess.* $releasedir
echo "Creating release date file"
echo `date +%D' 'at' '%T` > $releasedir/releasedate
echo "Release directory created on `date +%D' 'at' '%T`" 


