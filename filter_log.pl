#!/usr/bin/perl

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
	}elsif( !($line =~m/ConjugateGradient: Iteration/) &&
		!($line =~m/ConjugateGradientMultiShift k=/) &&
		!($line =~m/ConjugateGradientMultiShift: shift \d+ target/) &&
		!($line =~m/Grid : Iterative/) &&
		!($line =~m/CGMultiShift: shift/)		
	    ){
	    print $line;
	}
    }
}


close(IN);
