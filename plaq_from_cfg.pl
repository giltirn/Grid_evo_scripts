#!/usr/bin/perl

#Output to a file and use gnuplot to show

$ARGC=scalar @ARGV;

if($ARGC < 1){
    print "Usage: <script.pl> <dir>\n";
    exit;
}

$dir = $ARGV[0];
@files = glob("$dir/ckpoint_lat.*");

@vals = ();

foreach $file (@files){
    if(!($file=~m/_lat\.(\d+)/)){
	print "Unexpected filename $file\n";
	exit 1;
    }
    $traj = $1;

    $plaq = `head $file | grep PLAQUETTE | awk '{print \$3}'`;
    #print "$traj $plaq";
    push(@vals, [$traj, $plaq]);
}
@vals_sorted = sort {$a->[0] <=> $b->[0] } @vals;

foreach $v (@vals_sorted){
    print "$v->[0] $v->[1]";
}
