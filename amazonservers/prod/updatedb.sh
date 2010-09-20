# This is to be run after we have the new system from snapshots
# cp /mnt2/scm/db_backup to new m/c /tmp/db_backup
# cd to /tmp/db_backup and execute this
for i in *sql
do
mysql -u root -peki22AbStore ekkitab_books < $i
done

