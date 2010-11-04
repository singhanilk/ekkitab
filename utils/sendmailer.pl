#!/usr/bin/perl
use MIME::Lite::TT::HTML;
use File::Basename;
use MIME::Base64;
use Authen::SASL;
use Cwd;
use File::Basename;

sub trim {
    my ($field) = @_;
    $field =~ s/^ +//;
    $field =~ s/ +$//;
    return $field;
}

sub sendmail {
   my ($email, $template, $subject) = @_;
   my %params;
   my %options;
   my $includepath = dirname($template);
   $options{'INCLUDE_PATH'} = $includepath;
       
   my $msg = MIME::Lite::TT::HTML->new(
                'Encoding'    => "quoted-printable",
                'Charset'     => "utf8",
                'From'        => "\"Team Ekkitab\" <support\@ekkitab.com>",
                'To'          => $email, 
                'Subject'     => $subject,
                'Template'    => { 'html' => basename($template) },
                'TmplOptions' => \%options,
                'TmplParams'  => \%params);

   print "Sending mail to: $email\n";

   #my $filetype = "application/ms-doc";

   #for (my $i=0; $i<=$#att; $i++) {
   #     my $filename = $att[$i];
   #     $msg->attach(Path => $filename,
   #                  Type => $filetype,
   #                  Filename => basename($filename),
   #                  Disposition => 'attachment'); 
   #}

   $msg->send('smtp', 'smtpout.secureserver.net', AuthUser=>'support@ekkitab.com', AuthPass=>'eki22Ab');
}

if (scalar(@ARGV) < 3) {
    print "Argument count is not correct! Exiting.\n";
    print "Usage: $0 <tolist-file> <subject> <template-file> \n";
    exit 0;
}


my $cwd  = getcwd();
$baseDir = dirname($cwd);
$tolist = $ARGV[0];
$subject = $ARGV[1];
$template = $ARGV[2];
my @attachments = ();
for (my $i = 3; $i<=$#ARGV; $i++) {
    $attachments[$i-3] = $ARGV[$i];
}

open ($fh, $tolist) or die "Cannot open file $tolist.";
while (<$fh>) {
	if (!($_ =~ /^#/)) {
		chomp;
		my $email = $_;
		sendmail($email, $template, $subject) ;
		sleep(2);
	}
}
