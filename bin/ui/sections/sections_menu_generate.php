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
$configArray=null;
$globalSectionsXMLFile=null;
$globalSectionsINIFile=null;
$sectionsDirectory=null;



function writeSections($sectionsArray){
  global $globalSectionsXMLFile;
  global $globalSectionsINIFile;
  global $sectionsDirectory;
  global $configArray;

   $sectionXML='<SECTION id="SECTION_ID" title="SECTION_TITLE" displayOnHome="SECTION_DISPLAY_ON_HOME" activeFrom="SECTION_ACTIVE_FROM" activeTo="SECTION_ACTIVE_TO">
                 <DESCRIPTION>SECTION_DESCRIPTION</DESCRIPTION>
                 <HOMEPAGE_TEMPLATE_PATH>SECTION_HOMEPAGE_TEMPLATE_PATH</HOMEPAGE_TEMPLATE_PATH>
                 <BOOKSPAGE_TEMPLATE_PATH>SECTION_BOOKSPAGE_TEMPLATE_PATH</BOOKSPAGE_TEMPLATE_PATH>
                </SECTION>';
   $sectionSearchArray = array('SECTION_ID','SECTION_TITLE','SECTION_DISPLAY_ON_HOME',
                  'SECTION_ACTIVE_FROM','SECTION_ACTIVE_TO','SECTION_DESCRIPTION',
                  'SECTION_HOMEPAGE_TEMPLATE_PATH', 'SECTION_BOOKSPAGE_TEMPLATE_PATH');
   $sectionId = 1;
   fwrite($globalSectionsXMLFile, "<GLOBALSECTIONS>\n"); 
   foreach( $sectionsArray as $sectionFileName){
      // Parse the specific section file
      $sectionFileName = $sectionsDirectory.$sectionFileName . ".ini";
      // Read the section's ini file.
      if( !file_exists($sectionFileName)){
        continue; 
      } 
      $sectionConfigArray = parse_ini_file($sectionFileName, true); 
      // Read the section part for the variables.
      $section = $sectionConfigArray['section'];
      // Read the isbns part
      $isbnArray = $sectionConfigArray['isbns'];
      $isbns = implode(",", array_keys($isbnArray));

      $section['SECTION_ID'] = $sectionId;
      foreach($sectionSearchArray as $item ) {
       if(!array_key_exists($item, $section)) {
          $section[$item] = $configArray["section_details"]["DEFAULT_".$item];
       } elseif( $section[$item] == "" ) {
          $section[$item] = $configArray["section_details"]["DEFAULT_".$item];
       }
       $replace[] = $section[$item];
      }

      $finalSectionXML = str_replace($sectionSearchArray, $replace, $sectionXML);
      fwrite($globalSectionsXMLFile, $finalSectionXML);

      $iniString = "\n[". $section['SECTION_TITLE']. "]\n";
      $iniString .= "isbns=". $isbns. "\n";
      fwrite($globalSectionsINIFile, $iniString);
      $sectionId++;
   }
  fwrite($globalSectionsXMLFile, "\n</GLOBALSECTIONS>"); 
}

/* Main function for catalogs */
function sections_menu_generate_start($argc, $argv) {
   global $EKKITAB_HOME;
   global $configArray;
   global $sectionsDirectory;
   global $globalSectionsXMLFile;
   global $globalSectionsINIFile;

   //Parse the main ini file
   $configArray = parse_ini_file("sections_menu.ini", true); 

   $sectionsDirectory = $EKKITAB_HOME.$configArray["paths"]["SECTIONS_DIRECTORY"];

   //Global xml file and global ini files 
   $tmpString = $EKKITAB_HOME.$configArray["paths"]["SECTIONS_GLOBAL_XML_FILE"];
   $globalSectionsXMLFile = fopen($tmpString, "w") or die ("Cannot open" . $tmpString . "\n");

   $tmpString = $EKKITAB_HOME.$configArray["paths"]["SECTIONS_GLOBAL_INI_FILE"];
   $globalSectionsINIFile = fopen($tmpString, "w") or die ("Cannot open" . $tmpString . "\n");

   $sectionsArray = $configArray["sections"];
   if( $sectionsArray != null and !empty($sectionsArray)) {
     writeSections($sectionsArray);
   }
   fclose($globalSectionsXMLFile);
   fclose($globalSectionsINIFile);
}

sections_menu_generate_start($argc, $argv);

?>
