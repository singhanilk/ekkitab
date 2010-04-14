@echo off
rem To load 1k test Data set EKKITAB_HOME =c:/xampp/htdocs/scm/ 
echo.

if not "%EKKITAB_HOME%" == "" goto label1
set EKKITAB_HOME=c:/xampp/htdocs/scm/
:label1
::echo EKKITAB_HOME: %EKKITAB_HOME%
::echo.
set uid=root
set pswd=root
set dbhost=localhost

if not "%3"=="" goto proceed
   echo Insufficient arguments: You have entered less than 3 args
   echo.
   echo Usage: %0% db_uid db_passwd dbhost
   echo.
   set /p ans =PRESS RETURN TO CONTINUE
goto :eof   
:proceed
	set uid=%1
	set pswd=%2
	set dbhost=%3
	echo The command will be run as :%0  %uid% %pswd% %dbhost%
	echo.
	set /p ans =PRESS RETURN TO CONTINUE

rem ##########################################################
rem ### Reset Ekkitab_Books and Reference Databases.
rem ##########################################################
rem # mysql -u %uid% -p%pswd% < reset_ekkitab_books.sql
cd %EKKITAB_HOME%/db
echo calling reset_ekkitab_books.bat %dbhost% %uid% %pswd%
CALL reset_ekkitab_books.bat %dbhost% %uid% %pswd%
mysql -u %uid% -p%pswd% < reset_refdb.sql

rem import the 1k test data
rem ##########################################################
php importbooks.php -a 1ktestdata   ../data/1ktestdata.txt
rem ##########################################################
rem ###  import the 50 low-cost books.
rem ##########################################################
php importbooks.php -a 1ktestdata   ../data/50lowcostbooks.txt
rem ##########################################################
rem ### Copy the books table to ekkitab_books database. 
rem ##########################################################
call loadbooks.bat %dbhost% %uid% %pswd%
rem ##########################################################
mysql -s -h %dbhost% -u %uid% -p%pswd% reference < %EKKITAB_HOME%/data/books_tmp_windows.sql 
rem ##########################################################
mysql -s -h %dbhost% -u %uid% -p%pswd% ekkitab_books < %EKKITAB_HOME%/data/books_tmp_windows.sql 
rem ##########################################################
rem ### Create the search index. 

cd %EKKITAB_HOME%/bin

call create_index.bat %dbhost% %uid% %pswd%

cd %EKKITAB_HOME%/db

