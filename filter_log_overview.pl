#!/usr/bin/perl

#Filter only critical information for a specific trajectory from a log
$ARGC = scalar(@ARGV);
if($ARGC != 2){
    print "Need filename and trajectory\n";
    exit 1;
}
$file = $ARGV[0];
$traj = $ARGV[1];
$trajp1 = $traj + 1;

open(IN, $file);

$active = 0;
foreach $line (<IN>){
    if($active == 0){	 
	if($line =~m/# Trajectory = ${traj}/){
	    $active = 1;
	    print $line;
	}
    }else{
	if($line =~m/# Trajectory = ${trajp1}/){
	    $active = 0;
	}elsif( ($line =~m/S \[\d+\]\[\d+\]/) ||
		($line =~m/Total H/) ||
		($line =~m/\[\d+\]\[\d+\] Force average:/) ||
		($line =~m/\[\d+\]\[\d+\] P update /) ||
		($line =~m/Integrator (refresh|action)/)		
	    ){
	    print $line;
	}
    }
}


close(IN);
