#!/usr/bin/perl
use DBI;

sub checkBook {
    my ($dbh, $isbn) = @_;
    my $sql = "select isbn from books where isbn = '$isbn'";
    my $sth = $dbh->prepare($sql);
    $sth->execute() or die "Sql error: $DBI::errstr\n";
    my $count = 0;
    while (@row = $sth->fetchrow_array) {
        $count++;
    }
    return $count;
}

if ($#ARGV != 2) {
   print "Insufficient arguments!\n";
   print "Usage: checkbooks.pl <menu file> <db user> <db password>\n";
   exit(1);
}
my $inputfile = $ARGV[0];
my $dbuser    = $ARGV[1];
my $dbpass    = $ARGV[2];

local $/ = undef;
open(FILE, $inputfile) or die "Could not open input file: $inputfile.\n";

my $xml = <FILE>;

@isbns = $xml =~ m/([0-9X]{13})/g;
$missingbooks = ();

$dbh = DBI->connect('dbi:mysql:ekkitab_books', $dbuser, $dbpass) or die "Connection error: $DBI::errstr\n";

my $i = 0;
foreach my $isbn (@isbns) {
    $i++;
    if (!checkBook($dbh, $isbn)) {
        push (@missingbooks, $isbn);
    }
}

if ($#missingbooks >= 0) {
    print "The following " .($#missingbooks + 1) . " book(s) are missing: \n";
    foreach my $book (@missingbooks) {
       print "$book\n"; 
    }
}
else {
    print "No books are missing.\n";
}
