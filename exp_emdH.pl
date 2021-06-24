#!/usr/bin/perl

#Output to a file and use gnuplot to show

$ARGC=scalar @ARGV;

if($ARGC < 2){
    print "Usage: <script.pl> <bin size> <log1> <log2> ...\n";
    exit;
}

$binsz=$ARGV[0];
@logs = ();
for($i=1;$i<$ARGC;$i++){
    push(@logs, $ARGV[$i]);
}

foreach $log (@logs){
    #print "$log\n";

    @vals=();
    open(IN, $log);
    foreach $line (<IN>){
	if($line=~m/exp\(\-dH\)\s=\s([\d\.e\+\-]+)/){
	    push(@vals, $1);
	}
    }
    close(IN);
 
    
    $nval=scalar @vals;
    print "Found $nval values\n";

    @block = ();
    for($i=0;$i<$nval;$i++){
	push(@block, $vals[$i]);
	if(scalar @block > $binsz){
	    shift(@block);
	    if(scalar @block != $binsz){
		print "huh?";
		exit;
	    }
	    $avg = 0;
	    for($b=0;$b<$binsz;$b++){
		$avg += $block[$b];
	    }
	    $avg/=$binsz;
	    print("$avg\n");
	}
    }
}
