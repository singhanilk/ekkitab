#!/usr/bin/perl -w
use strict;
use Spreadsheet::ParseExcel;

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
                    if ($oWkC->Value =~ /ISBN/) {
                        $isbncol = $iC;
                        next;
                    }
                }
                if ($pricecol == -1) {
                    if ($oWkC->Value =~ /Spl Indian Price/) {
                        $pricecol = $iC;
                        next;
                    }
                }
    	        if ($titlecol == -1) {
    		    if ($oWkC->Value =~ /Title/) {
                        $titlecol = $iC;
                        next;
    		        }
                }
    
    	        if ($authorcol == -1) {
    		    if ($oWkC->Value =~ /contributor/) {
                        $authorcol = $iC;
                        next;
    		        }
                }
            }
        }

        if (($pricecol >= 0) && ($isbncol >= 0) && ($titlecol >= 0) && ($authorcol >= 0)) {
             $startrow = $iR + 1;
             $endrow   = $oWkS->{MaxRow};
             last;
        }
    }
    if (!(($pricecol >= 0) && ($isbncol >= 0) && ($titlecol >= 0) && ($authorcol >= 0))) {
            print STDERR "[Warning] Incomplete information in excel sheet. Cannot parse. Continuing to next sheet.\n";
            last;
    }

    for (my $i = $startrow; $i <= $endrow; $i++) {
	 $enteredcount++;
	 my $currency = 'I';
         my $availability = 'Available'; 
         my $imprint = 'Harward';
         my $value = $oWkS->{Cells}[$i][$isbncol];
         my $value1 = $oWkS->{Cells}[$i][$isbncol];
         my $isbn;
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
             $price =~ s/Rs.\s//; #Removes 'Rs.'{whitespace}
             $price =~ s/,//;     #Removes ','
         }
         $value  = $oWkS->{Cells}[$i][$titlecol];
         $value1 = $oWkS->{Cells}[$i+1][$titlecol];
         my $title;
         my $title1;
         if (defined ($value) && ($value1)) {
             $title  = $value->Value;
             $title1 = $value1->Value;
             $title  = $title . " "  . $title1 . "\n";
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
     my $ratio = ($printedcount/$enteredcount)*100;
     if (int($ratio) < 70){
         warn "[WARNING] Values printed less than 70% \n";
     }
}

exit(0);
