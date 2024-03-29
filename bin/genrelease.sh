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

# Clean release directory before start.
rm -rf $releasedir/*

echo -n "Zipping magento directory..."
dt=`date +%d%b%y`

# Zip the full magento directory, except the search indexes and other misc directories.
zipdirs=( "magento/app" "magento/404" "magento/js" "magento/lib" "magento/pear" "magento/pkginfo" "magento/report" "magento/skin" )
zipfiles=( "magento/*" "magento/.htaccess*" "magento/media/sales/store/logo/default/*" )
zipdircount=${#zipdirs[@]} 
for (( i=0; i<$zipdircount; i++ )) ; do
   echo -n " [${zipdirs[$i]}] "
   ( cd "$EKKITAB_HOME" ; zip -rq "$releasedir/release-$dt.zip" ${zipdirs[$i]} ) 
done
zipfilecount=${#zipfiles[@]} 
for (( i=0; i<$zipfilecount; i++ )) ; do
   echo -n " [${zipfiles[$i]}] "
   ( cd "$EKKITAB_HOME" ; zip -q "$releasedir/release-$dt.zip" ${zipfiles[$i]} ) 
done
#( cd "$EKKITAB_HOME" ; zip -q "$releasedir/release-$dt.zip" magento/* ) # Just the files in magento. Not recursive.
#( cd "$EKKITAB_HOME" ; zip -q "$releasedir/release-$dt.zip" magento/.htaccess* ) # Just the hidden files.
echo "...done."

# Copy database update patches and execution scripts.
echo -n "Copying database update scripts and patches..."
cp -r $EKKITAB_HOME/db/patches $releasedir
cp $EKKITAB_HOME/db/updatedb.sh $releasedir
cp $EKKITAB_HOME/db/checkdbversion.php $releasedir
echo "done."

echo -n "Exporting global sections..."
mysqldump -h $host -u $user -p$password ekkitab_books ek_catalog_global_sections > $releasedir/ek_catalog_global_sections.sql
mysqldump -h $host -u $user -p$password ekkitab_books ek_catalog_global_section_products > $releasedir/ek_catalog_global_section_products.sql
echo "done."

echo -n "Copying search related files.."
cp -r $EKKITAB_HOME/java/lib  $releasedir
cp $EKKITAB_HOME/java/bin/ekkitabsearch.jar  $releasedir
cp $EKKITAB_HOME/java/bin/*.properties  $releasedir
echo "done."
echo -n "Copying other misc files.."
cp $EKKITAB_HOME/bin/getactivesessions.sh $releasedir
cp $EKKITAB_HOME/bin/checkreviews.sh $releasedir
cp $EKKITAB_HOME/bin/sendmail.php $releasedir
cp $EKKITAB_HOME/bin/setdowntime.sh $releasedir
cp $EKKITAB_HOME/bin/release_on_production $releasedir
cp $EKKITAB_HOME/bin/launch_release_on_production $releasedir
cp $EKKITAB_HOME/db/trim_ekkitab_books_log_tables.sh $releasedir
cp $EKKITAB_HOME/db/trim_ekkitab_books_log_tables.sql $releasedir
echo "done."
echo -n "Copying synch file to synchronize release on server..."
cp $EKKITAB_HOME/bin/synchrelease.sh  $releasedir
echo "done."

echo `date +%D' 'at' '%T` > $releasedir/releasedate
echo "Release directory created on `date +%D' 'at' '%T`" 

