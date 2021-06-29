#!/usr/bin/perl

#Extract the values of the impulse (F*dt) for each integrator for a specific trajectory
#Data sets are given in descending order through the nested integrator:  [0][0],  [0][1], ... [1][0],  [1][1] ... [N][0]... [N][N]   for  [level][integrator]

sub compare_sort
{
    $a=~m/(\d+) (\d+)/;
    my $a1=$1; 
    my $a2=$2;

    $b=~m/(\d+) (\d+)/;
    my $b1=$1; 
    my $b2=$2;

    if($a1 < $b1){
	return -1;
    }elsif($a1 > $b1){
	return 1;
    }else{
	if($a2 < $b2){
	    return -1;
	}elsif($a2 > $b2){
	    return 1;
	}else{
	    return 0;
	}
    }
}

$ARGC = scalar(@ARGV);
if($ARGC != 2){
    print "Need filename and start trajectory\n";
    exit 1;
}
$file = $ARGV[0];
$traj = $ARGV[1];

open(IN, $file);

%data = ();

$active = 0;
foreach $line (<IN>){
    if($active == 0){	 
	if($line =~m/# Trajectory = ${traj}/){
	    $active = 1;
	    #print $line;
	}
    }elsif($line=~m/\[(\d+)\]\[(\d)\] Force average:.*Max impulse: ([\d\.e\+\-]+)/){
	#print "$1 $2 $3\n";
	$key = "$1 $2";
	if( !( exists $data{$key}) ){
	    #print "Adding key $key\n";
	    $data{$key} = [];
	}
	#print "Push to key $key\n";
	push(@{$data{$key}}, $3);
    }
}

close(IN);

@keys = keys %data;
@keys_sorted = sort compare_sort (@keys);


foreach $key (@keys_sorted){
    @vals = @{$data{$key}};
    #print "$key\n";
    foreach $v (@vals){
	print "$v\n";	
    }
    print "\n";
}
