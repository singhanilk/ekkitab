#!/usr/bin/perl
use Config::Abstract::Ini;
my $ekkitab_home = $ENV{EKKITAB_HOME};
if (!($ekkitab_home)){
print "Not Defined" . "\n";
}
my $Settingsfile = $ekkitab_home . "/config/stockprocess.ini";
my $settings     = new Config::Abstract::Ini($Settingsfile);
my %values       = $settings -> get_entry('ubs');
my $threshold    = $values{'availability'};
print "#ISBN\tPRICE\tCURRENCY\tAVAILABILITY\tSUPPLIER\tTITLE\tAUTHOR\n";
$/=undef;
open(FILE, $ARGV[0]) or die "cannot open input file";
my $file = <FILE>;
close(FILE);
my @isbns = $file =~ m/([0-9X]{10,14})<br>/g;
for (my $i=0; $i<=$#isbns; $i++) {
    $m1 = $isbns[$i]; 
    if ($i==$#isbns) {
        $m2 = "<hr>";
    }
    else {
        $m2 = $isbns[$i+1]; 
    }
    my @data = $file =~ m/($m1.*?)$m2/gs;
    if ($#data == 0) {
        $z = $data[0];
        $z =~ s/\n//g;
        my @fields = split(/<br>/gm,$z);
        #print "Count of fields: $#fields\n";
        my $q = $#fields+1;
        #print "[$q]\t$z\n";
        my $isbn = $fields[0];
        my $end;
        while ($q > 0) {
            if ($fields[$q-1] =~ /^[0-9.]+$/) {
               $end = $q - 1; 
               last;
            }
            $q--;
        }
        my $availability = '';
        my $stock = $fields[$end];
        if ($stock <= $threshold){
           $availability = 'Not Available' . '[' . $stock . ']';
        }
        else{
           $availability = 'Available' ;
        }
        my $currency = $fields[$end - 1];
        my $price = $fields[$end - 2];
        if($currency eq 'R'){
            $currency = 'I';
        }
        elsif($currency eq 'D'){
            $currency = 'U'
        }
        elsif($currency eq 'P'){
            $currency = 'P'
        }
        else {
            print STDERR "[ubs] Unknown currency '$currency' in input.\n";
            exit 1;
        }
        my $imprint = 'UBS';
        my $Title = 'Not Available';
        my $author= 'Not Available';
        if( (not (length($isbn) != 10) or (length($isbn) != 13)) or  $currency !~ /[A-Z]/ or $price !~ /[0-9]/){
            next;
        }
        else{
            print "$isbn\t$price\t$currency\t$availability\t$imprint\t$Title\t$author\n";
        }
    }
}
exit 0;
#print "Found: $#isbns isbns.\n";

