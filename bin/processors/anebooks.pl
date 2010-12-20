#!/usr/bin/perl -w
use strict;
use Spreadsheet::ParseExcel;
use Config::Abstract::Ini;
use File::Basename;
my $ekkitab_home = $ENV{EKKITAB_HOME};
if (!($ekkitab_home)){
print "Not Defined" . "\n";
}
my $Settingsfile = $ekkitab_home . "/config/stockprocess.ini";
my $settings     = new Config::Abstract::Ini($Settingsfile);
my %values       = $settings -> get_entry('availability');
my %stockvalues  = $settings -> get_entry('anebooks');
my $threshold    = $stockvalues{'availability'};
my $bangalore    = $values{'bangalore'}; 
my $kolkata      = $values{'kolkata'};
my $delhi        = $values{'delhi'};
my $mumbai       = $values{'mumbai'};
my $deliverydays;
my $city = $ARGV[0];
$city = basename($ARGV[0]);
$city =~ s/^STK//gi;
$city =~ s/stock//gi;
$city =~ s/stck//gi;
$city =~ s/list//gi;
$city =~ s/[0-9]//g;
$city =~ s/\.xls//gi;
$city =~ s/-//g;
$city =~ s/\s+//g;
my %assumptions = ('delhi' => $delhi,'DEL' => $delhi,'DLHI' => $delhi, 'Delhi' => $delhi,'BLR' => $bangalore, 'banglore' => $bangalore,
                        'bangalore' => $bangalore, 'Bangalore' => $bangalore, 'Banglore' => $bangalore,
                    'MBMI' => $mumbai, 'mumbai' => $mumbai, 'Mumbai' => $mumbai, 'KLKTA' => $kolkata, 'KOL' => $kolkata, 'Kolkata' => $kolkata, 'KLKT' => $kolkata);
$deliverydays =  $assumptions{$city};
my $oExcel = new Spreadsheet::ParseExcel;
die "Usage $0 <Excel File> \n Redirect output to required file from stdout" unless @ARGV;
my $enteredcount = 0;
my $printedcount = 0;
my $oBook = $oExcel->Parse($ARGV[0]);
if (not defined $oBook) {
    print STDERR "Failed to parse input file: $ARGV[0]\n"; 
    exit(1);
}
my($iR, $iC, $oWkS, $oWkC);
print "#ISBN\t" . "PRICE\t" . "CURRENCY\t" . "AVAILABILITY\t" . "SUPPLIER\t" . "TITLE\t" . "AUTHOR\t" . "DELIVERYDAYS\n" ;

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
                    if ($oWkC->Value =~ /ISBN/i) {
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
                    if ($oWkC->Value =~ /CURRENCY/i) {
                        $currencycol = $iC;
                        next;
                    }
                }
                if ($availcol == -1) {
                    if ($oWkC->Value =~ /QUANTITY/i) {
                        $availcol = $iC;
                        next;
                    }
                }
    	        if ($titlecol == -1) {
    		        if ($oWkC->Value =~ /TITLE/i) {
                        $titlecol = $iC;
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

        if (($availcol >= 0) && ($pricecol >= 0) && ($isbncol >= 0) && ($titlecol >= 0) && ($authorcol >= 0)) {
            $startrow = $iR + 1;
            $endrow   = $oWkS->{MaxRow};
            last;
        }
    }
    if (!(($availcol >= 0) && ($pricecol >= 0) && ($isbncol >= 0) && ($titlecol >= 0) && ($authorcol >= 0))) {
            print STDERR "[Warning] Incomplete information in excel sheet. Cannot parse. Continuing to next sheet.\n";
            last;
    }

    for (my $i = $startrow; $i <= $endrow; $i++) {
        if(defined($assumptions{$oWkS->get_name()})){
            $deliverydays = $assumptions{$oWkS->get_name()};
        } else {
            $deliverydays = "";
        }
	    $enteredcount++;
        my $value = '';
        eval { $value = $oWkS->{Cells}[$i][$isbncol]; };
        if ($@) {
           # print STDERR "Unexpected read value. Line $i\n";
	        last;
	    }
        my $isbn;
        my $imprint = 'Anebooks';
	    if (defined ($value)) {
            $isbn = $value->Value;
            chomp($isbn);
            $isbn =~ s/\.00$//g;
            $isbn =~ s/[^0-9]+//g;
        }
        $value = $oWkS->{Cells}[$i][$pricecol];
        my $price;
        if (defined ($value)) {
           $price = $value->Value;
           $price =~ s/\/no//g;
           $price =~ s/\n//g;
        }
        $value = $oWkS->{Cells}[$i][$currencycol];
        my $currency;
        if (defined ($value)) {
            $currency = $value->Value;
            $currency =~ s/\n//g;
            if ($currency =~ /Rs/) {
                $currency ='I';
            }
            elsif ($currency =~ /£/) {
                   $currency = 'P';
            }
            elsif ($currency =~ /$/) {
                   $currency = 'U';
            }
            elsif ($currency =~ /€/) {
                   $currency = 'E';
            }
        }
        $value = $oWkS->{Cells}[$i][$availcol];
        my $availability = 0;
        my $tmpValue;
            if(defined ($value)) {
                $tmpValue = $value->Value;
                $tmpValue =~ s/\n//g;
                $tmpValue =~ s/ no//g;
                $tmpValue =~ s/^\s+//;
                $tmpValue =~ s/\s+$//;
                $availability = $tmpValue;
	        if ($availability > $threshold){
	            $availability = 'Available';
            }
            else{
                $availability = 'Not Available' . '[' . $availability . ']';
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
            defined ($deliverydays) &&
            defined ($author)) {
            if ($isbn eq '' || $price eq ''){
	         next;
            }
            elsif (length($isbn) == 10 || length($isbn) == 13){
		    $printedcount++;
		    print $isbn . "\t" . $price . "\t" . $currency . "\t"  
    		      . $availability . "\t" . $imprint .  "\t" . $title .  "\t" . $author . "\t" . "$deliverydays" . "\n" ;
             }
        } 
    }
    my $ratio = ($printedcount/$enteredcount)*100;
    if (int($ratio) < 70){
        warn "[WARNING] Values printed less than 70% \n";
    }
}

exit(0);

