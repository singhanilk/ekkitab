<?php
// This is not a generic script! It has been written for very specific input and in order to generate
// very specific output.
// This script takes, as input, a file which contains book data. One line per book and ISBN in field 3. 
// It then uses the googlebooks API to search for this book and extract information.
// GoogleBooks API has a quote on how many times the API can be used in one session. So on a large input
// file, this will reach the "API Quote Exceeded" error frequently. The script when re-invoked determines
// the last successful ISBN processed and continues from there.
// Whatever information that is fetched through the API is written out to a file in tab separated format.

error_reporting(E_ALL  & ~E_NOTICE);
ini_set("display_errors", 1); 
define (OUTPUT_FILE, "PenguinBooks-googledata-import.txt");
$ekkitabhome = getenv("EKKITAB_HOME");
if (empty($ekkitabhome)) {
   echo "EKKITAB_HOME is not set. Cannot continue.\n";
   exit(1);
}
set_include_path(get_include_path() . PATH_SEPARATOR . $ekkitabhome . "/tools/ZendGdata-1.10.2/library");

    require_once 'Zend/Loader.php';
    Zend_Loader::loadClass('Zend_Gdata_Books');

    function printArray($elements, $separator = ",") {
        $result = '';
        foreach ($elements as $element) {
            if (!empty($result)) $result = $result.$separator;
            $result = $result.$element;
        }
        return $result;
    }

    function getBook($entry) {
        $book = array();

        if ($thumbnailLink = $entry->getThumbnailLink()) {
            $thumbnail = $thumbnailLink->href;
        } else {
            $thumbnail = "";
        }
        $book['image'] = $thumbnail;

        //$preview = $entry->getPreviewLink()->href;
        $book['title'] = htmlspecialchars_decode(printArray($entry->getTitles()), ENT_QUOTES);
        $book['author'] = htmlspecialchars_decode(printArray($entry->getCreators(), "&"), ENT_QUOTES);
        $book['description'] = htmlspecialchars_decode(printArray($entry->getDescriptions()), ENT_QUOTES);
        $book['publishdate'] = printArray($entry->getDates());
        $book['format'] = printArray($entry->getFormats());
        $book['language'] = printArray($entry->getLanguages());
        $book['subject'] = htmlspecialchars_decode(printArray($entry->getSubjects(), ":"), ENT_QUOTES);
        $book['publisher'] = htmlspecialchars_decode(printArray($entry->getPublishers()), ENT_QUOTES);

        return $book;
    }

    function getVolumeIds($feed) {
        $ids = array();
        foreach ($feed as $entry) {
            $volumeId = $entry->getVolumeId();
            if ($volumeId != null) {
                $ids[] = $volumeId;
            }
        }
        return $ids;
    }

    function getdetails($isbn) {
        $gbooks = new Zend_Gdata_Books();
        $query = $gbooks->newVolumeQuery("http://www.google.com/books/feeds/volumes");
        $query->setQuery($isbn);
        $query->setStartIndex(1);
        $query->setMaxResults(10);
        $query->setMinViewability("none");
        $feed = $gbooks->getVolumeFeed($query);

        $ids = getVolumeIds($feed);
        $books = array();
        foreach($ids as $id) {
            $entry = $gbooks->getVolumeEntry($id);
            $book = getBook($entry);
            $books[] = $book;
        }
        return $books;
    }

    function writebook($book) {
        static $fh = null;

	    if ($book == null) {
           if ($fh) {
                fclose($fh);
                $fh = null;
           }
           return;
	    }

        if ($fh == null) {
            $fh = fopen(OUTPUT_FILE, "a"); 
            if (!$fh) {
                echo("Could not open output file: PenguinBooks-googledata-import.txt");
                exit(1);
            }
        }
        fprintf($fh, "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n",
                      empty($book['isbn']) ? "--" : $book['isbn'],  
                      empty($book['isbn10']) ? "--" : $book['isbn10'],  
                      empty($book['title']) ? "--" : $book['title'],  
                      empty($book['author']) ? "--" : $book['author'],  
                      empty($book['description']) ? "--" : $book['description'],  
                      empty($book['publishdate']) ? "--" : $book['publishdate'],  
                      empty($book['format']) ? "--" : $book['format'],  
                      empty($book['publisher']) ? "--" : $book['publisher'],  
                      empty($book['subject']) ? "--" : $book['subject'],  
                      empty($book['language']) ? "--" : $book['language'],  
                      empty($book['listprice']) ? "--" : $book['listprice'],  
                      empty($book['currency']) ? "--" : $book['currency'],  
                      empty($book['source']) ? "--" : $book['source'],  
                      empty($book['infosource']) ? "--" : $book['infosource'],
                      empty($book['indianpublisher']) ? "--" : $book['indianpublisher']);  
    } 

    function getLastProcessedISBN() {
        $fh = fopen(OUTPUT_FILE, "r");
        $lastline = null;
        if ($fh) {
             while ($line = fgets($fh)) {
                $lastline = $line;
             }
             fclose($fh);
	    }
        if ($lastline != null) {
            $isbn = trim(substr($lastline,0, strpos($lastline, "\t")));
        }
        else 
            $isbn = null;

        return $isbn;
    }

    function start($argc, $argv) {
        $start = (float) array_sum(explode(' ', microtime()));
        $fh = fopen($argv[1], "r"); 
        if (!$fh) {
            echo("Could not open data file: $argv[1]");
            exit(1);
        }
        $lastprocessedisbn = getLastProcessedISBN();
        //if ($argc > 2) {
        //    $lastprocessedisbn = $argv[2];
        //}
        $count = 0;
        $enriched = 0;
        $message = "Skipping until last processed isbn ... $lastprocessedisbn";
        while ($line = fgets($fh)) {
            if (!strcmp(substr($line, 0, 1), "#")) {
                continue;
            }
            $line = str_replace("\n", "", $line);
            $count++;
            $datafetched = false;
            $fields = explode("\t", $line);
            $isbn = trim(str_replace("\"", "", $fields[3]));
            if ($lastprocessedisbn != null) {
                echo "$message"; 
                $message = ".";
                if (!strcmp($lastprocessedisbn, $isbn)) {
                    $lastprocessedisbn = null;
                    echo "\n";
                }
                continue;
            }
            try {
                $books = getdetails(trim(str_replace("\"", "", $fields[3])));
            }
            catch (Exception $e) {
                echo "Data fetch exception: " . $e->getMessage() . "\n";
	            if (strpos($e->getMessage(), "API quota on volume feeds") > 0) {
	                echo "Detected quota limit reached. Exiting...\n";
                    exit(1);
                }
                $books = array();
            }
            foreach ($books as $book) {
                if (!empty($book['title'])) {
                   $datafetched = true; 
                }
                $book['isbn'] = trim(str_replace("\"", "", $fields[3]));
                if (strlen($book['isbn']) == 13) {
                    $book['isbn10'] = substr($book['isbn'], 3);
                }
                else {
                    $book['isbn10'] = $book['isbn'];
                }
                if (empty($book['title']) && (!empty($fields[4]))) {
                    $book['title'] = trim(str_replace("\"", "", $fields[4]));
                } 
                if (empty($book['author']) && (!empty($fields[5]))) {
                    $book['author'] = trim(str_replace("\"", "", $fields[5]));
                } 
                if (!empty($fields[1])) {
                    $book['indianpublisher'] = trim(str_replace("\"", "", $fields[1]));
                }
                if (empty($book['publisher']) && (!empty($book['indianpublisher']))) {
                    $book['publisher'] = $book['indianpublisher'];
                } 
                if (!empty($fields[6])) {
                    $book['listprice'] = trim(str_replace("\"", "", $fields[6]));
                } 
                if (!empty($fields[7])) {
                    $book['currency'] = trim(str_replace("\"", "", $fields[7]));
                } 

                if (!empty($fields[0])) {
                    $book{'infosource'}  = trim(str_replace("\"", "", $fields[0]));
                }

                $book['source'] = "India";

                writebook($book);
            }
            if ($datafetched == true) {
                $enriched++;
            }
            if (($count % 100) == 0) {
                $stop = (float) array_sum(explode(' ', microtime()));
                echo "$count books processed. [".$enriched."] have been enriched.\n";
                echo "Time elapsed: "  . sprintf("%.2f", ($stop - $start)/60) . " minutes.\n"; 
            }
        }
        writebook(null);
        $stop = (float) array_sum(explode(' ', microtime()));
        echo "$count books processed. [".$enriched."] have been enriched.\n";
        echo "Time elapsed: "  . sprintf("%.2f", ($stop - $start)/60) . " minutes.\n"; 
    }

    if ($argc == 1) {
       echo "Usage: $argv[0] <Data File>\n";
       exit(1);
    }

    start($argc, $argv);


?>

