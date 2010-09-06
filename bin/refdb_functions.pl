#!/usr/bin/perl 
use strict;
use DBI;
my $dbhandle = DBI->connect('dbi:mysql:reference','root','root');
$dbhandle->{PrintError} = 0;
if(!$dbhandle){
    print "DB Connection Failure!!\n";
    exit;
}

sub ifexists{
my $sql = "select count(1) from ignore_isbns where isbn = '$_[0]'";
my $execute = $dbhandle->prepare($sql);
$execute->execute;
my $success = $execute->fetchrow_array;
    if($success){
        return 1;
    }
    else{
        return 0;
    }
}
1;
