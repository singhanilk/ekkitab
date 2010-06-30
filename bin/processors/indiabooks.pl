#!/usr/bin/perl -w
use strict;
use Spreadsheet::ParseExcel;

my $oExcel = new Spreadsheet::ParseExcel;

die "Usage $0 <Excel File> \n Redirect output to required file from stdout" unless @ARGV;

my $actualPrice;
my $oBook = $oExcel->Parse($ARGV[0]);
if (not defined $oBook) {
    print STDERR "Failed to parse input file: $ARGV[0]\n"; 
    exit(1);
}
my($iR, $iC, $oWkS, $oWkC);


for(my $iSheet=0; $iSheet < $oBook->{SheetCount} ; $iSheet++) {

    $oWkS = $oBook->{Worksheet}[$iSheet];
    my $isbncol = -1;
    my $pricecol = -1;
    my $pricecol1 = -1;
    my $currencycol = -1;
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
                    if ($oWkC->Value =~ /ISBN\/Code/) {
                        $isbncol = $iC;
                        next;
                    }
                }
                if ($pricecol == -1) {
                    if ($oWkC->Value =~ /S.P/) {
                        $pricecol = $iC;
                        next;
                    }
                }
		if ($pricecol1 == -1) {
                    if ($oWkC->Value =~ /RATE\sRs./) {
                        $pricecol1 = $iC;
                        next;
                    }
                }
                if ($currencycol == -1) {
                    if ($oWkC->Value =~ /CURR./) {
                        $currencycol = $iC;
                        next;
                    }
                }
    	        if ($imprintcol == -1) {
    		        if ($oWkC->Value =~ /PUBLISHER/) {
                        $imprintcol = $iC;
                        next;
    		        }
                }
    	        if ($titlecol == -1) {
    		        if ($oWkC->Value =~ /TITLE/) {
                        $titlecol = $iC;
                        next;
    		        }
                }
    
    	        if ($authorcol == -1) {
    		        if ($oWkC->Value =~ /AUTHOR/) {
                        $authorcol = $iC;
                        next;
    		        }
                }
            }
        }

        if (($currencycol >= 0) && ($pricecol >= 0) && ($isbncol >= 0) && ($imprintcol >= 0) && ($titlecol >= 0) && ($authorcol >= 0) && ($pricecol1 >= 0)) {
            $startrow = $iR + 1;
            $endrow   = $oWkS->{MaxRow};
            last;
        }
    }

    for (my $i = $startrow; $i <= $endrow; $i++) {

        my $value = $oWkS->{Cells}[$i][$isbncol];
        my $isbn;

        if (defined ($value)) {
           $isbn = $value->Value;
           chomp($isbn);
           $isbn =~ s/[^0-9]+//g;;
        }
        $value = $oWkS->{Cells}[$i][$pricecol];
        my $price;
        if (defined ($value)) {
           $price = $value->Value;
           $price =~ s/\n//g;
        }
	$value = $oWkS->{Cells}[$i][$pricecol1];
        my $price1;
        if (defined ($value)) {
           $price1 = $value->Value;
           $price1 =~ s/\n//g;
        }
        $value = $oWkS->{Cells}[$i][$currencycol];
        my $currency;
        if (defined ($value)) {
           $currency = $value->Value;
           $currency =~ s/\n//g;
           if ($currency =~ /\$/) {
                  $currency = 'U';
         }
        }
        $value = $oWkS->{Cells}[$i][$imprintcol];
        my $imprint;
        if (defined ($value)) {
           $imprint = $value->Value;
           $imprint =~ s/\n//g;
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
            defined ($price1) && 
            defined ($imprint) && 
            defined ($title) && 
            defined ($author)) {
            if ($isbn eq '' || $price eq '' || $price1 eq ''){
	         next;
            }
	    elsif (length($isbn) == 10 || length($isbn) == 13){
		    if (int($price) gt 0){
			$actualPrice = $price;
			#print $isbn . "\t" .$actualPrice . "\n";
			
		    }
		    if (int($price1) gt 0){
			$actualPrice = $price1;
			$currency = "I";
			#print $isbn . "\t" .$actualPrice . "\n";
		    }
                  print $isbn . "\t" . $actualPrice . "\t" . $currency . "\t"  
    		      . "Available" . "\t" . $imprint .  "\t" . $title .  "\t" . $author . "\n" ;
             }
        }
    }
}

exit(0);