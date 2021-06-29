#!/usr/bin/perl

#Parse deltaH from logs

$ARGC=scalar @ARGV;

if($ARGC < 1){
    print "Usage: <script.pl> <log1> <log2> ...\n";
    exit;
}

@logs = ();
for($i=0;$i<$ARGC;$i++){
    push(@logs, $ARGV[$i]);
}

$traj="";

foreach $log (@logs){
    open(IN, $log);
    foreach $line (<IN>){
	if($line=~m/\# Trajectory = (\d+)/){
	    $traj=$1;
	}elsif($line=~m/Total H after trajectory.*dH = ([\d\.e\+\-]+)/){
	    $dH=$1;
	    print "$traj $dH\n";
	}
    }
    close(IN);
 }
