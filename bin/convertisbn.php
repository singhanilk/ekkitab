<?php
function genchksum13($isbn) {
    $isbn = trim($isbn);
    if (strlen($isbn) != 12) {
        return -1;
    }
    $sum = 0;
    for ($i = 0; $i < 12; $i+=2) {
        $sum += ($isbn[$i] * 1);
        $sum += ($isbn[$i+1] * 3);
    }
    $sum = $sum % 10;
    $sum = 10 - $sum;
    return ($sum == 10 ? 0 : $sum);
}

function isbn10to13($isbn10) {
    $isbn13 = "";
    $isbn10 = trim($isbn10);
    if(strlen($isbn10) == 12) { // if number is UPC just add zero
        $isbn13 = '0'.$isbn10;
    }
    elseif (strlen($isbn10) == 10) {
        $isbn13 = substr("978" . $isbn10, 0, -1);
        $chksum = genchksum13($isbn13);
        $isbn13 = $isbn13.$chksum;
    }
    return ($isbn13);
}

function isbn13to10($isbn13) {
    $isbn10 = "";
    if ($isbn13 && (strlen($isbn13) == 13)) {
        $isbn10 = substr($isbn13, 3, 9);
        $checksum = 0;
        $weight = 10;
        for ($i=0; $i < 9; $i++) {
           $checksum += $isbn10[$i] * $weight;
           $weight--;
        }
        $checksum = 11-($checksum % 11);
        if ($checksum == 10)
            $isbn10 .= "X";
        elseif ($checksum == 11)
            $isbn10 .= "0";
        else
            $isbn10 .= $checksum;
    }
    return $isbn10;
}

function convertisbn($isbn) {
    if (strlen($isbn) == 10) {
        return (isbn10to13($isbn));
    }
    elseif (strlen($isbn) == 13) {
        return (isbn13to10($isbn));
    }
}
?>
