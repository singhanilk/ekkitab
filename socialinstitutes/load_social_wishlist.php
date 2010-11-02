<?php

include "common_social_functions.php";

/* Social Institues wishlist format.
* admin_email_id	institute_email_id	isbn	title	author
*/
function formatValues($values) {
  $wishlistItem = Array();
  $i=0;
  // The value in this is an email
  $wishlistItem['admin_email_id'] = trim($values[$i++]);
  $wishlistItem['institute_email_id'] = trim($values[$i++]);
  $wishlistItem['isbn'] = trim($values[$i++]);
  $wishlistItem['title'] = trim($values[$i++]);
  $wishlistItem['author'] = trim($values[$i++]);

  $wishlistItem['customer_id'] = '';
  $wishlistItem['organization_id'] = '';
  $wishlistItem['wishlist_id'] = '';
  $wishlistItem['shared'] = '';
  $wishlistItem['sharing_code'] = '';
  $wishlistItem['wishlist_item_id'] = '';
  $wishlistItem['product_id'] = '';
  $wishlistItem['store_id'] = '';
  $wishlistItem['description'] = '';

  return $wishlistItem;
  
}
/** Takes an wishlist and validates the sane.
at the same time populates it also if no error 
*/
function validateWishlistItem($db, $line, &$wishlist){
   $errorList = Array();

   if ( $wishlistItem == null || empty($wishlistItem) ) { 
    $errorList[] = "Line $line Institute values are empty"; return $errorList; 
   }

   if ( $wishlistItem['admin_email_id'] == null || empty($wishlistItem['admin_email_id'])){ 
    $errorList[] = "Line $line Admin email id is mandatory"; 
   } else { 
    // Check the admin_email_id in the database.
    $customerId = getAdminId($db, $wishlistItem['admin_email_id']);

    if ( $customerId ) { $wishlistItem['customer_id'] = $customerId; }
    else { $errorList[] = "Line $line customer not present";  }

   } 

   if ( $wishlistItem['institute_email_id'] == null || empty($wishlistItem['institute_email_id'])){ 
    $errorList[] = "Line $line Institute Email Id is mandatory"; 
   } else {
     $organizationId = getInstituteId($db, $wishlistItem['institute_email_id']);
     if ( $organizationId ) { $wishlistItem['organization_id'] = $organizationId; }
     else { $errorList[] = "Line $line Institute not present";  }
   }
   $isbn = $wishlistItem['isbn'];
   if ( $isbn == null || empty($isbn) || strlen($isbn) != 13 || strlen($isbn) != 10 ){ 
    $errorList[] = "Line $line ISBN is mandatory"; 
   } else {
       if ( strlen($isbn) == 10 ) { $isbn = isbn10to13($isbn); }
        $book =  getBookDetails($db,$isbn);
        if ( $book ) { 
         $wishlistItem['isbn'] = $isbn;
         $wishlistItem['product_id'] = $book['id']; 
        } else { 
         $errorList[] = "Line $line ISBN not present";  
        }
   }
   return $errorList;
}

function load_social_wishlist_start($argc, $argv) {
   global $EKKITAB_HOME;
   global $FIELD_SEPARATOR;

     if ($argc < 2) {
       echo "Usage: $argv[0] <file with wish list books >\n";
       exit(1);
    }

    $wishlistFilename = $argv[1];
    $wishlistFile = fopen($wishlistFilename, "r") or die ("Cannot open $wishlistFilename\n");
    $config = parse_ini_file("$EKKITAB_HOME/config/ekkitab.ini", true);
    $db = initDatabase($config);
    $wishList = Array();

    while (!feof($wishlistFile)){ 
     $tmpString = fgets($wishlistFile);   
     if ( $tmpString == null ) { break; }

     // If the line starts with a # skip the same.
     if(strpos($tmpString,"#") !== false) continue;

     $values = explode($FIELD_SEPARATOR, $tmpString);
     $wishlist[] = formatValues($values);
    }
    fclose($wishlistFile);
    $validWishlist = Array();
    foreach($wishlist as $wishlistItem) {
      $errorList = validateWishlistItem($db, &$wishlistItem);
      if ( $errorList != null || !empty($errorList)) { print_r($errorList); } 
      else { $validWishList[] = $wishlistItem; }
    }

    $customerIdOrganizationIdList = Array();
    $wishlistEntry = null;
    foreach($validWishList as $wishlistItem ) {
      $wishlistEntry = null;
      $key = $wishlistItem['customer_id'] . "_" . $wishlistItem['organization_id'];
      if ( ! array_key_exists($key, $customerIdOrganizationIdList)) {
        $wishlistEntry = getWishlistEntry($db, $wishlistItem['customer_id'], $wishlistItem['organization_id']);
        if ( $wishlistEntry == null ) { 
          // Create Wishlist entry 
           $wishlistEntry = addWishlistEntry($db, $wishlistItem['customer_id'], $wishlistItem['organization_id']);
        } 
        $customerIdOrganizationIdList[$key] = $wishlistEntry;
      } 
      $wishlistItem['wishlist_id'] = $customerIdOrganizationIdList[$key]['wishlist_id'];
      $wishlistItem['shared'] = $customerIdOrganizationIdList[$key]['shared'];
      $wishlistItem['sharing_code'] = $customerIdOrganizationIdList[$key]['sharing_code'];
      addWishlistItem($wishlistItem);
    } // for each wishlist entry
    closeDatabase($db);
}

load_social_wishlist_start($argc, $argv);

?>
