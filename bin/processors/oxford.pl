#!/usr/bin/perl -w
use strict;
use Spreadsheet::ParseExcel;
use Spreadsheet::ParseExcel::FmtDefault;

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
                    if ($oWkC->Value =~ /ISBN/) {
                        $isbncol = $iC;
                        next;
                    }
                }
                if ($pricecol == -1) {
                    if ($oWkC->Value =~ /INR\sPrice/) {
                        $pricecol = $iC;
                       # print "INR PRICE -- $pricecol [" . $oWkS->get_name() . "]\n";
                        next;
                    }
                }
                if ($pricecol == -1) {
                    if ($oWkC->Value =~ /INR/) {
                        $pricecol = $iC;
                        next;
                    }
                }
                if ($pricecol == -1) {
                    if ($oWkC->Value =~ /Price/) {
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
    		        if ($oWkC->Value =~ /Author/) {
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
   my $fmt = new  Spreadsheet::ParseExcel::FmtDefault;
   my %currencynames = ("IN" => "I", 
                        "INR" => "I", 
                        "GB" => "P", 
                        "GBP" => "P", 
                        "US" => "U", 
                        "USD" => "U");

    for (my $i = $startrow; $i <= $endrow; $i++) {
        my $currency = "";
        my $availability = 'Available';
        my $imprint = 'Oxford';
        my $value = $oWkS->{Cells}[$i][$isbncol];
        my $isbn;
        if (defined ($value)) {
           $isbn = $value->Value;
           chomp($isbn);
           $isbn =~ s/[^0-9]+//g;
           if(length($isbn) gt 10){
              $enteredcount++;
           }
        }
        $value = $oWkS->{Cells}[$i][$pricecol];
        my $price;
        if (defined ($value)) {
           $price = $value->unformatted();
           $price =~ s/\n//g;
           my @z = $price =~ m/([A-Z]{2,})/g;
           foreach my $name (@z) {
                foreach my $currencyname (keys(%currencynames)) {
                    if ($currencyname eq $name) {
                        $currency = $currencynames{$currencyname};
                        last;
                    }
                }
                if ($currency ne "") {
                    last;
                }
           }
           $price =~ s/[^0-9\.]//g;
           if ($currency eq "") {
                my $fmtstring = $fmt->FmtString($value, $oBook);
                $fmtstring =~ s/[^A-Z]//g;
                SWITCH: {
                        $fmtstring eq "INR" && do { $currency = "I"; last SWITCH; };
                        $fmtstring eq "USD" && do { $currency = "U"; last SWITCH; };
                        $fmtstring eq "GBP" && do { $currency = "P"; last SWITCH; };
                        $fmtstring eq "" && do { last SWITCH; };
                        $currency = "UNKNOWN";
                }
           }
           if ($currency eq "") {
                $currency = "I";
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
                  print $isbn  .  "\t" . $price . "\t" . $currency . "\t"  
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
