#!/usr/bin/perl
#use this script to tail 
sub main {

   if($ENV{'EKKITAB_HOME'} eq "")
   {
	die "EKKITAB_HOME not set!";
   }

   if($#ARGV != 0)
   {
 	die "Not enough arguments!!";
   }
my $cmd = "$ENV{'EKKITAB_HOME'}/bin/tail";
#print"$cmd\n";
my $tail_file = print("$cmd -f $ARGV[0]\n");
#print"$ARGV[0]\n";
}
main();
