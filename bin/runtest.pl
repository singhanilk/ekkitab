#!/usr/bin/perl
sub main {
    if ($#ARGV != 1) {
        print "Insufficient arguments!\n";
        print "Usage: runtest.pl <num threads> <rampup time>\n";
        exit(1);
    }
    my $threads  = $ARGV[0];
    my $ramptime = $ARGV[1];
  
    my $file = "$ENV{'EKKITAB_HOME'}/test/jmeter-test-template";
    my $outputfile = "$ENV{'EKKITAB_HOME'}" . "/test/jmeter_test_" . $threads . "_" . $ramptime . ".jmx";

    open (FILE, $file) or die "Cannot open test template";
    open (OUTPUT, ">", $outputfile) or die "Cannot open $outputfile to write test script.";

    local $/ = undef;
    my $contents = <FILE>;

    $contents =~ s/NUMBEROFTHREADS/$threads/;
    $contents =~ s/RAMPUPTIME/$ramptime/;

    print OUTPUT $contents;

    close(OUTPUT);
    close(FILE);
}
main();
