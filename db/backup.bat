set dbhost=%1
set uid=%2
set pswd=%3
mysqldump -h %dbhost% -u %uid% -p%pswd% ekkitab_books customer_entity > %EKKITAB_HOME%/data/backup.sql 
mysqldump -h %dbhost% -u %uid% -p%pswd% ekkitab_books customer_entity_datetime >> %EKKITAB_HOME%/data/backup.sql 
mysqldump -h %dbhost% -u %uid% -p%pswd% ekkitab_books customer_entity_decimal >> %EKKITAB_HOME%/data/backup.sql 
mysqldump -h %dbhost% -u %uid% -p%pswd% ekkitab_books customer_entity_int >> %EKKITAB_HOME%/data/backup.sql 
mysqldump -h %dbhost% -u %uid% -p%pswd% ekkitab_books customer_entity_text >> %EKKITAB_HOME%/data/backup.sql 
mysqldump -h %dbhost% -u %uid% -p%pswd% ekkitab_books customer_entity_varchar >> %EKKITAB_HOME%/data/backup.sql 
mysqldump -h %dbhost% -u %uid% -p%pswd% ekkitab_books customer_address_entity >> %EKKITAB_HOME%/data/backup.sql 
mysqldump -h %dbhost% -u %uid% -p%pswd% ekkitab_books customer_address_entity_datetime >> %EKKITAB_HOME%/data/backup.sql 
mysqldump -h %dbhost% -u %uid% -p%pswd% ekkitab_books customer_address_entity_decimal >> %EKKITAB_HOME%/data/backup.sql 
mysqldump -h %dbhost% -u %uid% -p%pswd% ekkitab_books customer_address_entity_int >> %EKKITAB_HOME%/data/backup.sql 
mysqldump -h %dbhost% -u %uid% -p%pswd% ekkitab_books customer_address_entity_text >> %EKKITAB_HOME%/data/backup.sql 
mysqldump -h %dbhost% -u %uid% -p%pswd% ekkitab_books customer_address_entity_varchar >> %EKKITAB_HOME%/data/backup.sql 
mysqldump -h %dbhost% -u %uid% -p%pswd% ekkitab_books eav_entity_store >> %EKKITAB_HOME%/data/backup.sql 
