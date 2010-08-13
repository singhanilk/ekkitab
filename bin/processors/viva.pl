#!/usr/bin/perl

use Config::Abstract::Ini;


my $ekkitab_home = $ENV{EKKITAB_HOME};
if (!($ekkitab_home)){
print "Not Defined" . "\n";
}


my $Settingsfile = $ekkitab_home . "/config/stockprocess.ini";
my $settings     = new Config::Abstract::Ini($Settingsfile);
my %values       = $settings -> get_entry('availability');
my $threshold    = $values{'threshold'};
my $imprint      = 'Not Available';
my $author       = 'Not Available';


print "#ISBN\tPRICE\tCURRENCY\tAVAILABILITY\tIMPRINT\tTITLE\tAUTHOR\n";


$/=undef;
open(FILE, $ARGV[0]) or die "cannot open input file";
my $file = <FILE>;
close(FILE);


my @isbns = $file =~ m/([0-9X]{10,14})\&nbsp/g;
for (my $i=0; $i<=$#isbns; $i++) {
    $m1 = $isbns[$i]; 
    if ($i==$#isbns) {
        $m2 = "<hr>";
    }
    else {
        $m2 = $isbns[$i+1]; 
    }
    my @data = $file =~ m/($m1.*?)$m2/gs;
    if($#data == 0) {
        $z = $data[0];
        $z =~ s/\n//g;
        my @fields = split(/<br>/gm,$z);
        my $q = $#fields+1;
        @isbn = split(/[^0-9x]{10,14}/gm,$fields[0]);
        $isbn = $isbn[0];
        $fields[0] =~ s/([0-9x]{10,14})//g; 
        $Title = $fields[0];
        $Title =~ s/&nbsp;//g;
        $fields[1] =~ s/&nbsp;//g;
            if(($fields[1] eq ' ')){
                $fields[1] = $fields[2];
                $fields[2] = $fields[3];
                $fields[3] = $fields[4];
                $fields[4] = $fields[5];
            }
        $currency_price = $fields[1];
        $currency_price =~ s/&nbsp;//g;
        $fields[2] =~ s/&nbsp;//g;
        $fields[3] =~ s/&nbsp;//g;
        $fields[4] =~ s/&nbsp;//g;
            if($currency_price =~ /Rs/){
                $currency = 'I';
                $price = $fields[2];
                $stock = $fields[3]; 
            }
            elsif ($currency_price =~ /PND/){
                    $currency = 'P';
                    $currency_price =~ m/PND.?(.*)/g;
                    $price = $1 ;
                    $currency_price =~ s/[^0-9.]//g;
                    $stock = $fields[2];
            }
            elsif ($currency_price =~ /US\$/){
                    $currency = 'U';
                    $currency_price =~ m/US\$.?(.*)/g;
                    $price = $1 ;
                    $currency_price =~ s/[^0-9.]//g;
                    $stock = $fields[2];
            }
            elsif ($currency_price =~ /EURO/){
                    $currency = 'E';
                    $currency_price =~ m/EURO.?(.*)/g;
                    $price = $1 ;
                    $currency_price =~ s/[^0-9.]//g;
                    $stock = $fields[2];
            }
            elsif ($currency_price){
                    print STDERR "Unavaliable Price --> $currency_price ISBN -> $isbn\n";
            }
            $stock =~s/\s//g;
            if ($stock <= $threshold){
                $availability = 'Not Available' . '[' . $stock . ']';
            }
            else{
                $availability = 'Available' ;
            }
        if((not (length($isbn) != 10) or (length($isbn) != 13)) or  $currency !~ /[A-Z]/ or $price !~ /[0-9]/){
            next;
        }
        else{
            print "$isbn\t$price\t$currency\t$availability\t$imprint\t$Title\t$author\n";
        }
    }
}
exit 0;

