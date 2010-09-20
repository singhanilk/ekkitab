#!/usr/bin/perl

require LWP::UserAgent;
use HTML::Entities;
use Encode;

sub initLWP {
    my $ua = LWP::UserAgent->new;
    $ua->agent("Mozilla/5.0");
    $ua->timeout(10);
    $ua->env_proxy;
    return $ua;
}

sub getHomePage {
    my ($ua) = @_;
    my $url = 'http://EkkitabUser:eki22AbSt0re@www.ekkitab.co.in';
    my $response = $ua->get($url);
    if ($response->is_success) {
        $htmlpage = $response->decoded_content();  # or whatever
    }
    else {
        $htmlpage = "";
    }
    return $htmlpage; 
}

sub main {
    my @args = @_;
    my $outputfile = "sitemap.xml";
    if ($#args >= 0) {
       $outputfile = $args[0];
    } 
    print "[Info] Creating sitemap in file: $outputfile.\n";
    $enc = find_encoding("utf-8");
    my $ua = initLWP();
    $page = getHomePage($ua);
    #open (FILE, "ekkitab.html") or die "Cannot open input file: ";
    #local $/ = undef;
    #my $line = <FILE>;
    if ($page eq "") {
        print "[Fatal] Could not read home page at http://www.ekkitab.co.in\n";
    }
    my %sitelinks;
    my @links = $page =~ m/(http:\/\/[^ \n\'\"]*)/gs;
    foreach my $link (@links) {
        $link =~ s/ekkitab\.co\.in/ekkitab\.com/g;
        SWITCH: {
           $link =~ /globalsection/ && do { $sitelinks{$link} = "weekly"; last SWITCH; }; 
           $link =~ /leftlinks/ && do { $sitelinks{$link} = "weekly"; last SWITCH; }; 
           $link =~ /category\/viewAll/ && do { $sitelinks{$link} = "weekly"; last SWITCH; }; 
           $link =~ /all-books/ && do { $sitelinks{$link} = "daily"; last SWITCH; }; 
           $link =~ /blog\.ekkitab\.com/ && do { $sitelinks{$link} = "weekly"; last SWITCH; }; 
        }
    } 
    close(FILE);
    open (OUTPUT, "> $outputfile") or die "[Fatal] Cannot open output file: ";
    OUTPUT->autoflush(1);
    print OUTPUT '<?xml version="1.0" encoding="UTF-8"?>' . "\n";
    print OUTPUT '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">' . "\n";
    print OUTPUT '<url><loc>http://www.ekkitab.com</loc><priority>0.9</priority><changefreq>weekly</changefreq></url>' . "\n";
    foreach my $link (keys(%sitelinks)) {
        print OUTPUT '<url><loc>' . $link . '</loc><priority>0.5</priority><changefreq>' . $sitelinks{$link} . '</changefreq></url>' . "\n";
    }
    print OUTPUT '</urlset>' . "\n";

    close(OUTPUT);
}
main(@ARGV);
