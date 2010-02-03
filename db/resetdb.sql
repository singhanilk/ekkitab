drop database if exists ekkitab_books;
drop database if exists reference;
source create_ekkitab_db.sql;
source create_reference_db.sql;
source ../data/ekkitab_categories.sql;
source initdb.sql;
