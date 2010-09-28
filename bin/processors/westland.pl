#!/usr/bin/perl -w
use strict;
use Spreadsheet::ParseExcel;
use Config::Abstract::Ini;

my $ekkitab_home = $ENV{EKKITAB_HOME};
if (!($ekkitab_home)){
print "Not Defined" . "\n";
}
my $Settingsfile = $ekkitab_home . "/config/stockprocess.ini";
my $settings     = new Config::Abstract::Ini($Settingsfile);
my %values       = $settings -> get_entry('westland');
my $threshold    = $values{'availability'};

my $oExcel = new Spreadsheet::ParseExcel;

die "Usage $0 <Excel File> \n Redirect output to required file from stdout" unless @ARGV;
my $FH = "filehandle";
my $FilePath;
my $enteredcount = 0;
my $printedcount = 0;
my $oBook = $oExcel->Parse($ARGV[0]);
if (not defined $oBook) {
    print STDERR "Failed to parse input file: $ARGV[0]\n"; 
    exit(1);
}
my($iR, $iC, $oWkS, $oWkC);
print "#ISBN\t" . "PRICE\t" . "CURRENCY\t" . "AVAILABILITY\t" . "SUPPLIER\t" . "TITLE\t" . "AUTHOR\n" ;


for(my $iSheet=0; $iSheet < $oBook->{SheetCount} ; $iSheet++) {

    $oWkS = $oBook->{Worksheet}[$iSheet];
    my $isbncol = -1;
    my $pricecol = -1;
    my $currencycol = -1;
    my $availcol = -1;
    my $startrow = -1;
    my $endrow = -1;
    my $imprintcol = -1;
    my $titlecol = -1;
    my $authorcol = -1;

    for(my $iR = $oWkS->{MinRow} ; defined $oWkS->{MaxRow} && $iR <= $oWkS->{MaxRow} ; $iR++) {
        for(my $iC = $oWkS->{MinCol} ; defined $oWkS->{MaxCol} && $iC <= $oWkS->{MaxCol} ; $iC++) {
            $oWkC = $oWkS->{Cells}[$iR][$iC];
            if (defined $oWkC) {
                if ($isbncol == -1) {
                    if ($oWkC->Value =~ /ISBN13/) {
                        $isbncol = $iC;
                        next;
                    }
                }
                if ($isbncol == -1) {
                    if ($oWkC->Value =~ /ISBN/) {
                        $isbncol = $iC;
                        next;
                    }
                }
                if ($pricecol == -1) {
                    if ($oWkC->Value =~ /PRICE/i) {
                         $pricecol = $iC;
                        next;
                    }
                }
                if ($currencycol == -1) {
                    if ($oWkC->Value =~ /CUR/i) {
                         $currencycol = $iC;
                        next;
                    }
                }
                if ($availcol == -1) {
                    if ($oWkC->Value =~ /QTY/i) {
                        $availcol = $iC;
                        next;
                    }
                }
                if ($availcol == -1) {
                    if ($oWkC->Value =~ /STOCK/i) {
                        $availcol = $iC;
                        next;
                    }
                }
                if ($availcol == -1) {
                    if ($oWkC->Value =~ /STK/i) {
                        $availcol = $iC;
                        next;
                    }
                }
                if ($availcol == -1) {
                    if ($oWkC->Value =~ /BLR/i) {
                        $availcol = $iC;
                        next;
                    }
                }
                if ($titlecol == -1) {
                    if ($oWkC->Value =~ /name/i) {
                        $titlecol = $iC;
                        next;
                    }
                }
                if ($titlecol == -1) {
                    if ($oWkC->Value =~ /TITLE/i) {
                        $titlecol = $iC;
                        next;
                    }
                }
                if ($titlecol == -1) {
                    if ($oWkC->Value =~ /TITLES/i) {
                        $titlecol = $iC;
                        next;
                    }
                }
    
                if ($authorcol == -1) {
                    if ($oWkC->Value =~ /AUTHOR1/i) {
                        $authorcol = $iC;
                        next;
                    }
                }
                if ($authorcol == -1) {
                    if ($oWkC->Value =~ /AUTHOR/i) {
                        $authorcol = $iC;
                        next;
                    }
                }
            }
        }

        if (($availcol >= 0) && ($pricecol >= 0) && ($isbncol >= 0) && ($titlecol >= 0) && ($authorcol >= 0) && ($currencycol >= 0)) {
            $startrow = $iR + 1;
            $endrow   = $oWkS->{MaxRow};
            last;
        }
    }
    if (!(($availcol >= 0) && ($pricecol >= 0) && ($isbncol >= 0) && ($titlecol >= 0) && ($authorcol >= 0) && ($currencycol >= 0) )) {
            print STDERR "[Warning] Incomplete information in excel sheet. Cannot parse. Continuing to next sheet.\n";
            last;
    }

    for (my $i = $startrow; $i <= $endrow; $i++) {
        my $value = '';
        eval { $value = $oWkS->{Cells}[$i][$isbncol]; };
        if ($@) {
           print STDERR "Unexpected read value. Line $i\n";
           last;
        }
        my $isbn;
        my $imprint = 'Westland';
        if (defined ($value)) {
            $isbn = $value->Value;
            chomp($isbn);
            $isbn =~ s/[^0-9]+//g;
            if(length($isbn) ge 10){
                $enteredcount++;
            }
        }
        $value = $oWkS->{Cells}[$i][$pricecol];
        my $price;
        if (defined ($value)) {
           $price = $value->Value;
           $price =~ s/\n//g;
        }
        $value = $oWkS->{Cells}[$i][$currencycol];
        my $currency;
        if (defined ($value)) {
           $currency = $value->Value;
           $currency =~ s/\n//g;
           if ($currency =~ /INR/) {
               $currency ='I';
           }
           elsif ($currency =~ /GBP/) {
                  $currency = 'P';
           }
           elsif ($currency =~ /USD/) {
                  $currency = 'U';
           }
           elsif ($currency =~ /SD/) {
                  $currency = 'U';
           }
           elsif ($currency =~ /EUR/) {
                  $currency = 'E';
           }
           elsif ($currency =~ /SGD/) {
                  $currency = 'S';
           }
           else {
                  $currency = undef;
           }
        }
        $value = $oWkS->{Cells}[$i][$availcol];
        my $availability;
        if(defined ($value)) {
           $availability = $value->Value;
           $availability =~ s/\n//g;
           if($availability eq ""){
                next;
           }
           if ($availability > $threshold){
           $availability = 'Available';
           }
           else{
               $availability = 'Not Available' . '[' . $availability . ']'  ;
           }        
        }
        $value = $oWkS->{Cells}[$i][$titlecol];
        my $title;
        if (defined ($value)) {
           $title = $value->Value;
           $title =~ s/\n//g;
        }
        $value = $oWkS->{Cells}[$i][$authorcol];
        my $author;
        if (defined ($value)) {
           $author = $value->Value;
           $author =~ s/\n//g;
        }
        if (defined ($isbn)  && 
            defined ($price) && 
            defined ($currency) && 
            defined ($availability) && 
            defined ($imprint) && 
            defined ($title) && 
            defined ($author)) {
            if ($isbn eq '' || $price eq ''){
             next;
            }
             elsif (length($isbn) == 10 || length($isbn) == 13){
                  $printedcount++;
                  print $isbn . "\t" . $price . "\t" . $currency . "\t"  
                  . $availability . "\t" . $imprint .  "\t" . $title .  "\t" . $author . "\n" ;
             }
        }
    }
}
my $ratio = ($printedcount/$enteredcount)*100;
if (int($ratio) < 70) {
  warn "[WARNING] Values printed less than 70% \n";
}
exit(0);

