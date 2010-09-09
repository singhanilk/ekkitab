<?php
/*
	Generator for the global sections 
	Author - Prasad Potula 
	Date   - 07/September/2010
	Description 
  1. Sections.ini file has the list of files which should be read
  2. Individual ini files are ones which contain titles, descriptions and other attributes
  3. And the list of isbns
  Dependencies
   Configuration file updatecatalog.ini
*/

# The field separator is a tab
$EKKITAB_HOME= getenv("EKKITAB_HOME");
$sectionXML;
$sectionSearchArray;
/*
** Writes the section data to both the globalsections.xml and globalsections.ini
**/
function writeXML($section, $fileHandle){
  global $sectionXML;
  global $sectionSearchArray;

  foreach ($sectionSearchArray as $item ){
    $replace[] = $section[$item];
  }
  $finalSectionXML = str_replace($sectionSearchArray, $replace, $sectionXML);
  fwrite($fileHandle, $finalSectionXML);
}

function writeINI($title, $isbns, $fileHandle){
  $iniString = "\n[$title]\n";
  $iniString .= "isbns=". $isbns. "\n";

  fwrite($fileHandle, $iniString);
}

/* Main function for catalogs */
function sectionsgenerator_start($argc, $argv) {
   global $EKKITAB_HOME;
   global $sectionXML;
   global $sectionSearchArray;

   $sectionXML='<SECTION id="SECTION_ID" title="SECTION_TITLE" displayOnHome="SECTION_DISPLAY_ON_HOME" activeFrom="SECTION_ACTIVE_FROM" activeTo="SECTION_ACTIVE_TO">
                 <DESCRIPTION>SECTION_DESCRIPTION</DESCRIPTION>
                 <HOMEPAGE_TEMPLATE_PATH>SECTION_HOMEPAGE_TEMPLATE_PATH</HOMEPAGE_TEMPLATE_PATH>
                 <BOOKSPAGE_TEMPLATE_PATH>SECTION_BOOKSPAGE_TEMPLATE_PATH</BOOKSPAGE_TEMPLATE_PATH>
                </SECTION>';

   $sectionSearchArray = array('SECTION_ID','SECTION_TITLE','SECTION_DISPLAY_ON_HOME',
                  'SECTION_ACTIVE_FROM','SECTION_ACTIVE_TO','SECTION_DESCRIPTION',
                  'SECTION_HOMEPAGE_TEMPLATE_PATH', 'SECTION_BOOKSPAGE_TEMPLATE_PATH');
   $sectionId = 1;
   //Parse the main ini file
   $configArray = parse_ini_file("sections.ini", true); 

   //Global xml file and global ini files 
   $tmpString = $EKKITAB_HOME.$configArray["paths"]["GLOBAL_XML_FILE"];
   $globalSectionsXMLFile = fopen($tmpString, "w") or die ("Cannot open" . $tmpString . "\n");

   $tmpString = $EKKITAB_HOME.$configArray["paths"]["GLOBAL_INI_FILE"];
   $globalSectionsINIFile = fopen($tmpString, "w") or die ("Cannot open" . $tmpString . "\n");

   fwrite($globalSectionsXMLFile, "<GLOBALSECTIONS>\n"); 
   foreach( $configArray["sections"] as $sectionFileName){
      // Parse the specific section file
      $sectionFileName = $EKKITAB_HOME.$configArray["paths"]["SECTIONS_DIRECTORY"].$sectionFileName . ".ini";
      // Read the section's ini file.
      $sectionConfigArray = parse_ini_file($sectionFileName, true); 
      // Read the section part for the variables.
      $section = $sectionConfigArray['section'];
      // Read the isbns part
      $isbnArray = $sectionConfigArray['isbns'];
      $isbns = implode(",", array_keys($isbnArray));

      $section['SECTION_ID'] = $sectionId;
      foreach($sectionSearchArray as $item ) {
       if(!array_key_exists($item, $section)) {
          $section[$item] = $configArray["details"]["DEFAULT_".$item];
       } elseif( $section[$item] == "" ) {
          $section[$item] = $configArray["details"]["DEFAULT_".$item];
       }
      }
      writeXML($section, $globalSectionsXMLFile);
      writeINI($section['SECTION_TITLE'], $isbns, $globalSectionsINIFile);
      $sectionId++;
   }

  fwrite($globalSectionsXMLFile, "\n</GLOBALSECTIONS>"); 
  fclose($globalSectionsXMLFile);
  fclose($globalSectionsINIFile);
}

sectionsgenerator_start($argc, $argv);

?>
