<?php
//
// This is an example of how you can can access a running Java VM
// to execute a Java class and get and use the returned results in PHP.
// This is very rough coding and has no proper exception handling. Beware!

if ($argc != 2) {
   echo "Usage: $argv[0] <Server> \n";
   exit(1);
}

$server = $argv[1];

require_once("http://".$server.":8080/JavaBridge/java/Java.inc");
$testqueries = array();
$testcategories = array();
$testresults = array();

$testqueries[] = "wonderful";
$testqueries[] = "accurate";
$testqueries[] = "";
$testqueries[] = "";
$testqueries[] = "master";

$testcategories[] = "";
$testcategories[] = "";
$testcategories[] = "art";
$testcategories[] = "architecture";
$testcategories[] = "art";

$testresults[] = "14";
$testresults[] = "4";
$testresults[] = "328";
$testresults[] = "282";
$testresults[] = "1";

$maxtime = 0;

for ($testi = 0; $testi < 1000; $testi++) {

   for ($testj = 0; $testj < 5; $testj++) {
        $search = new java("BookSearch", "/var/www/scm/magento/search_index_dir");
        $query = $testqueries[$testj];
        $category = $testcategories[$testj];
        $page = "1";
        $pagenum = $page + 0;
        $page_sz = 15;

        $start = (float) array_sum(explode(' ', microtime()));
        //echo "Search query: '".$query."'  category: '".$category."'  Page: '".$pagenum."'\n";
        $results = $search->searchBook($category, $query, $page_sz, $pagenum);
        $end = (float) array_sum(explode(' ', microtime()));
        $executetime = $end - $start;
        if ($executetime > $maxtime)
            $maxtime = $executetime;
        if ($results) {
            $hitcount = $results->get("hits");
            if ($hitcount != $testresults[$testj]) {
                echo "Returned: [".$hitcount."]  Expected[" . $testresults[$testj]. "]\n";
                echo "Test failed at iteration: $testi : $testj\n";
                exit (1);
            }
        }
   }
}  

echo "Test Passed. $testi iterations of $testj tests\n";
echo "Max. search time: ". sprintf("%.2f", $maxtime) . " seconds\n";

?> 
