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
# Clean release directory before start.
rm -rf $releasedir/*

DBTABLES=( "books" "ekkitab_books" "book_availability" "reference" "books_promo" "ekkitab_books" );
tablecount=${#DBTABLES[@]}

for ((i=0; i < $tablecount; i+=2)) ; do
   table=${DBTABLES[$i]};
   let j=i+1;
   db=${DBTABLES[$j]};
   echo -n "Exporting table $table from database $db..."
   sudo rm -f /tmp/$table.txt
   query="select * from $table into outfile '/tmp/$table.txt'";
   mysql -h $host -u $user -p$password $db -e "$query";
   echo "done."
   cp /tmp/$table.txt $releasedir
done

echo -n "Exporting global sections..."
mysqldump -h $host -u $user -p$password ekkitab_books ek_catalog_global_sections > $releasedir/ek_catalog_global_sections.sql
mysqldump -h $host -u $user -p$password ekkitab_books ek_catalog_global_section_products > $releasedir/ek_catalog_global_section_products.sql
echo "done."

echo -n "Copying search related files.."
cp -r $EKKITAB_HOME/magento/search_index_dir $releasedir
cp -r $EKKITAB_HOME/magento/search_index_dir_spell_author $releasedir
cp -r $EKKITAB_HOME/magento/search_index_dir_spell_title $releasedir
cp -r $EKKITAB_HOME/magento/categories.xml $releasedir
echo "done."

echo -n "Copying synch file to synchronize release on server..."
cp $EKKITAB_HOME/bin/synchcatalog.sh  $releasedir
echo "done."
echo -n "Copying sample search script..."
cp $EKKITAB_HOME/bin/samplesearch.php  $releasedir
echo "done."

echo -n "Creating release date file..."
echo `date +%D' 'at' '%T` > $releasedir/releasedate
echo "done."
echo "Release directory created on `date +%D' 'at' '%T`" 


