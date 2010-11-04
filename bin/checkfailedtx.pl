#!/usr/bin/perl
use MIME::Lite;
use File::Basename;


$EKKITAB_HOME=$ENV{'EKKITAB_HOME'};
if (!defined($EKKITAB_HOME)) {
    print "[Fatal] EKKITAB_HOME is not set.\n";
    exit(1);
}

use constant BCC => "anil\@ekkitab.com, vijay\@ekkitab.com";
use constant SUBJECT => "Support from Ekkitab. Your recent difficulty in buying books from us.";
use constant TEMPLATEFILE => "/data/checkfailedtx.html";

sub sendmail {
   my ($email, $content) = @_;
       
   my $msg = MIME::Lite->new(
                'Encoding'    => "quoted-printable",
                'Charset'     => "utf8",
                'From'        => "\"Team Ekkitab\" <support\@ekkitab.com>",
                'Type'        => "text/html",
                'To'          => $email, 
                'Bcc'         => BCC, 
                'Subject'     => SUBJECT,
                'Data'        => $content);

   #print "Sending mail to: $email\n";
   $msg->send('smtp', 'smtpout.secureserver.net', AuthUser=>'support@ekkitab.com', AuthPass=>'eki22Ab');
}

my $filename=`date +%d%b%Y`;
$filename="/tmp/failedtx_" . $filename;
if (-e $filename) {
    unlink($filename);
}
system("php $EKKITAB_HOME/bin/checkfailedtx.php > $filename");

open(TEMPLATE, "$EKKITAB_HOME".TEMPLATEFILE);
my $saved = $/;
local $/ = undef;
my $template = <TEMPLATE>;
close(TEMPLATE);
$/ = $saved;
open (FILE, $filename) or die "Cannot open file $filename";
my %rows;
while (<FILE>) {
	if (!($_ =~ /^#/)) {
	   chomp;
	   my @line = split /\t/,$_;
	   if (!defined($rows{$line[0]})) {
	      my @books;
          $rows{$line[0]}{'name'} = $line[1];
          $rows{$line[0]}{'books'} = \@books;
	   }
       $books = $rows{$line[0]}{'books'}; 
       push(@$books, $line[2]);
	}
}
close (FILE);
foreach my $email (keys(%rows)) {
    my $content = $template;
    my $name = $rows{$email}{'name'};
    my $books = $rows{$email}{'books'};
    my $titles = "";
    foreach my $title (@$books) {
	   $titles .= "<tr>\n<td style=\"padding-right: 9px; padding-left: 9px; padding-bottom: 3px; padding-top: 3px\" valign=\"top\" align=\"left\"><strong>$title</strong></td>\n</tr>\n";
    }
    $content =~ s/\[% Name %\]/$name/g;
    $content =~ s/\[% Titles %\]/$titles/g;
    sendmail($email, $content) ;
}
