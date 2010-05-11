#!/usr/bin/perl
sub main {

   if($ENV{'EKKITAB_HOME'} eq "")
   {
	die "EKKITAB_HOME not set!"
   }
   my $threads  = 10;
   my $ramptime = 5;
   my $logfile  = "$ENV{'EKKITAB_HOME'}/logs/jmeter_test_output.jtl";
   my $target   = "www.ekkitab.co.in";
   

   for($i=0;$i<@ARGV;$i+=2) {
       my($arg) = $ARGV[$i];
       if ($arg eq "-t") {
         $threads = $ARGV[$i+1];
       }
       elsif ($arg eq '-r') {
         $ramptime = $ARGV[$i+1];
       }
       elsif ($arg eq '-o') {
         $logfile = "$ENV{'EKKITAB_HOME'}/logs/" . $ARGV[$i+1];
       }
       elsif ($arg eq '-d') {
         $target = $ARGV[$i+1];
       }
       else {
	 die "Unknown argument $arg\n";
       }
   }

   print "Executing jmeter with the following parameters \n Number of threads : $threads \n" .
         "Ramp up Perid : $ramptime \n" .
         "Output Log File : $logfile\n" .
         "Target system : $target\n"; 


    
    my $file = "$ENV{'EKKITAB_HOME'}/test/jmeter-test-template";
    my $outputfile = "$ENV{'EKKITAB_HOME'}/test/jmeter_test_" . $threads . "_" . $ramptime . ".jmx";

    open (FILE, $file) or die "Cannot open test template";
    open (OUTPUT, ">", $outputfile) or die "Cannot open $outputfile to write test script.";

    local $/ = undef;
    my $contents = <FILE>;

    $contents =~ s/NUMBEROFTHREADS/$threads/;
    $contents =~ s/RAMPUPTIME/$ramptime/;
    $contents =~ s/OUTPUTFILE/$logfile/;
    $contents =~ s/TARGETSYSTEM/$target/;

    print OUTPUT $contents;

    close(OUTPUT);
    close(FILE);
    my $cmd = "$ENV{'EKKITAB_HOME'}/extern/jmeter/bin/jmeter";
    my $jmeterlog = "$ENV{'EKKITAB_HOME'}/logs/jmeter.log";

    my $jmeterTestRun = system("$cmd -n -t $outputfile"); #-l $jmeterlog");
}
main();
