#!/usr/bin/perl
require LWP::UserAgent;
use DBI;
use Log::Log4perl;


# configurable properties
#------------------------------------------------------------------------------------------
$logconfig   = "spider.conf";
#------------------------------------------------------------------------------------------

# globals
#-----------------------------
%main     = ();
#-----------------------------

# initialize logging
Log::Log4perl->init($logconfig); 
$main{'log'} = Log::Log4perl->get_logger("spider.pl");

sub getTopCategories {
    my($url) = @_;

    my $ua = LWP::UserAgent->new;
    $ua->agent("Mozilla/5.0");
    $ua->timeout(100);
    $ua->env_proxy;

    my $results;
    my $response = $ua->get($url);
 
    if ($response->is_success) {
        $results = $response->decoded_content();  # or whatever
    }
    else {
        $main{'log'}->warn("URL error for search: $url. $@");
        die $response->status_line;
    }
    my @refs = ();
    my %top = ();
    if (defined $results) {
        $results =~ s/^.*?<h3>All Subjects:<\/h3><table(.*?)<\/table>.*$/$1/gs;
        @refs = $results =~ m/<a.*?href="(.*?)".*?>(.*?)<\/a>/g;
        for (my $i = 0; ($i <= $#refs); $i+=2) {
            $top{$refs[$i+1]} = $refs[$i];
        }
    }
    return %top;
}

sub getSubCategories {
    my($domain, $url, $key, $tab, $ua, @start) = @_;

    my $startcategory = shift(@start);
    #defined $startcategory && print "Looking for: $tab" . "$startcategory\n";

    my $results;
    my $response;

    do {
        eval {
            $response = $ua->get($url);
        };
        if ($@) {
            $main{'log'}->warn("URL error for search: $url. $@");
            sleep(10);
        }
        else {
            if ($response->is_success) {
                $results = $response->decoded_content();  # or whatever
            }
            else {
                $main{'log'}->warn("URL error for search: $url. $@");
                print "$response->status_line\n";
                sleep(10);
            }
        }
    } while (! (defined($response) && $response->is_success));
 
    my @refs = ();
    my %top = ();
    if (defined $results) {
        $key =~ s/([\(\+\)\[\]])/\\$1/gs;
        $results =~ s/^.*?class=\"categories_current\"><b>$key<\/b>(.*?)<\/div>.*$/$1/gs;
        @refs = $results =~ m/<a.*?href="(.*?)".*?>(.*?)<\/a>/g;
        for (my $i = 0; ($i <= $#refs); $i+=2) {
            if (defined $startcategory) {
                if ($refs[$i+1] ne $startcategory) {
                   next;
                } 
                else {
                   undef($startcategory);
                }
            }
            print FILE $tab.$refs[$i+1]."\n";
            print $tab.$refs[$i+1]."\n";
            my @copystart = @start;
            $top{$refs[$i+1]} = getSubCategories($domain, $domain.$refs[$i], $refs[$i+1], $tab."   ", $ua, @copystart);
            if (scalar($top{$refs[$i+1]}) > 0) {
                @start = ();
            } 
        }
    }
    return %top;
}

sub initLWP {
    my $ua = LWP::UserAgent->new;
    $ua->agent("Mozilla/5.0");
    $ua->timeout(10);
    $ua->env_proxy;
    return $ua;
}


# Main routine. 

sub init {
    my ($filename) = @_;
    my $last = "";
    open (FILE, $filename) or return $last;
    
    while (<FILE>) {
        $last = $_;
    }
    close (FILE);
    chomp($last);
    $last =~ s/^\s+//;
    return $last;
}

sub main {
    my (@start) = @_;
    $startcategory = shift(@start); 
    $main{'log'}->info('Started execution.');
    my $outputfile = "flipkart_categories";
    my %allcats = ();
    open (FILE, ">>$outputfile") or die "Cannot open output file.";
    $domain = "http://www.flipkart.com";
    $url = "$domain/all-subjects-books/1000-0";
    my $ua = initLWP();
    %cats = getTopCategories($url);

    my $i = 0;
    while (($key, $value) = each (%cats)) {
        if (defined $startcategory) {
           if ($key ne $startcategory) {
                next;
           } 
           else {
               undef($startcategory);
           }
        }
        print FILE "$key\n";
        print "$key\n";
        $allcats{$key} = getSubCategories($domain, $domain.$value, $key, "   ", $ua, @start);
    }
    close(FILE);
    $main{'log'}->info('Completed execution.');
}

$startcategory = "";
@start = ();
if ($#ARGV >= 0) {
    $startcategory = $ARGV[0];
    @start = split(/%/, $startcategory);
}
main(@start);
