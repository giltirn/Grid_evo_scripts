#!/usr/bin/perl

#Output to a file and use gnuplot to show

$ARGC=scalar @ARGV;

if($ARGC < 3){
    print "Usage: <script.pl> <start config> <bin size> <log1> <log2> ...\n";
    exit;
}

$start=$ARGV[0];
$bin_size=$ARGV[1];
@logs = ();
for($i=2;$i<$ARGC;$i++){
    push(@logs, $ARGV[$i]);
}

@vals=();
foreach $log (@logs){
    open(IN, $log);
    foreach $line (<IN>){
	if($line=~m/Plaquette:\s\[\s*(\d+)\s*\]\s([\d\.e\+\-]+)/){
	    if($1 >= $start){
		push(@vals, $2);
		#print "$1 $2\n";
	    }
	}
    }
    close(IN);

}

$nval=scalar @vals;

@binned_vals = ();
$nbin=0;
{
    use integer;
    $nbin = $nval / $bin_size;
}
print "$nval values, bin size $bin_size => $nbin bins\n";

for($b=0;$b<$nbin;$b++){
    $v=0;
    $bin_start = $b*$bin_size;
    $bin_lessthan = $bin_start + $bin_size;

    for($i=$bin_start ; $i < $bin_lessthan; $i++){
	$v += $vals[$i];
    }
    $v /= $bin_size;
    push(@binned_vals, $v);
}


$avg2=0;
$avg=0;
foreach $val (@binned_vals){
    $avg2 += $val*$val;
    $avg += $val;
}
$avg2/=$nbin;
$avg/=$nbin;

$var=$avg2 - $avg*$avg;
$std_dev = sqrt($var);
$std_err = sqrt($var/$nbin);

print "Values $nval Mean $avg Std.Dev $std_dev Std.Err $std_err\n";


