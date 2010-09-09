<?php

/* program to enable the operations team to check isbn both in the books table in reference database and the missing isbn list.
*  Also displays all the preorders in the system.
*  This utility is to be copied under EKKITAB_URL/magento/internalutils/ ONLY FOR STAGING.
*/

$database_server    = 'localhost';
$database_user      = 'root';
$database_password  = 'root';
$ekkitab_db 				= 'ekkitab_books';
$ref_db     				= 'reference';
$db = NULL;
$GENERIC_BISAC_CODE='ZZZ000000';
$isbnno = '';
$displayString = '';

/* Function to write both stdout and file */
function logMessage($logFile, $outputString){
	print_r($outputString);
	fwrite($logFile, $outputString);
}

function initDatabase(){

	global $database_server;
	global $database_user;
	global $database_password;
  global $ref_db;
  global $db;

	#print_r("Database server=" . $database_server . ":Database user=" . $database_user . "Database password=" . $database_password . "\n");
	try  {
		$db = mysqli_connect($database_server,$database_user,$database_password,$ref_db);
	} catch (exception $e) {
		fatal($e->getmessage());
	}
	$query = "set autocommit = 0";
	try {
	 $result = mysqli_query($db,$query);
	 if (!$result) {
		 fatal("Failed to set autocommit mode.");
	 }
	} catch(exception $e) {
		fatal($e->getmessage());
	}
	 return $db;
}

function queryDatabase($sqlQuery) {
   global $db;
   $query_result = mysqli_query($db, $sqlQuery);
   if ( !$query_result ){
      $message = 'Invalid query: '. mysql_error() ."\n";
      $message .= 'Query: ' . $sqlQuery;
      die($message);
   }
  for ( $i = 0; $query_array[$i] = mysqli_fetch_assoc($query_result); $i++);
  array_pop($query_array);
  mysqli_free_result($query_result);
  return $query_array;
}

function checkBooksTable($isbnno) {

    $db = initDatabase();
    $sqlQuery = "select * from books where isbn = '$isbnno';";
	  $bookResult = queryDatabase($sqlQuery);
    return $bookResult;
}

function checkMissingIsbnsTable($isbnno) {
    $db = initDatabase();
    $sqlQuery = "select * from missing_isbns where isbn = '$isbnno';";
	  $bookResult = queryDatabase($sqlQuery);
    return $bookResult;
}

function checkpreorder($preorder) {
    $db = initDatabase();
    $sqlQuery = "select isbn, title, author from books where in_stock = '$preorder' and id < 150000;";
	  $bookResult = queryDatabase($sqlQuery);
    return $bookResult;
}
function createForm($isbnno, $displayString){

  $htmlString = "<html>
                 <body>
                 <h4> Please enter an ISBN No. ( Checks the Reference.books table, Reference. )</h4>
                  <table border='0'>
                   <tr>
                    <td>
                     <form action='isbncheck.php' method='get'>
                        <input type='text' name ='isbnno' size='30' value='$isbnno' />
                        <input type='submit' value='GO' />
                        <br>
                        <br>
                     </form>
                     </td>
                    <td>
                     <form action='isbncheck.php' method='get'>
                        <input type='hidden' name ='preorder' value='2' />
                        <input type='submit' value='All Pre-orders' />
                        <br>
                        <br>
                     </form>
                    </td>
                    </tr>
                    <tr>
                     <td colspan='2'>
                      $displayString
                     </td>
                    </tr>
                   </table>
                  </body>
                 </html>";
 return $htmlString;
}

if(isset($_GET['isbnno'])) { $isbnno = $_GET['isbnno']; } elseif(isset($_POST['isbnno'])) { $isbnno = $_POST['isbnno']; } else { $isbnno = ""; }
if(isset($_GET['preorder'])) { $preorder = 2; } elseif(isset($_POST['preorder'])) { $preorder = 2; }

if ($preorder != ''){
        $preorderesult = checkpreorder($preorder);
        $displayString .= "<table border=1>";
        $displayString .= "<tr><td>ISBN</td><td>Title</td><td>Author</td></tr>";
        foreach ( $preorderesult as $book ) {
            $displayString .= "<tr>";
            foreach ( $book as $key => $value ) {
                $displayString .= "<td>$value</td>";
            }
          $displayString .= "</tr>";
        }
       $displayString .= "</table>";
}

if ( $isbnno != '' ){
  // Check the reference books table.
  $booksResult = checkBooksTable($isbnno);
  if ( $booksResult != null ) {
  $displayString = "<h5>The book information exists. If the list price is 0 or empty, we have not received the price/stock information for the book.( Reference.books )</h5>";
  foreach ( $booksResult as $book ) {
    $displayString .= "<table border=1>";
    foreach ( $book as $key => $value ) {
     $displayString .= "<tr><td>$key</td><td>$value</td></tr>";
    }
    $displayString .= "</table>";
  }
 } else {
  $displayString = '<h5>The book information does not exists</h5>';
 }

  //Check the missing isbns table.
  $booksResult = checkMissingIsbnsTable($isbnno);
  if ( $booksResult != null ) {
  $displayString .= "<h5>The book information does not exists but we are getting the price/stock information for the book. Missing ISBN(Reference.missing_isbns)</h5>";
  foreach ( $booksResult as $book ) {
    $displayString .= "<table border=1>";
    foreach ( $book as $key => $value ) {
     $displayString .= "<tr><td>$key</td><td>$value</td></tr>";
    }
    $displayString .= "</table>";
  }
 } else {
  $displayString .= '<h5>The book is not listed under missing isbns</h5>';
 }
}
echo createForm($isbnno, $displayString);

 
?>

