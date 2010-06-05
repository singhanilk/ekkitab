#!/usr/bin/perl
require LWP::UserAgent;
use HTML::Entities;

sub getTitle {
    my ($htmlpage) = @_;
    my @titles = $htmlpage =~ m/<span id=\"lbl_bookname\" +title=\".*?\">(.*?)<\/span><span id=\"lbl_title\".*?>(.*?)<\/span>/gs;
    #print ">> $#titles\n";
    my @results = ();
    if ($#titles >= 0) {
        for (my $i = 0; $i <= $#titles; $i++) {
            $titles[$i] =~ s/^\s+//;
            $titles[$i] =~ s/\s+$//;
        }
        for (my $i = 0, my $j = 0; $i <= $#titles; $i++) {
           if ($titles[$i] ne "") {
                $results[$j++] = $titles[$i]; 
           }
        }
    }
    my $sendback = "";
    foreach my $result (@results) {
        $sendback = $sendback . $result;
    }
    $sendback =~ s/^ +//;
    return ($sendback);
}

sub getAuthor {
    my ($htmlpage) = @_;
    my @authors = $htmlpage =~ m/<span id=\"(lbl_T1|lbl_T2|lbl_T3|lbl_T4|lbl_T5)\" +style=\".*?\">(.*?)<\/span>\s+<a id=\".*?\".*?href=\".*?\".*?>(.*?)<\/a>/gs;
    my @results = ();
    if ($#authors >= 0) {
        for (my $i = 0; $i <= $#authors; $i++) {
            $authors[$i] =~ s/^\s+//;
            $authors[$i] =~ s/\s+$//;
        }
        for (my $i = 1; $i <= $#authors; $i+=3) {
            if ($authors[$i] =~ /(e|E)dit/) {
                $authors[$i+1] = ":e:" . $authors[$i+1]; 
            }
            if ($authors[$i] =~ /(t|T)ranslate/) {
                $authors[$i+1] = ":t:" . $authors[$i+1]; 
            }
        }
        for (my $i = 2, my $j = 0; $i <= $#authors; $i+=3) {
           if ($authors[$i] ne "") {
                $results[$j++] = $authors[$i]; 
           }
        }
    }
    my $sendback = "";
    foreach my $result (@results) {
        $sendback = $sendback . "&" . $result;
    }
    $sendback =~ s/^&//;
    return ($sendback);
}

sub getImage {
    my ($htmlpage) = @_;
    my @images = $htmlpage =~ m/<img id=\"img_book\" title=\".*?\" src=\"(.*?)\".*?\/>/gs;
    my @results = ();
    if ($#images >= 0) {
        for (my $i = 0; $i <= $#images; $i++) {
            $images[$i] =~ s/^\s+//;
            $images[$i] =~ s/\s+$//;
        }
        for (my $i = 0, my $j = 0; $i <= $#images; $i++) {
           if ($images[$i] ne "") {
                $results[$j++] = "http://www.penguinbooksindia.com" . $images[$i]; 
           }
        }
    }
    my $sendback = "";
    foreach my $result (@results) {
        $sendback = $sendback . " & " . $result;
    }
    $sendback =~ s/^\s&//;
    return ($sendback);
}

sub getDescription {
    my ($htmlpage) = @_;
    my @descriptions = $htmlpage =~ m/<span id=\"lbl_bookdetail\"(.*?)<\/div>/gs;
    my @paras = ();
    if ($#descriptions >= 0) {
        for (my $i = 0, my $j = 0; $i <= $#descriptions; $i++) {
           if ($descriptions[$i] ne "") {
              $p = $descriptions[$i];
              #$p =~ s/&nbsp;//;
              $p = decode_entities($p);
              $p =~s/([^\x00-\x7f])/sprintf('&#%d;', ord($1))/ge;
              $p =~ s/class=\".*?\"//gs;
              $p =~ s/style=\".*?\"//gs;
              $p =~ s/title=\".*?\"//gs;
              $p =~ s/<a\s.*?<\/a>//gs;
              $p =~ s/<br\s*\/>/\n/gs;
              $p =~ s/<\/p>/\n/gs;
              $p =~ s/<.*?\/*>//gs;
              $p =~ s/<\/.*?>//gs;
              $p =~ s/(\n\s*)+/<br\/>/gs;
              $p =~ s/\s+<br\/>/<br\/>/gs;
              $p =~ s/^>//gs;
              if ($p ne "") {
                  push(@paras, $p);
              }
           }
        }
    }
    my $sendback = "";
    foreach my $para (@paras) {
        $sendback = $sendback . " " . $para;
    }
    $sendback =~ s/^ +//;
    return ($sendback);
}

sub getDetail {
    my ($htmlpage) = @_;

    my %check = ();
    $check{'publisher'} = "lbl_publishedby";
    $check{'date'}      = "lbl_pub";
    $check{'imprint'}   = "lbl_imprint";
    $check{'edition'}   = "lbl_edition";
    $check{'pages'}     = "lbl_extent";
    $check{'format'}    = "lbl_format";
    $check{'subject'}   = "lbl_classi";
    $check{'currency'}  = "lbl_cursp";
    $check{'price'}     = "lbl_sprice";
    my %result = ();

    foreach my $key (keys (%check)) {
        my $checkstring = $check{$key};
        my @tmp = $htmlpage =~ m/<span id=\"$checkstring\" +class=\".*?\">(.*?)<\/span>/gs;
        my @results = ();
        if ($#tmp >= 0) {
            for (my $i = 0; $i <= $#tmp; $i++) {
                $tmp[$i] =~ s/^\s+//;
                $tmp[$i] =~ s/\s+$//;
            }
            for (my $i = 0, my $j = 0; $i <= $#tmp; $i++) {
                if ($tmp[$i] ne "") {
                    $results[$j++] = $tmp[$i]; 
                }
            }
        }
        my $sendback = "";
        foreach my $result (@results) {
            $sendback = $sendback . " " . $result;
        }
        $sendback =~ s/^ +//;
        $result{$key} = $sendback;
    }
    return %result;
}

sub initLWP {
    my $ua = LWP::UserAgent->new;
    $ua->agent("Mozilla/5.0");
    $ua->timeout(10);
    $ua->env_proxy;
    return $ua;
}

sub getBookHtml {
    my ($ua, $path) = @_;
    my $url = "http://www.penguinbooksindia.com" . $path;
    my $response = $ua->get($url);
    if ($response->is_success) {
        return $response->decoded_content(); 
    }
    return ""; 
}

sub writeBookDetails {
    my ($isbn, $htmlpage) = @_;
    #my $title = getTitle($htmlpage);
    #my $author = getAuthor($htmlpage);
    my $image = getImage($htmlpage);
    #my $description = getDescription($htmlpage);
    #my %detail = getDetail($htmlpage);
    #my $publisher = $detail{'publisher'};
    #my $publishdate = $detail{'date'};
    #my $imprint = $detail{'imprint'};
    #my $binding = $detail{'edition'};
    #my $pagecount = $detail{'pages'};
    #my $format = $detail{'format'};
    #my $subject = $detail{'subject'};
    #my $currency = $detail{'currency'};
    #my $price = $detail{'price'};
    #my $line = "$isbn\t$title\t$author\t$description\t$publisher\t$publishdate\t$imprint\t$binding\t$pagecount\t$format\t$subject\t$currency\t$price\n";
    my $line = "";
    my $suffix = substr($image, -4, 4);
    if (not $image =~ /notfound/) {
        $imageloc = "./images/" . $isbn . $suffix;
        system("wget $image -O $imageloc >/dev/null 2>&1"); 
        $icount++;
    }
    else {
	$line = $isbn;
    }
    return $line;
}

sub main {
    open (FILE, "jj") or die "Cannot open input file: ";
    my $ua = initLWP();
    open (OUTPUT, ">", "jjout.txt") or die "Cannot open output file"; 
    OUTPUT->autoflush(1);
    my $i = 0;
    while (my $line = <FILE>) {
      chomp($line);
      $i++;
      my @fields = split /\t/,$line; 
      my $isbn = $fields[0];
      my $path = $fields[2];
      $htmlpage = getBookHtml($ua, $path);
      if ($htmlpage ne "") {
         $details = writeBookDetails($isbn, $htmlpage);
         if ($details ne "") {
         	print OUTPUT $details . "\t" . $path . "\n";
         }
      }
      if (($i % 10) == 0) {
        print "Completed $i books...[$icount images retrieved].\n";
        last;
      }
    }
    print "Completed $i books. Images for [$icount] books retrieved.\n";
    close(FILE);
    close(OUTPUT);
}
$icount = 0;
main();
