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
print "#ISBN\t" . "PRICE\t" . "CURRENCY\t" . "AVAILABILITY\t" . "IMPRINT\t" . "TITLE\t" . "AUTHOR\n" ;


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
                      if ($oWkC->Value =~ /ISBN\sNo\./) {
                         $isbncol = $iC;
                         next;
                     }
                  }
		          if ($imprintcol == -1) {
		              if ($oWkC->Value =~ /Publisher/) {
			              $imprintcol = $iC;
			              next;
		              }
		          }
                  if ($currencycol == -1) {
                      if ($oWkC->Value =~ /Currency/) {
                          $currencycol = $iC;
                          next;
                       }
                  }
                  if ($pricecol == -1) {
                      if ($oWkC->Value =~ /Price/) {
                          $pricecol = $iC;
                          next;
                      }
                  }
                  if ($pricecol == -1) {
                      if ($oWkC->Value =~ /MRP/) {
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
                  if ($titlecol == -1) {
                      if ($oWkC->Value =~ /Products\sdescriptions/) {
                          $titlecol = $iC;
                          next;
                      }
                  }
                  if ($availcol == -1) {
                      if ($oWkC->Value =~ /Stock/) {
                          $availcol = $iC;
                          next;
                      }
                  }
              }
	  }
	if (($isbncol >= 0) && ($titlecol >= 0) && ($pricecol >= 0)) {
            $startrow = $iR + 1;
            $endrow   = $oWkS->{MaxRow};
            last;
        }
    }
       
    if (!(($pricecol >= 0) && ($isbncol >= 0) && ($titlecol >= 0))) {
            print STDERR "[Warning] Incomplete information in excel sheet. Cannot parse. Continuing to next sheet.\n";
            last;
    }

    for (my $i = $startrow; $i <= $endrow; $i++) {
        my $author = 'Not Available';
        my $value = '';
        my $currency = '';
        my $availability = '';
        my $imprint = '';
        eval { $value = $oWkS->{Cells}[$i][$isbncol]; };
        if ($@) {
           print STDERR "Unexpected read value. Line $i\n";
           last;
        }
        my $isbn;
	    if (defined ($value)) {
            $isbn = $value->Value;
            chomp($isbn);
            $isbn =~ s/[^0-9]+//g;
            if(length($isbn) ge 10 ){
                $enteredcount++;
            }
        }
        if ($currencycol == -1){
            $currency = 'I'; 
        }
        else{
	        $value = $oWkS->{Cells}[$i][$currencycol];
            if (defined ($value)) {
                $currency = $value->Value;
                $currency =~ s/\n//g;
                if ($currency =~ /RS/) {
                    $currency ='I';
                }
                elsif ($currency =~ /UKP/) {
                       $currency = 'P';
                }
                elsif ($currency =~ /USD/) {
                       $currency = 'U';
                }
                elsif ($currency =~ /EUR/) {
                       $currency = 'E';
                }
	            elsif ($currency =~ /DM/) {
                       $currency = 'E';
                }
	            else {
                      print $currency . "\n";
                }
            }
        }
        if ($availcol == -1){
            $availability = 'Available'; 
        }
        else{
	        $value = $oWkS->{Cells}[$i][$availcol];
            if(defined ($value)) {
                $availability = $value->Value;
                $availability =~ s/\n//g;
                if ($availability >  2){
	                $availability = 'Available';
                }
                else{
                    $availability = 'Not Available' . '[' . $availability . ']';
                }        
            }
        }
        $value = $oWkS->{Cells}[$i][$pricecol];
        my $price;
        if (defined ($value)) {
           $price = $value->Value;
           $price =~ s/\n//g;
        }
        $value = $oWkS->{Cells}[$i][$titlecol];
        my $title;
        if (defined ($value)) {
           $title = $value->Value;
           $title =~ s/\n//g;
        }
        if ($imprintcol == -1){
            $imprint = 'Not Available'; 
        }
        else{
            $value = $oWkS->{Cells}[$i][$imprintcol];
            if (defined ($value)) {
                $imprint = $value->Value;
                $imprint =~ s/\n//g;
            }
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
    if (int($ratio) < 70){
        warn "[WARNING] Values printed less than 70% \n";
    }

exit(0);
