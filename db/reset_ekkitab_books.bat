@echo off
echo Backing up customer and order data...
set dbhost=%1
set uid=%2
set pswd=%3
echo calling %EKKITAB_HOME%/db/backup.bat %dbhost% %uid% %pswd%
call %EKKITAB_HOME%/db/backup.bat %dbhost% %uid% %pswd%
echo Resetting database and restoring backed up data...
mysql -s -h %dbhost% -u %uid% -p%pswd% < %EKKITAB_HOME%/db/reset_ekkitab_books.sql
mysql -s -h %dbhost% -u %uid% -p%pswd% < %EKKITAB_HOME%/data/backup.sql 

