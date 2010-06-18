#!/usr/bin/perl
local $/=undef;
open (FILE, "<", $ENV{"EKKITAB_HOME"} . "/config/ekkitab.ini")  or die "Couldn't open file: $!";
$contents = <FILE>;
my $hostname = "";
my $user     = "";
my $password = "";
@params = $contents =~ m/^\[database\]\n(.*?)\n$/ms;
if ($#params >= 0) {
    my @tmp = $params[0] =~ m/server\s+=(.*?)\n/;
    $hostname = $tmp[0];
    $hostname =~ s/^\s+//;
    $hostname =~ s/\s+$//;
    my @tmp = $params[0] =~ m/user\s+=(.*?)\n/;
    $user = $tmp[0];
    $user =~ s/^\s+//;
    $user =~ s/\s+$//;
    my @tmp = $params[0] =~ m/password\s+=(.*?)\n/;
    $password = $tmp[0];
    $password =~ s/^\s+//;
    $password =~ s/\s+$//;
} 
print "$hostname $user $password";
