#!/usr/bin/perl
use strict;

die "Usage $0 <File>\nRedirect output to required file from stdout" unless $#ARGV >= 0;
my $inputfile = $ARGV[0];
print "#ISBN\t" . "PRICE\t" . "CURRENCY\t" . "AVAILABILITY\t" . "IMPRINT\t" . "TITLE\t" . "AUTHOR\n" ;

open (FILE, $inputfile) or die "Cannot open input file: $inputfile";

while (my $line = <FILE>) {
    $line =~ s/[\000-\011 \016-\037]/ /g;  # Strip away all control characters.

    my $len = length($line) > 118 ? 118 : length($line)-3;  # 118 is max line length;

    $line = substr($line, 2, $len);

    if (substr($line, 2, 1)=~ /[0-9]/) {  # This line contains ISBN tock data

        my $isbn = substr($line, 2, 13);
        chomp($isbn);

        my $author = substr($line, 16, 15);
        chomp($author);

        my $title = substr($line, 31, 50);
        chomp($title);

        my $price = substr($line, 81, 7);
        chomp($price);

        my $currency = substr($line, 89, 3);
        chomp($currency);

        my $stock = substr($line, 103, 3);
        chomp($stock);

        $stock = int($stock);
        my $available = "Not Available";
        if ($stock > 0) {
            $available = "Available";
        }

        my $imprint = "Unknown";

        print "$isbn\t$price\t$currency\t$available\t$imprint\t$title\t$author\n";
    }
}
close (FILE);
