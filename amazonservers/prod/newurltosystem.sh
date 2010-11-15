#After bringing on a new system, cd /etc/apache2/sites-enabled, and change www.e#kkitab.com to the ip address
#And than run this script after changing the ip address in BASE_URL

BASE_URL=http://204.236.214.10/

# Set base url.
paths=( "web/unsecure/base_url" "web/secure/base_url" "billdesk/wps/return_url" "ccav/wps/return_url" );
pathvalues=( "$BASE_URL" "$BASE_URL" "${BASE_URL}billdesk/standard/response" "${BASE_URL}ccav/standard/ccavresponse" );
pathcount=${#paths[@]}

echo -n "Setting Base Url for http access..."
for (( i=0; i<$pathcount; i++ )) ; do
    query="insert into core_config_data (scope, scope_id, path, value) values ('default', 0, '${paths[$i]}', '${pathvalues[$i]}') on duplicate key update value = '${pathvalues[$i]}'";
    if ( ! mysql -u root -peki22AbSt0re  -h localhost ekkitab_books -e "$query" >/dev/null 2>&1 ) ; then
        echo "\nSetting of path '${paths[$i]}' failed. Please set manually.\n"
    else
        echo -n " [${paths[$i]}] "
    fi
done
echo "done."
