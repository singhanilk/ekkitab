<?php

require_once("http://localhost:8080/JavaBridge/java/Java.inc");
$instances = java("com.ekkitab.search.BookSearch")->getRunningInstances();
echo "Number of instances = $instances\n";
$timer = java("com.ekkitab.search.BookSearch")->getTimer("basic");
if (!java_is_null($timer)) {
    echo "Basic Search:    " . $timer->getAverageTime() . " msec.(average) -- " . $timer->getMaxTime() . " msec.(max) -- " . $timer->getMinTime() . " msec.(min) \n";
}
$timer = java("com.ekkitab.search.BookSearch")->getTimer("categories");
if (!java_is_null($timer)) {
    echo "Category Search: " . $timer->getAverageTime() . " msec.(average) -- " . $timer->getMaxTime() . " msec.(max) -- " . $timer->getMinTime() . " msec.(min) \n";
}
?> 
