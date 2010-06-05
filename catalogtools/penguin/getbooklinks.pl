#!/usr/bin/perl
require LWP::UserAgent;
use HTML::Entities;

$count = 0;

sub initLWP {
    my $ua = LWP::UserAgent->new;
    $ua->agent("Mozilla/5.0");
    $ua->timeout(10);
    $ua->env_proxy;
    return $ua;
}

sub getBookHtml {
    my ($ua, $path) = @_;
    print "URL>> " . $path . "\n";
    my $response = $ua->get($path);
    if ($response->is_success) {
        return $response->decoded_content(); 
    }
    return "";
}

sub getBooks {
    my ($ua, $category, $path) = @_;
    my $htmlpage = getBookHtml($ua, $path);
    my $status = 0;
    if ($htmlpage ne "") {
        @links = $htmlpage =~ m/<a id=".*?_viewdetail".*?href="(.*?)">.*?<img src="\/image\/viewdetail.gif".*?<\/a>/gsm;
        foreach my $link (@links) {
            my @isbn = $link =~ m/.*?_([0-9]{13}).aspx/g;
            $id = 0;
            if ($#isbn == 0) {
                $id = $isbn[0];
            }
            print OUTPUT $id . "\t" . $category . "\t" . $link . "\n";
        }
        @pages = $htmlpage =~ m/<a id="control_paging_dlPaging_.*?_link_paging".*?href="(.*?)".*?\/a>/gsm;
        foreach my $page (@pages) {
            if ($status >= 0) {
                my $htmlpage = getBookHtml($ua, "http://www.penguinbooksindia.com" . $page);
                if ($htmlpage ne "") {
                    @links = $htmlpage =~ m/<a id=".*?_viewdetail".*?href="(.*?)">.*?<img src="\/image\/viewdetail.gif".*?<\/a>/gsm;
                    foreach my $link (@links) {
                        my @isbn = $link =~ m/.*?_([0-9]{13}).aspx/g;
                        $id = 0;
                        if ($#isbn == 0) {
                            $id = $isbn[0];
                        }
                        print OUTPUT $id . "\t" . $category . "\t" . $link . "\n";
                    }
                }
                else {
                    $status = -1;
                }
            }
        }
    }
    else {
        $status = -1;
    }
    return $status;
}

sub main {
    open (FILE, "penguinindia_categories.txt") or die "Cannot open categories file"; 
    my $ua = initLWP();
    my $status = 0;
    while ((my $line = <FILE>) and ($status >= 0)) {
        chomp($line);
        #print $line . "\n";
        if ($line =~ /^#/) {
            #print ">> Ignored!" . "\n";
            next;
        }
        my @data = split /\t/, $line;
        my $category = $data[0];
        my $url = "http://www.penguinbooksindia.com" . $data[1];
        my $status = getBooks($ua, $category, $url);
    }
    print "Book links collected for $count books.\n";
    close(FILE);
    close(OUTPUT);
}
open (OUTPUT, ">>", "penguinindia_books.txt") or die "Cannot open books file for writing"; 
OUTPUT->autoflush(1);
main();
