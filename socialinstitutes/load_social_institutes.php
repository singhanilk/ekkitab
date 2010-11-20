<?php

include "common_social_functions.php";

/* Social Institues 
* name	type	street	locality	city	state	postcode	country_id	website_url	telephone	aboutus	aboutus_summary	is_html	image
*/

/* Format of the institute text file is as follows.
#name	admin_email_id	admin_first_name	admin_last_name	admin_password	email	password	type	street	locality	city	state	postcode	country	website_url	telephone	aboutus	aboutus_summary	is_html	image
*/
function formatValues($values) {
  $institute = Array();
  $i=0;
  $institute['name'] = $values[$i++];
  $institute['admin_email_id'] = $values[$i++];
  $institute['admin_id'] = '';
  $institute['admin_first_name'] = $values[$i++];
  $institute['admin_last_name'] = $values[$i++];
  $institute['admin_password'] = $values[$i++];
  $institute['email'] = $values[$i++];
  $institute['password'] = $values[$i++];
  $institute['type'] = $values[$i++];
  // Need to get it from database.
  $institute['type_id'] = '1';
  $institute['street'] = $values[$i++];
  $institute['locality'] = $values[$i++];
  $institute['city'] = $values[$i++];
  $institute['state'] = $values[$i++];
  $institute['postcode'] = $values[$i++];
  $institute['country'] = $values[$i++];
  $institute['country_id'] = 1;
  $institute['website_url'] = $values[$i++];
  $institute['telephone'] = $values[$i++];
  $institute['aboutus'] = $values[$i++];
  $institute['aboutus_summary'] = $values[$i++];
  $institute['is_html'] = $values[$i++];
  $institute['image'] = $values[$i++];
  $institute['any_donation'] = $values[$i++];
  $institute['is_valid'] = 1;
  $institute['created'] = '';
  $institute['modified'] = '';
  
  return $institute;
  
}
function validateInstitute($institute){
   $errorList = Array();
   if ( $institute == null || empty($institute) ) { $errorList[] = "Institute values are empty"; return $errorList; }
   if ( $institute['name'] == null || empty($institute['name'])){ $errorList[] = "Name is empty"; }
   if ( $institute['admin_email_id'] == null || empty($institute['admin_email_id'])){ $errorList[] = "Admin Email Id is mandatory"; }
   if ( $institute['type'] == null || empty($institute['type'])){ $errorList[] = "Type is mandatory"; }
   if ( $institute['type_id'] == null || empty($institute['type'])){ $errorList[] = "Type not recognized"; }
   if ( $institute['street'] == null || empty($institute['street'])){ $errorList[] = "Street is mandatory"; }
   if ( $institute['city'] == null || empty($institute['city'])){ $errorList[] = "City is mandatory"; }
   if ( $institute['state'] == null || empty($institute['state'])){ $errorList[] = "State is mandatory"; }
   if ( $institute['postcode'] == null || empty($institute['postcode'])){ $errorList[] = "Postcode is mandatory"; }
   if ( $institute['country'] == null || empty($institute['country'])){ $errorList[] = "Country is mandatory"; }
   if ( $institute['telephone'] == null || empty($institute['telephone'])){ $errorList[] = "Telephone is mandatory"; }
   return $errorList;
}


function addInstitute($db, $institute) {

  // Check if the admin is already present if yes and populate the id else create the same.
  $adminId = getAdminId($db, $institute['admin_email_id']); 
  if ( $adminId == null ) {
     // Create the admin entity.
     $adminId = createCustomerEntity($db, $institute['admin_email_id'], $institute['admin_password'], 
                               $institute['admin_first_name'], $institute['admin_last_name']);
    
     $institute['admin_id'] = $adminId;
  }else { 
     print "Admin already present\n";
     $institute['admin_id'] = $adminId;
  }
  // Create an dummy entity for this institute
  createCustomerEntity($db, $institute['email'], $institute['password'], $institute['name'], "");

  try {
  $query = "insert into ek_social_institutes (name, email, type_id, street, locality, city, " . 
            "state, postcode, country_id, website_url,telephone, aboutus,aboutus_summary,is_html, image, is_valid, any_donation, admin_id, created, modified ) ".
            "values ( '" .  $institute['name'] . "'"
            . ",'" . $institute['email'] . "'"
            . "," . $institute['type_id'] . ""
            . ",'" . $institute['street'] . "'"
            . ",'" . $institute['locality'] . "'"
            . ",'" . $institute['city'] . "'"
            . ",'" . $institute['state'] . "'"
            . ",'" . $institute['postcode'] . "'"
            . ",'" . $institute['country_id'] . "'"
            . ",'" . $institute['website_url'] . "'"
            . ",'" . $institute['telephone'] . "'"
            . ",'" . $institute['aboutus'] . "'"
            . ",'" . $institute['aboutus_summary'] . "'"
            . ",'" . $institute['is_html'] . "'"
            . ",'" . $institute['image'] . "'"
            . "," . $institute['is_valid'] . ""
            . "," . $institute['any_donation'] . ""
            . "," . $institute['admin_id'] . ""
            . ", now(), now());";
   print $query;
   $result = mysqli_query($db,$query);
   if (!$result) { print "addInstitue:quey=$query failed\n"; }
  } catch(exception $e) {
    print "Exception message=$e->getmessage()";
  }
 return $institute;
}
  
function load_social_institutes_start($argc, $argv) {
   global $EKKITAB_HOME;
   global $FIELD_SEPARATOR;
   $generatedBisacCode = "";
   $uniqueISBN = Array();
   $isbnNotFoundBisacMap = Array();

     if ($argc < 2) {
       echo "Usage: $argv[0] <file with social institutes details>\n";
       exit(1);
    }

    $socialInstitutesFileName = $argv[1];
    $socialInstitutesFile = fopen($socialInstitutesFileName, "r") or die ("Cannot open $socialInstitutesFileName\n");
    $config = parse_ini_file("$EKKITAB_HOME/config/ekkitab.ini", true);
    $db = initDatabase($config);
    while (!feof($socialInstitutesFile)){ 
     $tmpString = fgets($socialInstitutesFile);   
     if ( $tmpString == null ) { break; }

     // If the line starts with a # skip the same.
     if(strpos($tmpString,"#") !== false) continue;

     $values = explode($FIELD_SEPARATOR, $tmpString);
     $institute = formatValues($values);
     // Check the database if the institute and postcode have already been entered if yes continue 
     $errorList = validateInstitute($institute);
     if ( $errorList != null || !empty($errorList)) { print_r($errorList); continue; } 

     if ( institutePresent($db,$institute, true)){
      $errorList[] = "Institute:". $institute['name'] . " already exists\n";
      print_r($errorList);
      continue;
     }
     $institute = addInstitute($db, $institute);
     print_r($institute);
    }
    fclose($socialInstitutesFile);
    closeDatabase($db);
}

load_social_institutes_start($argc, $argv);

?>
