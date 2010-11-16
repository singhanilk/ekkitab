<?php

include "../bin/convertisbn.php";

/* Social Institues 
* name	type	street	locality	city	state	postcode	country_id	website_url	telephone	aboutus	aboutus_summary	is_html	image
*/

// Set the EKKITAB_HOME
$EKKITAB_HOME= getenv("EKKITAB_HOME");
/* The field separator is a tab */
$FIELD_SEPARATOR = "\t";

function initDatabase($config){

  if (! $config) return NULL;

  $database_server = $config["database"]["server"];
  $database_user   = $config["database"]["user"];
  $database_psw    = $config["database"]["password"];
  $ekkitab_db      = $config["database"]["ekkitab_db"];
  $ref_db          = $config["database"]["ref_db"];
  $db  = NULL;
  #print_r("Database server=" . $database_server . ":Database user=" . $database_user . "Database password=" . $database_psw . "\n");
  try  {
    $db = mysqli_connect($database_server,$database_user,$database_psw,$ekkitab_db);
  } catch (exception $e) {
    print $e->getmessage();
  }
  $query = "set autocommit = 0";
  try {
   $result = mysqli_query($db,$query);
   if (!$result) {
     print "Failed to set autocommit mode.";
   }
  } catch(exception $e) {
    print $e->getmessage();
  }
   return $db;
}

function closeDatabase($db){
   mysqli_commit($db);
   mysqli_close($db);
}

/** FUNCTIONS ARE BORROWED FROM bin/generate_customer_entity **/

function getHash($password) {
		$len=2;
		$chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        mt_srand(10000000*(double)microtime());
        for ($i = 0, $str = '', $lc = strlen($chars)-1; $i < $len; $i++) {
            $str .= $chars[mt_rand(0, $lc)];
        }
		return $str === false ? md5($password) : md5($str . $password) . ':' . $str;
}

/* Method to generate the email id for the institute */
function generateInstituteEmailId($institute){

 if ( $institute == null ) return "";
 if ( $institute['name'] == null or empty($institute['name']) ) return "";

 if ( $institute['postcode'] == null or empty($institute['postcode']) ) return "";

 $tmpString = str_replace(" ", "", $institute['name']);
 $tmpString = substr($tmpString, 0, 10 );
 $email = $tmpString."_".trim($institute['postcode'])."@ekkitab.com";
 return $email;
}

/** Retrieve sharing code (random string)
* @return string
*/
function getWishlistSharingRandomCode(){
  return md5(microtime() . rand());
}

function getMaxCustomerEntityId($db) {
    if ($db == null) { 
       print "Fatal: Could not connect to database.";
       exit(1);
    }
	$query = "select max(`entity_id`) from `customer_entity` ;";
	$entityId=0;
	try {
	   $result = mysqli_query($db, $query);
		if ($result && (mysqli_num_rows($result) > 0)) {
			$row = mysqli_fetch_array($result);
			$entityId = $row[0];
		}
	}
	catch (Exception $e) {
	   print "Fatal: SQL Exception. $e->getMessage()\n"; 
	   exit(1);
	}

	return ($entityId+1);
}

function getNextIncrementId($db) {
    if ($db == null) { 
       print "Fatal: Could not connect to database.";
       exit(1);
    }

	$query = "select increment_last_id from eav_entity_store where entity_type_id =1 and store_id=0 ;";
	$last='000000000';
	try {
	   $result = mysqli_query($db, $query);
		if ($result && (mysqli_num_rows($result) > 0)) {
			$row = mysqli_fetch_array($result);
			$last = (string)$row[0];
		}
	}
	catch (Exception $e) {
	   print "Fatal: SQL Exception. $e->getMessage()\n"; 
	   exit(1);
	} 
	$last = (int)$last ;
	return ($last+1);
}

function getAdminId($db,$email) {
  $entityId = null;

  $query = "select entity_id from `customer_entity` where email='".$email."' ;";
  try {
     $result = mysqli_query($db, $query);
    if ($result && (mysqli_num_rows($result) > 0)) {
      $row = mysqli_fetch_assoc($result);
      $entityId = $row['entity_id'];
    }
  } 
catch (Exception $e) {
     print "Fatal: SQL Exception. $e->getMessage()\n";
     $entityId = null;
  }
  return $entityId;
}

function getInstituteId($db, $email){
  $instituteId = null;

  $query = "select id from `ek_social_institutes` where email='".$email."' ;";
  try {
     $result = mysqli_query($db, $query);
    if ($result && (mysqli_num_rows($result) > 0)) {
      $row = mysqli_fetch_assoc($result);
      $instituteId = $row['id'];
    }
  } 
catch (Exception $e) {
     print "Fatal: SQL Exception. $e->getMessage()\n";
     $instituteId = null;
  }
  return $instituteId;
  
}

function institutePresent($db,$institute, $checkType){
  $present = true;

  if ( $checkType ) {
   $query = "select name from ek_social_institutes where name ='" . $institute['name'] . "' and type_id = " . $institute['type_id'] ;
  } else {
   $query = "select name from ek_social_institutes where name ='" . $institute['name'] . "'"; 
  }
  try {
   $result = mysqli_query($db,$query);
   if (!$result) {
     print "Query $query failed";
   }else {
     $count = mysqli_num_rows($result);
     if ( $count == 0 ) { 
        $present = false; 
     }
   }
  } catch(exception $e) {
    print $e->getmessage();
  }
  return $present;
}

function createCustomerEntity($db, $email, $password, $firstName, $lastName) {
	$password = getHash(trim($password));
  $entityId = 	getMaxCustomerEntityId($db);
  $incrementId = 	getNextIncrementId($db);

  try {
	  $query = "INSERT INTO `customer_entity` (`entity_id`, `entity_type_id`, `attribute_set_id`, `website_id`, `email`, `group_id`, `increment_id`, `store_id`, `created_at`, `updated_at`, `is_active`) VALUE (".$entityId.",1, 0, 1, '".$email."', 1, '".$incrementId."', 1, '2010-07-07 06:42:03', '2010-07-07 09:56:03', 1);";
    mysqli_query($db, $query);

	$query = "INSERT INTO `customer_entity_varchar` (`entity_type_id`, `attribute_id`, `entity_id`, `value`) VALUES (1,5,".$entityId.",'".$firstName."'),(1,7,".$entityId.",'".$lastName."'),(1,3,".$entityId.",'Ekkitab'),(1,12,".$entityId.",'".$password."');";
    mysqli_query($db, $query);
  } catch (Exception $e) {
     print "Fatal: SQL Exception. $e->getMessage()\n";
     $entityId = null;
  }

	return $entityId;
}

function getBookDetails($db, $isbn) {
  $book = Array();
  $query = "select * from reference.books where isbn = '$isbn'";
  try {
   $result = mysqli_query($db,$query);
   if (!$result) { 
     $book = null; 
   } else { 
       $book= mysqli_fetch_array($result);
   }
  } catch(exception $e) {
    $book = null;
  }
  return $book; 
}

function getWishlistEntry($db, $customerId, $organizationId){
  $wishlistEntry = null;
  $query = "select * from ekkitab_books.wishlist where customer_id=$customerId and organization_id=$organizationId";
  try {
   $result = mysqli_query($db,$query);
   if (!$result) { 
     $wishlistEntry = null; 
   } else { 
       $wishlistEntry= mysqli_fetch_array($result);
   }
  } catch(exception $e) {
    $wishlistEntry = null;
  }
  return $wishlistEntry; 

}

function addWishlistEntry($db, $customerId, $organizationId){
  $wishlistEntry = null;
  $sharedCode = getWishlistSharingRandomCode();
  $query = "insert into wishlist ( customer_id, shared, sharing_code, organization_id ) values ( $customerId, 1, $sharedCode, $organizationId )";
  print $query;
  try {
   $result = mysqli_query($db,$query);
   if (!$result) { 
     $wishlistEntry = null; 
   } else { 
       $wishlistEntry= getWishListEntry($db,$customerId, $organizationId);
   }
  } catch(exception $e) {
    $wishlistEntry = null;
  }
  return $wishlistEntry; 
}

function addWishlistItem($db, $wishlistItem) {
  $query = "insert into wishlist_item ( wishlist_id, product_id, store_id, added_at, description,isbn ) values ( " .
           $wishlistItem['wishlist_id'] . "," .  $wishlistItem['product_id'] . ", 1, now(),'" .  $wishlistItem['description'] . "'," .  $wishlistItem['isbn']. ")";
  print $query . "\n";
  try {
   $result = mysqli_query($db,$query);
   if (!$result) { $wishlistItem = null; } 
  } catch(exception $e) {
    print $e->getMessage();
    $wishlistItem = null;
  }
 return $wishlistItem;
}
?>
