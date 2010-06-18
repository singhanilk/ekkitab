#!/bin/bash
if [ -z $EKKITAB_HOME ] ; then
    echo "EKKITAB_HOME is not set..."
    exit 1;
fi;
. $EKKITAB_HOME/bin/db.sh
# First check if release directory exists. Create it if it does not.
releasedir="$EKKITAB_HOME/release/catalog"
if [ ! -d $releasedir ] ; then 
    mkdir -p $releasedir;
fi

# Clean the release directory
( cd $releasedir; rm -rf * )

echo "Exporting books..."
mysqldump -h $host -u $user -p$password ekkitab_books books > $releasedir/books.sql
echo "Copying search related files.."
cp -r $EKKITAB_HOME/magento/search_index_dir $releasedir
cp -r $EKKITAB_HOME/magento/search_index_dir_spell_author $releasedir
cp -r $EKKITAB_HOME/magento/search_index_dir_spell_title $releasedir
cp -r $EKKITAB_HOME/magento/categories.xml $releasedir
echo "Creating release date file"
echo `date +%D' 'at' '%T` > $releasedir/releasedate
echo "Release directory created on `date +%D' 'at' '%T`" 


