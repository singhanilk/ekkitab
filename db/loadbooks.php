<?php

// This Script loads 100k book into Magento........

// finding the table&apss last primary key value
$dbm = mysqli_connect(&apslocalhost&aps,&apsroot&aps,&aps&aps,&apsekkitab&aps);

//catalog_product_entity
$cpe = 0;
$query = &apsselect * from catalog_product_entity&aps;
$result = mysqli_query($dbm,$query);
$row = Mysqli_fetch_array($result);

While(!empty($row))
{$cpe = $row[&apsentity_id&aps];
$row = Mysqli_fetch_array($result);
}
echo $cpe.&aps<br>&aps;

//catalog_product_entity_datetime

$cpedt = 0;
$query = &apsselect * from catalog_product_entity_datetime&aps;
$result = mysqli_query($dbm,$query);
$row = Mysqli_fetch_array($result);

While(!empty($row))
{$cpedt = $row[&apsvalue_id&aps];
$row = Mysqli_fetch_array($result);
}
echo $cpedt.&aps<br>&aps;

//catalog_product_entity_decimal

$cpede = 0;
$query = &apsselect * from catalog_product_entity_decimal&aps;
$result = mysqli_query($dbm,$query);
$row = Mysqli_fetch_array($result);

While(!empty($row))
{$cpede = $row[&apsvalue_id&aps];
$row = Mysqli_fetch_array($result);
}
echo $cpede.&aps<br>&aps;


//catalog_product_entity_int

$cpein = 0;
$query = &apsselect * from catalog_product_entity_int&aps;
$result = mysqli_query($dbm,$query);
$row = Mysqli_fetch_array($result);

While(!empty($row))
{$cpein = $row[&apsvalue_id&aps];
$row = Mysqli_fetch_array($result);
}
echo $cpein.&aps<br>&aps;

//catalog_product_entity_media_gallery

$cpemg = 0;
$query = &apsselect * from catalog_product_entity_media_gallery&aps;
$result = mysqli_query($dbm,$query);
$row = Mysqli_fetch_array($result);

While(!empty($row))
{$cpemg = $row[&apsvalue_id&aps];
$row = Mysqli_fetch_array($result);
}
echo $cpemg.&aps<br>&aps;


//catalog_product_entity_text

$cpetx = 0;
$query = &apsselect * from catalog_product_entity_text&aps;
$result = mysqli_query($dbm,$query);
$row = Mysqli_fetch_array($result);

While(!empty($row))
{$cpetx = $row[&apsvalue_id&aps];
$row = Mysqli_fetch_array($result);
}
echo $cpetx.&aps<br>&aps;

//catalog_product_entity_varchar

$cpevc = 0;
$query = &apsselect * from catalog_product_entity_varchar&aps;
$result = mysqli_query($dbm,$query);
$row = Mysqli_fetch_array($result);

While(!empty($row))
{$cpevc = $row[&apsvalue_id&aps];
$row = Mysqli_fetch_array($result);
}
echo $cpevc.&aps<br>&aps;



$db = mysqli_connect(&apslocalhost&aps,&apsroot&aps,&aps&aps,&apsref1&aps);


$query = "SELECT * FROM REF1.100";

$result = mysqli_query($db,$query);
$row = mysqli_fetch_array($result);

while(!empty($row))
{ echo $row[&apsTITLE&aps].&aps<br>&aps;

 // write into the magento database. to add products
 
 //catalog_product_entity

 $cpe = $cpe + 1;
 $query = "insert into catalog_product_entity values ($cpe,4,26,&apssimple&aps,&aps$row[&apsISBN&aps]&aps,$row[&apsBISAC&aps],&aps2009-11-12 00:00:00&aps,&aps2009-11-12 00:00:00&aps,0,0)";
 $result1 = mysqli_query($dbm,$query);
 echo $query.&aps<br>&aps;

// catalog_product_entity_datatime
 $cpedt = $cpedt + 1;
 $query = "insert into catalog_product_entity_datetime values ($cpedt,4,501,0,$cpe,&aps2009-11-11&aps)";
 $result1 = mysqli_query($dbm,$query);
 echo $query.&aps<br>&aps;

// catalog_product_entity_decimal
 $cpede = $cpede + 1;
 $query = "insert into catalog_product_entity values_decimal ($cpede,4,60,0,$cpe,$row[&apsPRICE&aps])";
 $result1 = mysqli_query($dbm,$query);
 echo $query.&aps<br>&aps;
 
 $cpede = $cpede + 1;
 $query = "insert into catalog_product_entity values_decimal ($cpede,4,65,0,$cpe,$row[&apsWEIGHT&aps])";
 $result1 = mysqli_query($dbm,$query);
 echo $query.&aps<br>&aps;

// catalog_product_entity_int
 $cpein = $cpein + 1;
 $query = "insert into catalog_product_entity_int values ($cpein,4,80,0,$cpe,1)";
 $result1 = mysqli_query($dbm,$query);
 echo $query.&aps<br>&aps;
 
 $cpein = $cpein + 1;
 $query = "insert into catalog_product_entity_int values ($cpein,4,81,0,$cpe,0)";
 $result1 = mysqli_query($dbm,$query);
 echo $query.&aps<br>&aps;
 
 $cpein = $cpein + 1;
 $query = "insert into catalog_product_entity_int values ($cpein,4,85,0,$cpe,4)";
 $result1 = mysqli_query($dbm,$query);
 echo $query.&aps<br>&aps;

 $cpein = $cpein + 1;
 $query = "insert into catalog_product_entity_int values ($cpein,4,467,0,$cpe,1)";
 $result1 = mysqli_query($dbm,$query);
 echo $query.&aps<br>&aps;

 $cpein = $cpein + 1;
 $query = "insert into catalog_product_entity_int values ($cpein,4,508,0,$cpe,1)";
 $result1 = mysqli_query($dbm,$query);
 echo $query.&aps<br>&aps;

// catalog_product_entity_media_gallery
 $cpemg = $cpemg + 1;
 $query = "insert into catalog_product_entity_media_gallery values ($cpemg,73,$cpe,&aps/100k/".$row[&apsISBN&aps].".jpg&aps)";
 $result1 = mysqli_query($dbm,$query);
 echo $query.&aps<br>&aps;

// catalog_product_entity_media_gallery_value
 $cpemg = $cpemg + 1;
 $query = "insert into catalog_product_entity_media_gallery values ($cpemg,0,&aps&aps,1,0)";
 $result1 = mysqli_query($dbm,$query);
 echo $query.&aps<br>&aps;
 
// catalog_product_entity_text
 $cpetx = $cpetx + 1;
 $query = "insert into catalog_product_entity_text ($cpetx,4,502,0,$cpe,&apspeng&aps)";
 $result1 = mysqli_query($dbm,$query);
 echo $query.&aps<br>&aps;

 $cpetx = $cpetx + 1;
 $query = "insert into catalog_product_entity_text ($cpetx,4,57,0,$cpe,&aps$row[&apsTITLE&aps]&aps)";
 $result1 = mysqli_query($dbm,$query);
 echo $query.&aps<br>&aps;

 $cpetx = $cpetx + 1;
 $query = "insert into catalog_product_entity_text ($cpetx,4,58,0,$cpe,&aps$row[&apsTITLE&aps]&aps)";
 $result1 = mysqli_query($dbm,$query);
 echo $query.&aps<br>&aps;
 
 $cpetx = $cpetx + 1;
 $query = "insert into catalog_product_entity_text ($cpetx,4,68,0,$cpe,&aps&aps)";
 $result1 = mysqli_query($dbm,$query);
 echo $query.&aps<br>&aps;

 $cpetx = $cpetx + 1;
 $query = "insert into catalog_product_entity_text ($cpetx,4,89,0,$cpe,&aps$row[&apsTITLE&aps]&aps)";
 $result1 = mysqli_query($dbm,$query);
 echo $query.&aps<br>&aps;


// catalog_product_varchar

 $cpevc = $cpevc + 1;
 $query = "insert into catalog_product_entity_varchar ($cpetx,4,89,0,$cpe,&aps$row[&apsTITLE&aps]&aps)";
 $result1 = mysqli_query($dbm,$query);
 echo $query.&aps<br>&aps;
 



$row = mysqli_fetch_array($result);

}//end of while

mysqli_close($dbm);

?>
