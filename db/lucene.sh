#
#  sudo apt-get install tomcat6

EKKITAB_HOME=/var/www/scm
TOMCAT6=/var/lib/tomcat6
TOM_WEBINF=$TOMCAT6/webapps/JavaBridge/WEB-INF

sudo cp $EKKITAB_HOME/extern/JavaBridge.war $TOMCAT6/webapps

sudo mkdir -p $TOM_WEBINF/classes
sudo cp $EKKITAB_HOME/java/bin/* $TOM_WEBINF/classes

sudo rm -f $TOM_WEBINF/lib/lucene*

sudo cp $EKKITAB_HOME/java/lib/* $TOM_WEBINF/lib

sudo service tomcat6 restart


