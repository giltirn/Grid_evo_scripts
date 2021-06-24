#!/usr/bin/perl

#Output to a file and use gnuplot to show

$ARGC=scalar @ARGV;

if($ARGC < 1){
    print "Usage: <script.pl> <log1> <log2> ...\n";
    exit;
}

@logs = ();
for($i=0;$i<$ARGC;$i++){
    push(@logs, $ARGV[$i]);
}

foreach $log (@logs){
    #print "$log\n";

    #@vals=();
    open(IN, $log);
    foreach $line (<IN>){
	if($line=~m/Plaquette:\s\[\s*(\d+)\s*\]\s([\d\.e\+\-]+)/){
	    #push(@vals, $1);
	    print "$1 $2\n";
	}
    }
    close(IN);

}
