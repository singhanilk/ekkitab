set dbhost=%1
set uid=%2
set pswd=%3

mysql -s -h %dbhost% -u %uid% -p%pswd% < %EKKITAB_HOME%/db/loadbooks.sql