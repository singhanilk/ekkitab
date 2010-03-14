<?php
error_reporting(E_ALL  & ~E_NOTICE);
ini_set("display_errors", 1); 
ini_set(include_path, ${include_path}."/home/vijay/downloads/ZendGdata-1.10.2/library");

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

        $book['title'] = printArray($entry->getTitles());
        $book['author'] = printArray($entry->getCreators());
        $book['description'] = printArray($entry->getDescriptions());
        $book['publishdate'] = printArray($entry->getDates());
        $book['format'] = printArray($entry->getFormats());
        $book['language'] = printArray($entry->getLanguages());
        $book['subject'] = printArray($entry->getSubjects(), ":");
        $book['publisher'] = printArray($entry->getPublishers());

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

        if ($fh == null) {
            $fh = fopen("bookdata.txt", "a"); 
            if (!$fh) {
                echo("Could not open output file: bookdata.txt");
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

    function start($argc, $argv) {
        $start = (float) array_sum(explode(' ', microtime()));
        $fh = fopen($argv[1], "r"); 
        if (!$fh) {
            echo("Could not open data file: $argv[1]");
            exit(1);
        }
        $lastprocessedisbn = null;
        if ($argc > 2) {
            $lastprocessedisbn = $argv[2];
        }
        $count = 0;
        $enriched = 0;
        $message = "Skipping until last processed isbn ...";
        while ($line = fgets($fh)) {
            if (!strcmp(substr($line, 0, 1), "#")) {
                continue;
            }
            $line = str_replace("\n", "", $line);
            $count++;
            $datafetched = false;
            $fields = explode("\t", $line);
            $isbn = trim(str_replace("\"", "", $fields[0]));
            if ($lastprocessedisbn != null) {
                echo "$message"; 
                $message = ".";
                if (!strcmp($lastprocessedisbn, $isbn)) {
                    $lastprocessedisbn = null;
                }
                continue;
            }
            try {
                $books = getdetails($fields[0]);
            }
            catch (Exception $e) {
                echo "Data fetch exception: " . $e->getMessage() . "\n";
                $books = array();
            }
            foreach ($books as $book) {
                if (!empty($book['title'])) {
                   $datafetched = true; 
                }
                $book['isbn'] = trim(str_replace("\"", "", $fields[0]));
                if (strlen($book['isbn']) == 13) {
                    $book['isbn10'] = substr($book['isbn'], 3);
                }
                else {
                    $book['isbn10'] = $book['isbn'];
                }
                if (empty($book['title']) && (!empty($fields[1]))) {
                    $book['title'] = trim(str_replace("\"", "", $fields[1]));
                } 
                if (empty($book['author']) && (!empty($fields[2]))) {
                    $book['author'] = trim(str_replace("\"", "", $fields[2]));
                } 
                if (!empty($fields[5])) {
                    $book['indianpublisher'] = trim(str_replace("\"", "", $fields[5]));
                }
                if (empty($book['publisher']) && (!empty($book['indianpublisher']))) {
                    $book['publisher'] = $book['indianpublisher'];
                } 
                if (!empty($fields[3])) {
                    $book['listprice'] = trim(str_replace("\"", "", $fields[3]));
                } 
                if (!empty($fields[4])) {
                    $book['currency'] = trim(str_replace("\"", "", $fields[4]));
                } 

                if (!empty($fields[6])) {
                    $book{'infosource'}  = trim(str_replace("\"", "", $fields[6]));
                }

                $book['source'] = "India";

                /*
                if (!empty($book['currency'])) {
                    switch (substr($book['currency'], 0, 1)) {
                        case 'I' :
                        case 'i' :  $book['source'] = "India";
                                    break;
                        case 'P' :
                        case 'p' :  $book['source'] = "England";
                                    break;
                        case 'U' :
                        case 'u' :  $book['source'] = "USA";
                                    break;
                        default:    $book['source'] = "India";
                                    break;
                    }
                }
                */
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

