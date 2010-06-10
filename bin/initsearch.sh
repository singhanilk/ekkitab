#!/bin/bash
if [ -z $EKKITAB_HOME ] ; then
    echo "EKKITAB_HOME is not set..."
    exit 1;
fi;

if [ x${TOMCAT_HOME} == "x" ] ; then
   tomcathome="/var/lib/tomcat6"
else
   tomcathome=$TOMCAT_HOME
fi
searchlib=$tomcathome/webapps/JavaBridge/WEB-INF/lib
classesdir=$tomcathome/webapps/JavaBridge/WEB-INF/classes

if [ ! -d $classesdir ] ; then
  mkdir $classesdir;
fi

echo "Building search library ...."
( cd $EKKITAB_HOME/java/build; ant -f build.xml )
echo "Copying search library to tomcat location ...."
( cd $EKKITAB_HOME/java/bin; cp ekkitabsearch.jar $searchlib/ekkitabsearch.jar ) 
echo "Deleting old lucene jar file that came with JavaBridge distribution..."
rm -f $searchlib/lucene.jar 
echo "Copying missing libraries to tomcat location ..."
( 
   cd $EKKITAB_HOME/java/lib; for i in *.jar ; 
   do 
        f=${i%%-*};
        if [ $f == "lucene" ] || [ $f == "log4j" ]; then 
            if [ ! -f $searchlib/$i ] ; then 
                echo "Copying $i to Tomcat JavaBridge library."; 
                cp $i $searchlib/$i
            fi 
        fi 
   done 
)
( 
   cd $EKKITAB_HOME/java/bin; for i in *.properties ; 
   do 
      if [ ! -f $classesdir/$i ] ; then 
         echo "Copying $i to classes directory."; 
         cp $i $classesdir/$i
      fi 
   done 
)

