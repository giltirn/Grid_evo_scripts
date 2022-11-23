#!/usr/bin/perl

#Evaluate total and relative timings for force evaluation
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

%timings = ();

$max_lvl = 0;
$max_size = 0;

$refresh_start;
$refresh_end;
$init_S_start;
$init_S_end;
$final_S_start;
$final_S_end;
$action_eval = 0;

foreach $line (<IN>){
    if($active == 0){	 
	if($line =~m/# Trajectory = ${traj}/){
	    $active = 1;
	    $action_eval=0;
	    print $line;
	}
    }else{ #active==1
	if($line =~m/# Trajectory = ${trajp1}/){
	    $active = 0;
	}elsif($line =~m/\[(\d+)\]\[(\d+)\] P update.*force\:\s([\d\.e\+\-]+)\sms/){
	    #print $line;
	    #Line format example
	    #Grid : Message : 5091.201567 s : [2][0] P update elapsed time: 3261.785 ms (force: 3252.475 ms)
	    print "$1 $2 $3 ms\n";
	    $key="$1 $2";
	    if(!(exists $timings{$key})){
		$timings{$key}=$3;
	    }else{
		$timings{$key}+=$3;
	    }
	    if($1 > $max_lvl){
		$max_lvl = $1;
	    }
	    if($2 > $max_size){
		$max_size = $2;
	    }	    
	}elsif($line=~m/\:\s([\d\.]+)\ss\s\:\sIntegrator\srefresh/){
	    $refresh_start = $1;
	}elsif($line=~m/\:\s([\d\.]+)\ss\s\:\sIntegrator\saction/){
	    if($action_eval == 0){
		$refresh_end=$1;
		$init_S_start=$1;
	    }else{
		$final_S_start=$1;
	    }
	    $action_eval++;	    
	}elsif($line=~m/\:\s([\d\.]+)\ss\s\:\sTotal\sH\sbefore\strajectory/){
	    $init_S_end=$1;
	}elsif($line=~m/\:\s([\d\.]+)\ss\s\:\sTotal\sH\safter\strajectory/){
	    $final_S_end=$1;
	}
    }
}

close(IN);

print "Timings:\n";
$total_hrs = 0;
for($i=0;$i<=${max_lvl};$i++){
    for($j=0;$j<=${max_size};$j++){
	$key = "$i $j";
	if(exists $timings{$key}){
	    $hours = $timings{$key} / 1000 /60/60;
	    print "$key $hours hrs\n";
	    $total_hrs += $hours;
	}
    }
}
print "Total force time: ${total_hrs} hrs\n";

print "Relative timings:\n";
for($i=0;$i<=${max_lvl};$i++){
    for($j=0;$j<=${max_size};$j++){
	$key = "$i $j";
	if(exists $timings{$key}){
	    $frac = $timings{$key} / 1000 /60/60 / ${total_hrs};
	    print "$key $frac\n";
	}
    }
}

$refresh_hrs = ($refresh_end-$refresh_start)/60/60;
$init_S_hrs = ($init_S_end-$init_S_start)/60/60;
$final_S_hrs = ($final_S_end-$final_S_start)/60/60;
$total_hrs_job = $refresh_hrs + $init_S_hrs + $total_hrs + $final_S_hrs;


print "Refresh $refresh_hrs hrs\n";
print "Initial action $init_S_hrs hrs\n";
print "Final action $final_S_hrs hrs\n";
print "Total job $total_hrs_job hrs\n";



	    

	
