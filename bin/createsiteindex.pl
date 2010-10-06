#!/usr/bin/perl

require LWP::UserAgent;
use HTML::Entities;
use Encode;

my  $outputdir = "/tmp";
use constant MAXBOOKS_PER_FILE => 45000;

sub getDate {
    my ($d,$m,$y) = (localtime)[3,4,5];
    $y = $y+1900;
    $m = $m + 1;
    if ($m < 10) {
        $m = "0" . $m;
    }
    if ($d < 10) {
        $d = "0" . $d;
    }
    my $date = "$y-$m-$d";
    return $date;
}


sub initLWP {
    my $ua = LWP::UserAgent->new;
    $ua->agent("Mozilla/5.0");
    $ua->timeout(10);
    $ua->env_proxy;
    return $ua;
}

sub getUrl {
    my ($ua, $url) = @_;
    my $retries = 10;
    my $response;
    my $page = "";
    while ($retries > 0) {
        $response = $ua->get($url);
        if ($response->is_success) {
            $page = $response->decoded_content();  
            last;
        }
        else {
            sleep(10);
            $retries--; 
        }
    }
    return $page;
}

sub getCatalog {
    my ($ua) = @_;
    my $url = 'http://EkkitabUser:eki22AbSt0re@www.ekkitab.co.in/all-books';
    my $htmlpage = getUrl($ua, $url);
    if ($htmlpage eq "") {
        die "[Fatal] Failed to fetch page: $url\n";
    }
    return $htmlpage; 
}

sub getTopLinks {
    my ($page) = @_;
    my @links = $page =~ m/<a class=\"slots\" href=\"(.*?)\">/gs;
    return @links;
}

sub getNextLinks {
    my ($ua, $url) = @_;
    my @links;
    $url =~ s/http:\/\///g;
    $url = "http://EkkitabUser:eki22AbSt0re@".$url;
    my $htmlpage = getUrl($ua, $url);
    if ($htmlpage eq "") {
        die "[Fatal] Failed to fetch page: $url\n";
    }
    @links = getTopLinks($htmlpage);
    return @links; 
}

sub getBooks {
    my ($ua, $url) = @_;
    my @booklinks;
    $url =~ s/http:\/\///g;
    $url = "http://EkkitabUser:eki22AbSt0re@".$url;
    my $htmlpage = getUrl($ua, $url);
    if ($htmlpage eq "") {
        die "[Fatal] Failed to fetch page: $url\n";
    }
    @booklinks = $htmlpage =~ m/<div class=\"lineHeight14em\">.*?<a href=\"(.*?)\"/gs;
    return @booklinks; 
}
{
    my $sitemap_index = undef;
    my $sitemap_filename = "";
    my $fd_sitemap = undef;

    sub openSitemapFile {
        if (!defined($sitemap_index)) {
            $sitemap_index = 0;
        }
        else {
            $sitemap_index++;
        }
        $sitemap_filename = "sitemap" . $sitemap_index . ".xml";
        my $outputfile = $outputdir . "/" . $sitemap_filename;
        open ($fd_sitemap, "> $outputfile") or die "[Fatal] Cannot open output file: $outputfile";
        $fd_sitemap->autoflush(1);
        binmode($fd_sitemap, ":utf8");
        print $fd_sitemap '<?xml version="1.0" encoding="UTF-8"?>' . "\n";
        print $fd_sitemap '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">' . "\n";
    }

    sub closeSitemapFile {
        print $fd_sitemap '</urlset>' . "\n";
        close ($fd_sitemap);
        $fd_sitemap = undef;
        writeSitemapToIndex($sitemap_filename);  
        my $filename = $outputdir . "/" . $sitemap_filename;
        $success = system("gzip $filename");
        if ($success != 0) {
            print "[Warning] Gzip of $filename failed.\n";
        }
    }

    sub getSitemapHandle {
        if (!defined($fd_sitemap)) {
            openSitemapFile();
        }
        return $fd_sitemap;
    }
}

{
    my $fd_index = undef;
    sub openSitemapIndex {
        my $index_filename = $outputdir . "/sitemap_index.xml";
        open ($fd_index, "> $index_filename") or die "[Fatal] Cannot open output file: $index_filename";
        $fd_index->autoflush(1);
        binmode($fd_index, ":utf8");
        print $fd_index "<sitemapindex xsi:schemaLocation=\"http://www.sitemaps.org/schemas/sitemap/0.9\thttp://www.sitemaps.org/schemas/sitemap/0.9/siteindex.xsd\">\n";
    }

    sub closeSitemapIndex {
        print $fd_index '</sitemapindex>' . "\n";
        close ($fd_index);
        $fd_index = undef;
    }

    sub writeSitemapToIndex {
        my ($filename) = @_;
        if (!defined($fd_index)) {
            openSitemapIndex();
        }
        my $date = getDate();
        $filename = "http://www.ekkitab.com/" . $filename . ".gz";
        print $fd_index "<sitemap>\n  <loc>$filename</loc>\n  <lastmod>$date</lastmod>\n</sitemap>\n";
    }
}

{
    my $bookcount = 0;
    sub writeLinks {
        my (@books) = @_;

        my $fd = getSitemapHandle();
        foreach my $book (@books) {
            $book =~ s/ekkitab\.co\.in/ekkitab\.com/g;
            print $fd "<url>\n  <loc>$book</loc>\n</url>\n";
            $bookcount++;
            if ($bookcount > MAXBOOKS_PER_FILE) {
                closeSitemapFile();
                openSitemapFile();
                $bookcount = 0;
            }
        }
    }
}


sub getHomePageLinks {
    my ($ua) = @_;
    my $url = 'http://EkkitabUser:eki22AbSt0re@www.ekkitab.co.in';
    my $htmlpage = getUrl($ua, $url);
    if ($htmlpage eq "") {
        die "[Fatal] Could not read home page at: $url\n";
    }
    my %sitelinks;
    my @links = $htmlpage =~ m/(http:\/\/[^ \n\'\"]*)/gs;
    foreach my $link (@links) {
        $link =~ s/ekkitab\.co\.in/ekkitab\.com/g;
        SWITCH: {
           $link =~ /globalsection/ && do { $sitelinks{$link} = "weekly"; last SWITCH; };
           $link =~ /leftlinks/ && do { $sitelinks{$link} = "weekly"; last SWITCH; };
           $link =~ /category\/viewAll/ && do { $sitelinks{$link} = "weekly"; last SWITCH; };
           #$link =~ /all-books/ && do { $sitelinks{$link} = "daily"; last SWITCH; };
           #$link =~ /blog\.ekkitab\.com/ && do { $sitelinks{$link} = "weekly"; last SWITCH; };
        }
    }
    return %sitelinks;
}



#########################
# Start of main program
#########################

my @args = @_;
if ($#args >= 0) {
    $outputdir = $args[0];
} 
print "[Info] Creating sitemap index and catalog indexes in dir: $outputdir.\n";

$enc = find_encoding("utf-8");

my $ua = initLWP();

##########################################################
# Create the sitemap for the basic links on the home page 
##########################################################

openSitemapFile();
my %sitelinks = getHomePageLinks($ua);
my $fd = getSitemapHandle();
print $fd "<url>\n  <loc>http://www.ekkitab.com/</loc>\n  <priority>0.9</priority>\n  <changefreq>weekly</changefreq>\n</url>\n";
foreach my $link (keys(%sitelinks)) {
   print $fd "<url>\n  <loc>" . $link . "</loc>\n  <priority>0.5</priority>\n  <changefreq>" . $sitelinks{$link} . "</changefreq>\n</url>" . "\n";
}
closeSitemapFile();
    
##########################################################
# Now, create the sitemaps for the books. 
##########################################################

$page = getCatalog($ua);
if ($page eq "") {
    die "[Fatal] Could not read catalog page at http://www.ekkitab.co.in/all-books\n";
}

@toplinks = getTopLinks($page);
foreach my $toplink (@toplinks) {
    @nextlinks = getNextLinks($ua, $toplink);
    foreach my $nextlink (@nextlinks) {
        print "Processing: $nextlink\n";
        @books = getBooks($ua, $nextlink);
        writeLinks(@books);
    }
}
closeSitemapFile(); 
closeSitemapIndex();
