#
#  sudo apt-get install tomcat6

service tomcat6 stop

if [ -n $EKKITAB_HOME ]
then
  export EKKITAB_HOME=/var/www/scm
fi

echo "EKKITAB_HOME: $EKKITAB_HOME "
echo ""

echo "PRESS RETURN TO CONTINUE"
read response




EKKITAB_HOME=/var/www/scm
TOMCAT6=/var/lib/tomcat6
TOM_WEBINF=$TOMCAT6/webapps/JavaBridge/WEB-INF

rm -rf $TOMCAT6/webapps/JavaBridge
rm -rf $TOMCAT6/webapps/JavaBridge.war

cp $EKKITAB_HOME/extern/JavaBridge.war $TOMCAT6/webapps

service tomcat6 start
sleep 15

mkdir -p $TOM_WEBINF/classes
cp $EKKITAB_HOME/java/bin/log4j.properties $TOM_WEBINF/classes
cp $EKKITAB_HOME/java/bin/search.properties $TOM_WEBINF/classes
cp $EKKITAB_HOME/java/bin/ekkitabsearch.jar $TOM_WEBINF/lib

rm -f $TOM_WEBINF/lib/lucene*

cp $EKKITAB_HOME/java/lib/* $TOM_WEBINF/lib

service tomcat6 restart


