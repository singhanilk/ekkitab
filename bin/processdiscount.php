<?php
function initXML($name) {
    return simplexml_load_file($name);
}
function sortdiscountlevel($a, $b) {
    $levela = $a['level'];
    $levelb = $b['level'];
    if ($levela == $levelb) {
        return 0;
    }
    return ($levela < $levelb) ? -1 : 1;
}

function sortpricelevel($a, $b) {
    $levela = $a['min'];
    $levelb = $b['min'];
    if ($levela == $levelb) {
        return 0;
    }
    return ($levela < $levelb) ? -1 : 1;
}

function printDiscountData($supplier, $discountlevels) {
    echo "Supplier: $supplier\n";
    foreach ($discountlevels as $discountlevel) {
        echo "   Discount Level: " . $discountlevel['level'] . "\n";
        foreach ($discountlevel['ranges'] as $range) {
            echo "      From Price: " . $range['min'] . " to " . $range['max'] . " discount: " . $range['discountmin'] . "-" . $range['discountmax'] . "\n";
        }
     }
}

function validateDiscountData($discountlevels) {
    $z = -1;
    foreach ($discountlevels as $level) {
        if ($level['level'] <= $z) {
           echo "[Fatal] Ambiguous discount levels found in input.\n";
           return(null);
        }
        $z = $level['level'];
        $low  = 0;
        $high = 0;
        foreach ($level['ranges'] as $range) {
           if ($range['min'] != $high) {
               echo "[Fatal] Ambiguous price levels found in input.\n";
               return(null);
           }
           if ($range['max'] <=  $range['min']) {
               echo "[Fatal] Min price is greater than or equal to max price in input.\n";
               return(null);
           }
           $low = $range['min'];
           $high = $range['max'];
        }
    }
    return($discountlevels);
}

function sortDiscountData($discountlevels) {
    for ($i=0; $i<count($discountlevels); $i++) {
        usort(&$discountlevels[$i]['ranges'], sortpricelevel);
    }
    usort(&$discountlevels, sortdiscountlevel);
    return($discountlevels);
}

function generateDiscountData($suppliers) {

    $Z = array();

    foreach ($suppliers as $supplier) {
        $suppliername = (string)$supplier['name'];
        $Z[$suppliername] = array();
        $discountlevels = $supplier->children();
        $j = 0;
        foreach ($discountlevels as $discountlevel) {
            $discountlevelname = (string)$discountlevel['value'];
            $Z[$suppliername][$j]= array();
            $Z[$suppliername][$j]['level'] = $discountlevelname;
            $Z[$suppliername][$j]['ranges'] = array();
            $priceranges = $discountlevel->children();
            $i = 0;
            foreach ($priceranges as $pricerange) {
                $Z[$suppliername][$j]['ranges'][$i]['min'] = (string)$pricerange['min'];
                $Z[$suppliername][$j]['ranges'][$i]['max'] = (string)$pricerange['max'];
                $discounts = $pricerange->children();
                if (count($discounts) != 1) {
                    echo "[Fatal] Discount range is improperly specified in input.\n";
                    return(null);
                }
                $Z[$suppliername][$j]['ranges'][$i]['discountmin'] = (string)$discounts[0]['low'];
                $Z[$suppliername][$j]['ranges'][$i]['discountmax'] = (string)$discounts[0]['high'];
                $i++;
            }
            $j++;
        }
    }

    return($Z);
}

function getDiscountData($supplier, $xmlfile) {
    $xml = initXML($xmlfile);
    if (! $xml instanceof SimpleXmlElement) {
        echo "[Fatal] Could not read input xml file.\n";
        return(null);
    }
    $suppliers = $xml->children();
    $discounts = generateDiscountData($suppliers);
    if ($discounts == null) {
        echo "[Fatal] Could not generate discount data from information in file.\n";
        return(null);
    }
    $supplierdiscount = sortDiscountData($discounts[$supplier]);
    if (!validateDiscountData($supplierdiscount)) {
        echo "[Fatal] Validation of data for $supplier failed. \n";
        return(null);
    }
    return($supplierdiscount);
}

//Testing...
//$discount = getDiscountData("Ingrams", "t.xml");
//if ($discount) {
//    printDiscountData("Ingrams", $discount);
//}
//else {
//    echo "Failed to get Discount Data.\n";
//}




