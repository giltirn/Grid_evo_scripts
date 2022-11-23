#!/usr/bin/perl

#Compute total time spent on each integrator component for a specific configuration
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

%data = ();

foreach $line (<IN>){
    if($active == 0){	 
	if($line =~m/# Trajectory = ${traj}/){
	    $active = 1;
	    #print $line;
	}
    }else{
	if($line =~m/# Trajectory = ${trajp1}/){
	    $active = 0;
#[0][2] P update elapsed time: 41084.655 ms 

	}elsif($line =~m/(\[\d+\]\[\d+\]) P update elapsed time\: ([\d\.e\+\-]+) ms/){
	    $int=$1;
	    $t=$2;
	    #print "$int $t\n";
	    if(!(exists $data{$int})){
		$data{$int} = $t;
	    }else{
		$data{$int} += $t;
	    }
	}
    }
}

close(IN);

foreach $int (keys %data){
    print "$int $data{$int} ms\n";
}
