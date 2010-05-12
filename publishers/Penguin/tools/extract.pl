#!/usr/bin/perl

# This is not a generic script! It has been written for very specific input and in order to generate
# very specific output.
# This script takes, as input, a file which contains book data. This data is specified in a tab separated format
# and every line is a different book.
# ISBN information is specified in field 1 and 'path' information in field 2.   
# The path is a the part of the 'url' that extends beyond the base which is 'www.penguinbooksindia.com'.
# The specified url is fetched and the following information read from the received html page:
# Title
# Authors
# Image url (which is then subsequently downloaded)
# Publishing date
# Publisher
# Number of pages
# Format
# Classification.
# This collected information is written to the output file in a tab separated format - each line representing a book.

require LWP::UserAgent;
use HTML::Entities;

my $htmlpage;

sub getTitle {
    my @titles = $htmlpage =~ m/<span id=\"lbl_bookname\" +title=\".*?\">(.*?)<\/span><span id=\"lbl_title\">(.*?)<\/span>/gs;
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
        $sendback = $sendback . " " . $result;
    }
    $sendback =~ s/^ +//;
    return ($sendback);
}

sub getAuthor {
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
        }
        for (my $i = 2, my $j = 0; $i <= $#authors; $i+=3) {
           if ($authors[$i] ne "") {
                $results[$j++] = $authors[$i]; 
           }
        }
    }
    my $sendback = "";
    foreach my $result (@results) {
        $sendback = $sendback . " " . $result;
    }
    $sendback =~ s/^ +//;
    return ($sendback);
}

sub getImage {
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
    my @descriptions = $htmlpage =~ m/<span id=\"lbl_bookdetail\">(.*?)<\/div>/gs;
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
              $p =~ s/<br\s*\/>/\n/gs;
              $p =~ s/<\/p>/\n/gs;
              $p =~ s/<.*?\/*>//gs;
              $p =~ s/<\/.*?>//gs;
              $p =~ s/(\n\s*)+/<br\/>/gs;
              $p =~ s/\s+<br\/>/<br\/>/gs;
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
    my ($checkstring) = @_;
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
    return ($sendback);
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
        $htmlpage = $response->decoded_content();  # or whatever
    }
    else {
        $htmlpage = "";
        return -1;
    }
    return 0; 
}

sub writeBookDetails {
    my ($isbn) = @_;
    $title = getTitle();
    $author = getAuthor();
    $image = getImage();
    $description = getDescription();
    $publisher = getDetail("lbl_publishedby");
    $publishdate = getDetail("lbl_pub");
    $imprint = getDetail("lbl_imprint");
    $binding = getDetail("lbl_edition");
    $pagecount = getDetail("lbl_extent");
    $format = getDetail("lbl_format");
    $subject = getDetail("lbl_classi");
    my $line = "$isbn\t$title\t$author\t$description\t$publisher\t$publishdate\t$imprint\t$binding\t$pagecount\t$format\t$subject\n";
    my $suffix = substr($image, -4, 4);
    $imageloc = "/var/www/scm/images/penguin/" . $isbn . $suffix;
    system("wget $image -O $imageloc >/dev/null 2>&1"); 
    return $line;
}

sub main {
    if ($#ARGV != 0) {
        print "Insufficient arguments!\n";
        print "Usage: extract.pl <source file>\n";
        exit(1);
    }
    my $input = $ARGV[0];
    my $ua = initLWP();
    open (FILE, $input) or die "Cannot open input file: " . $input;
    open (OUTPUT, ">>penguinbooks-import.txt") or die "Cannot open output file"; 
    OUTPUT->autoflush(1);
    $i = 0;
    $got = 0;
    while (my $line = <FILE>) {
      chomp($line);
      $i++;
      my @fields = split /\t/,$line; 
      my $isbn = $fields[1];
      my $path = $fields[2];
      if ($path ne "NO INFORMATION") {
        $success = getBookHtml($ua, $path);
        if ($success == 0) {
            $got++;
            $details = writeBookDetails($isbn);
            print OUTPUT $details;
        }
        else {
            print OUTPUT ">>> Error:  $isbn\n";
        }
      }
      if (($i % 10) == 0) {
          print "$i lines processed. $got defined.\n";
      }
    }
    close(FILE);
    close(OUTPUT);
}
main();
