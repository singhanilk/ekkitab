#!/usr/bin/perl
use MIME::Lite::TT::HTML;
use File::Basename;

sub trim {
    my ($field) = @_;
    $field =~ s/^ +//;
    $field =~ s/ +$//;
    return $field;
}

sub sendmail {
   my ($name, $fullname, $email, $template, $subject, $body) = @_;

   my %params;
   $params{'Name'} = $name;
   $params{'Sender'} = "Ekkitab Customer Support"; 
   $params{'Content'} = $body; 
   my %options;
   $options{'INCLUDE_PATH'} = "./data";
       
   my $msg = MIME::Lite::TT::HTML->new(
                'Encoding'    => "quoted-printable",
                'Charset'     => "utf8",
                'From'        => "\"Ekkitab Customer Support\" <support\@ekkitab.com>",
                'To'          => "\"$fullname\"<$email>", 
                'Bcc'         => "\"Saran Raj M.\"<saran\@ekkitab.com>", 
                'Subject'     => $subject,
                'Template'    => { html => basename($template) },
                'TmplOptions' => \%options,
                'TmplParams'  => \%params);

   print "Sending support mail to: $name at address: $email\n";
   #print "Debug: $#att\n";

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
    print "Usage: $0 <name> <full name> <email> <subject>\n";
    exit 0;
}

my $name      = $ARGV[0];
my $fullname  = $ARGV[1];
my $email     = $ARGV[2];
my $subject   = $ARGV[3];
my $template  = "./data/support.html";
my @attachments = ();
for (my $i = 3; $i<=$#ARGV; $i++) {
    $attachments[$i-3] = $ARGV[$i];
}
local $/ = undef;
$userinput =  <STDIN>;
chomp ($userinput);
$userinput =~ s/\n\n/<p>/g;
$userinput =~ s/\n/ /g;
sendmail($name, $fullname, $email, $template, $subject, $userinput) ;
