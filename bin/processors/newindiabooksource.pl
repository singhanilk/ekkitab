#!/usr/bin/perl -w
use strict;
use Spreadsheet::ParseExcel;
use Config::Abstract::Ini;
my $oExcel = new Spreadsheet::ParseExcel;

die "Usage $0 <Excel File> \n Redirect output to required file from stdout" unless @ARGV;
my $FH = "filehandle";
my $FilePath;
my $count_available = 0;
my $count_notavailable = 0;
my $oBook = $oExcel->Parse($ARGV[0]);
if (not defined $oBook) {
    print STDERR "Failed to parse input file: $ARGV[0]\n"; 
    exit(1);
}
my($iR, $iC, $oWkS, $oWkC);
my $ekkitab_home = $ENV{EKKITAB_HOME};
if (!($ekkitab_home)){
  die "EKKITAB_HOME is not defined";
}

my $Settingsfile = $ekkitab_home . "/config/stockprocess.ini";
my $settings     = new Config::Abstract::Ini($Settingsfile);
my %values       = $settings -> get_entry('newindiabooksource');
my $threshold    = $values{'availability'};

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
                    if ($oWkC->Value =~ /ISBN/i) {
                        $isbncol = $iC;
                        next;
                    }
                }
                if ($pricecol == -1) {
                    if (($oWkC->Value =~ /SellRate/i) or 
                       ($oWkC->Value =~ /PRICE/i)) {
                        $pricecol = $iC;
                        next;
                    }
                }
                if ($availcol == -1) {
                    if (($oWkC->Value =~ /Net\sAvailability/i) or 
                       ($oWkC->Value =~ /AVAILABILITY/i)) {
                        $availcol = $iC;
                        next;
                    }
                }
    	        if ($titlecol == -1) {
    		        if ($oWkC->Value =~ /Title/i) {
                        $titlecol = $iC;
                        next;
    		        }
                }
    
    	        if ($authorcol == -1) {
    		        if ($oWkC->Value =~ /Author/i) {
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
        my $currency;
        my $value = $oWkS->{Cells}[$i][$isbncol];
        my $isbn;
        my $imprint = 'NewIndiaBookSource';

        if (defined ($value)) {
           $isbn = $value->Value;
           chomp($isbn);
           $isbn =~ s/[^0-9]+//g;
        }
        $value = $oWkS->{Cells}[$i][$pricecol];
        my $price;
        if (defined ($value)) {
           $price = $value->Value;
           $price =~ s/\n//g;
           if($price =~ /[0-9]/){
	        $currency = 'I';	
	       }
	       if($price =~ /\$/){
	        $currency = 'U';
            $price =~ s/\$//g;
	       }    
	       if($price =~ /\xa3/){
	         $currency = 'P';
             $price =~ s/\xa3//g;
	       }
        }
        $value = $oWkS->{Cells}[$i][$availcol];
        my $availability;
        if(defined ($value)) {
           $availability = $value->Value;
           $availability =~ s/\n//g;
           if ($availability > $threshold) {
	          $availability = 'Available';
              if (length($isbn) == 10 || length($isbn) == 13){
                $count_available++;
              }
           }
           else{
		       $count_notavailable++;
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
            defined ($author)) {
            if ($isbn eq '' || $price eq ''){
	         next;
            }
             elsif (length($isbn) == 10 || length($isbn) == 13){
                  print $isbn . "\t" . $price . "\t" . $currency . "\t"  
    		      . $availability . "\t" . $imprint .  "\t" . $title .  "\t" . $author . "\n" ;
             }
        }
    }
}
    my $ratio = 0;
    if (($count_available + $count_notavailable)> 0) {
        $ratio = ($count_available/($count_available + $count_notavailable))*100;
    }
    if (int($ratio) < 70){
        warn "[WARNING] Available books are less than 70% of total.\n";
    }
#print "Available --> $count_available Not Available --> $count_notavailable Total -->" . ($count_available+$count_notavailable) . "\n";
exit(0);
