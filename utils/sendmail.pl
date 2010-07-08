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
   my ($replace, $template, $subject) = @_;
   my $to = trim($$replace[0]);
   my $to_email = trim($$replace[1]);
   my $password = trim($$replace[2]);
   my $from_email = trim($$replace[3]);
   my $from = trim($$replace[4]);
   my $from_name = trim($$replace[5]);

   my %params;
   $params{'Name'} = $to;
   $params{'UserId'} = $to_email;
   $params{'Password'} = $password;
   $params{'Sender'} = $from;
   my %options;
   $options{'INCLUDE_PATH'} = "/home/vijay/tmp";
       
   my $msg = MIME::Lite::TT::HTML->new(
                'From'        => "\"$from_name\" <$from_email>",
                'To'          => $to_email, 
                'Subject'     => $subject,
                'Template'    => { html => basename($template) },
                'TmplOptions' => \%options,
                'TmplParams'  => \%params);

   print "Sending mail to: $to at address: $to_email\n";
   #print "Debug: $#att\n";

   #my $filetype = "application/ms-doc";

   #for (my $i=0; $i<=$#att; $i++) {
   #     my $filename = $att[$i];
   #     $msg->attach(Path => $filename,
   #                  Type => $filetype,
   #                  Filename => basename($filename),
   #                  Disposition => 'attachment'); 
   #}

   $msg->send('smtp', 'mailhub.ltp.soft.net', AuthUser=>'vijay', AuthPass=>'');
}

if (scalar(@ARGV) < 3) {
    print "Argument count is not correct! Exiting.\n";
    print "Usage: $0 tolist-file subject template-file\n";
    exit 0;
}

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
        my @params = split(/,/);
        sendmail(\@params, $template, $subject) ;
    }
}
