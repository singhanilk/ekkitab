#!/usr/bin/perl -w
use strict;
use Spreadsheet::ParseExcel;


die "Usage $0 <Excel File> <output catalog file name> <stock list> <preorder[optional]>" unless @ARGV;
my($iR, $iC, $oWkS, $oWkC, $catalogFilename, $stockFilename, $preorder );

$catalogFilename = $ARGV[1];
open catalogFilehandle, ">", $catalogFilename or die $!;

if( defined $ARGV[2] ){
  $stockFilename = $ARGV[2];
  open stockFilehandle , ">", $stockFilename or die $!;
} else {
  $stockFilename = '';
}

$preorder = "";
if( defined $ARGV[3] ){
 if ( $ARGV[3] ne "preorder") {
    print STDERR "The fourth parameter can have only values 'preorder': $ARGV[3]\n"; 
    exit(1);
 } else {
   $preorder = "Preorder";
 }
}

my $oExcel = new Spreadsheet::ParseExcel;
my $oBook = $oExcel->Parse($ARGV[0]);
if (not defined $oBook) {
    print STDERR "Failed to parse input file: $ARGV[0]\n"; 
    exit(1);
}

# The columns are defined as follows. The corresponding arrays are declared accordingly. Total 19 Fields
#ISBN  PRICE    CURRENCY    AVAILABILITY    IMPRINT DELIVERY-DATE TITLE   AUTHOR  BINDING DESCRIPTION PUBLISH-DATE    PUBLISHER   PAGES   LANGUAGE    WEIGHT  DIMENSION   SHIP-REGION BISACCODE SUPPLIER
my @columnNames = ('ISBN','PRICE','CURRENCY','AVAILABILITY','IMPRINT','DELIVERY-DATE', 'TITLE','AUTHOR','BINDING','DESCRIPTION','PUBLISH-DATE','PUBLISHER','PAGES','LANGUAGE','WEIGHT','DIMENSION','SHIP-REGION','BISACCODE', 'SUPPLIER');
my @columnPresent = (-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1, -1);
my @columnValues = ('','','','','','','','','','','','','','','','','','','');

#Standard pattern
#my @columnPatterns = ('ISBN', 'TITLE', 'AUTHOR', 'FORMAT', 'DESCRIPTION', 'PUBLISH-DATE', 'PUBLISHER', 'PAGES', 'LANGUAGE', 'WEIGHT', 'DIMENSION', 'SHIP-REGION', 'CATEGORY' );
#Jaico pattern
#my @columnPatterns = ('ISBN', 'TITLE', 'AUTHOR', 'FORMAT', 'DESCRIPTION', 'PUBLISH-DATE', 'PUBLISHER', 'PAGES', 'LANGUAGE', 'WEIGHT', 'DIMENSION', 'SHIP-REGION', 'CATEGORY' );
#Wiley Pattern
#my @columnPatterns = ('ISBN', 'TITLE', 'AUTHOR', 'BTY', 'DESCRIPTION', 'LAST_REPRINT', 'PUBLISHER', 'PAGES', 'LANGUAGE', 'WEIGHT', 'DIMENSION', 'SHIP-REGION', 'SERIES' );
#New Arrivals Wiley Pattern
#my @columnPatterns = ('ISBN', 'NAME', 'AUTHOR', 'BINDING', 'DESCRIPTION', 'REL_DATE', 'CTG_DET', 'PAGES', 'LANGUAGE', 'WEIGHT', 'DIMENSION', 'SHIP-REGION', 'BISACCODE' );
#Tata McGrawhill pattern
#my @columnPatterns = ('ISBN', 'TITLE', 'AUTHOR', 'BINDING', 'DESCRIPTION', 'PUBLICATION DATE', 'PUBLISHER', 'PAGES', 'LANGUAGE', 'WEIGHT KG', 'DIMENSION', 'SHIP-REGION', 'CLUSTER' );
#Cambridge
#my @columnPatterns = ('ISBN13','name','AUTHOR1','BINDINGTYPE','DESCRIPTION','PUBLISH-DATE','PUBLISHER','PAGES','LANGUAGE','WEIGHT','DIMENSION','SHIP-REGION','BISACCODE');
#New Arrivals
my @columnPatterns = ('ISBN','PRICE','CURRENCY','AVAILABILITY','IMPRINT','DELIVERY-DATE', 'TITLE','AUTHOR','BINDING','DESCRIPTION','PUBLISH-DATE','PUBLISHER','PAGES','LANGUAGE','WEIGHT','DIMENSION','SHIP-REGION','SUBJECT', 'SUPPLIER');

for(my $iSheet=0; $iSheet < $oBook->{SheetCount} ; $iSheet++) {
    $oWkS = $oBook->{Worksheet}[$iSheet];
    my $startrow = -1;
    my $endrow = -1;
    for(my $iR = $oWkS->{MinRow} ; defined $oWkS->{MaxRow} && $iR <= $oWkS->{MaxRow} ; $iR++) {
        for(my $iC = $oWkS->{MinCol} ; defined $oWkS->{MaxCol} && $iC <= $oWkS->{MaxCol} ; $iC++) {
            $oWkC = $oWkS->{Cells}[$iR][$iC];
            if (defined $oWkC) {
              for(my $iCounter= 0; $iCounter < scalar(@columnPatterns); $iCounter++ ){
                  if ($oWkC->Value =~ /$columnPatterns[$iCounter]/i) {
                    $columnPresent[$iCounter] = $iC;  
                    next;
                  } 
              }
            }
         }
    # Check for ISBN , TITLE and AUTHOR for catalog and price file.
    if (($columnPresent[0] >= 0) && ($columnPresent[6] >= 0) && ($columnPresent[7] >= 0)) {
            $startrow = $iR + 1;
            $endrow   = $oWkS->{MaxRow};
            last;
    } else {
            print STDERR "Incomplete information in excel file. Cannot parse.\n";
            exit 1;
    }
  }

    for (my $i = $startrow; $i <= $endrow; $i++) {
        my $cellValue ;
        my $value = '';
        for(my $iCounter= 0; $iCounter < scalar(@columnPresent); $iCounter++ ){
          $columnValues[$iCounter] = '';
          if ( $columnPresent[$iCounter] != -1 ){
            $cellValue = $oWkS->{Cells}[$i][$columnPresent[$iCounter]]; 
            if (defined $cellValue) {
             eval { $value = $cellValue->Value; };
             if ($@) {
              print STDERR "Unexpected read value. Line $i\n";
             } else {
              $columnValues[$iCounter] = formatValue($iCounter, $value);
             }
           } 
         }
       }
      printColumnValues();
    }
}

sub printColumnValues{
      my $tmpString = "";
      my $availabilityString = "";

      # The initial check for isbn, title and author to be present has been modified to just isbn and title as we are loading data without author also.
      if (($columnValues[0] ne '') && ($columnValues[6] ne '')) {
        $tmpString = $columnValues[0]."\t".$columnValues[6]."\t".$columnValues[7]."\t".$columnValues[8]."\t".$columnValues[9]."\t".
                                 $columnValues[10]."\t".$columnValues[11]."\t".$columnValues[12]."\t".$columnValues[13]."\t".$columnValues[14]."\t".
                                 $columnValues[15]."\t".$columnValues[16]."\t".$columnValues[17]."\n";
       print catalogFilehandle $tmpString;
      }
      
     if ( $stockFilename ne '') {
      $availabilityString = ($preorder ne "") ? $preorder : $columnValues[3];
      if (($columnValues[0] ne '') && ($columnValues[1] ne '') && ($columnValues[2] ne '') && ($columnValues[3] ne '') && ($columnValues[18] ne '')) {
        $tmpString = $columnValues[0]."\t".$columnValues[1]."\t".$columnValues[2]."\t".$availabilityString ."\t".$columnValues[18]."\t".
                               $columnValues[6]."\t".$columnValues[7]."\t".$columnValues[5]."\n";
        print stockFilehandle $tmpString;
      }
     }
}

sub formatValue {
    my $iCounter = $_[0];
    my $value = $_[1];

    # Remove any of the non ascii characters; 
    $value =~ s/[^\x00-\x7F]+//g;

    if ( $columnNames[$iCounter] eq 'ISBN') {
       chomp($value);
       $value =~ s/[^0-9]+//g;
    }
    if ( $columnNames[$iCounter] eq 'TITLE') { $value =~ s/\n//g; }
    if ( $columnNames[$iCounter] eq 'AUTHOR') { $value =~ s/\n//g; }
    if ( $columnNames[$iCounter] eq 'DESCRIPTION') { $value =~ s/\n//g; }
    if ( $columnNames[$iCounter] eq 'PUBLISH-DATE') { $value =~ s/\n//g; }
    if ( $columnNames[$iCounter] eq 'PUBLISHER') { $value =~ s/\n//g; }
    if ( $columnNames[$iCounter] eq 'PAGES') { $value =~ s/\n//g; }
    if ( $columnNames[$iCounter] eq 'LANGUAGE') {
           if($value eq '') {
             $value = 'English';
           } else {
           $value =~ s/\n//g;
           }
    }
    if ( $columnNames[$iCounter] eq 'WEIGHT') { $value =~ s/\n//g; }
    if ( $columnNames[$iCounter] eq 'DIMENSION') { $value =~ s/\n//g; }
    if ( $columnNames[$iCounter] eq 'SHIP-REGION') { $value =~ s/\n//g; }
    if ( $columnNames[$iCounter] eq 'BISACCODE') { $value =~ s/\n//g; }
    if ( $columnNames[$iCounter] eq 'PRICE') { $value =~ s/\n//g; }
    if ( $columnNames[$iCounter] eq 'CURRENCY') {
           $value =~ s/\n//g;
         if ($value =~ /INR/) {
               $value ='I';
         } elsif ($value =~ /GBP/) {
                  $value = 'P';
         } elsif ($value =~ /USD/) {
                  $value = 'U';
         } elsif ($value =~ /SD/) {
                  $value = 'U';
         } elsif ($value =~ /EUR/) {
                  $value = 'E';
         } elsif ($value =~ /SGD/) {
                  $value = 'S';
         }
     }
    if ( $columnNames[$iCounter] eq 'AVAILABILITY') {
       $value =~ s/\n//g;
       if(($value eq 'Available') or ($value eq 'Preorder') or ($value eq 'Not Available')) {
       } elsif ($value gt 3){
           $value = 'Available';
       } else{
         $value = 'Not Available' . '[' . $value . ']'  ;
       }        
     }
     if ( $columnNames[$iCounter] eq 'IMPRINT') { $value =~ s/\n//g; }
     if ( $columnNames[$iCounter] eq 'SUPPLIER') { $value =~ s/\n//g; }
   return $value;
 }

close(catalogFilehandle);
if ( $stockFilename ne '') {
 close(stockFilehandle);
}

exit(0);

