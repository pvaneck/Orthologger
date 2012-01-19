#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Std;

# read data from stdin
# -c <col number>   which col (0 based) to read from
# -l <(lower) minx> min x value to include in histogram. Default is 0 for positive data, if negative values in data, min of them all is used as minx.
# -u <upper. xmax> max x val to include in histogram. Default is to include all values.
# -w <bin width> By default bin width is 1.

use vars qw($opt_c $opt_l $opt_u $opt_w $opt_g $opt_s);

# get options
getopts("c:l:u:w:hgs:");

print "# \'histogram.pl -c 1  -l -3.0 -u 11.0 -w 0.1 -s 150  < data\'\n";
print "# Use column 1 (0 based), lower upper limits -3.0 11.0, binwidth 0.1. Skip first 150 lines of data.\n";
#print "$opt_c,  $opt_l, $opt_u, $opt_w \n";
my $bigneg = -1.0e300;
my $bigpos = 1.0e300;

my $nskip = $opt_s || 0;
my $xcol = $opt_c; $xcol ||= 0;
my ($col1, $col2) = ($xcol =~ /(\d+)m(\d+)/)? ($1, $2): ($xcol, $xcol);
my $maxcol = ($col2 > $col1)? $col2: $col1;
my $xmin = $opt_l; 
my $xmax = $opt_u || undef; #by default determined from data
my $bw = $opt_w; $bw ||= 1.0;
my %xhash = ();
my %xmidhash = ();

my $data_xmax = $bigneg;
my $data_xmin = $bigpos;
# print "data xmin, xmax: $data_xmin $data_xmax\n";
my $data_all_ints = 1; 
my $count_valid_lines = 0; # lines with number in requested col(s)
while (<>) {
	chomp;
#print "$_ \n";
	next if(/^#/);
#	print "$_ \n";
	my @cols = split(" ", $_);		#split on whitespace
		next if(scalar @cols <= $maxcol);  #skip rows with not enough columns	
		my $x;
	if($xcol =~ /(\d)+m(\d+)/){ # can subtract values in 2 columns
		my $is_number1 = is_number($cols[$1]);
		my $is_number2 = is_number($cols[$2]);
		next unless($is_number1 and $is_number2);
		$count_valid_lines++;
		$data_all_ints &&= ($is_number1 == 1 and $is_number2 == 1); 	
		$x = $cols[$1] - $cols[$2];	
	}else{
		$x = $cols[$xcol];
# print "x: $x\n";
		my $is_number1 = is_number($x);
		next unless($is_number1);
		$count_valid_lines++;
		$data_all_ints &&= ($is_number1 == 1);
	}
	next if($count_valid_lines < $nskip);
	if($opt_g){ 
		$x = ($x > 0)? log($x)/log(10): -300; 
		print "log_10(x): $x\n";
	}
#	print "$_ \n";
#print (join("; ", @cols), "\n");
#print "x: $x \n\n";
	if (defined $x) {
#	print "x, dxmin, dxmax: $x  $data_xmin  $data_xmax\n";
#exit;
		$data_xmax = $x if($x > $data_xmax); # keep track of max and min x value so far.
			$data_xmin = $x if($x < $data_xmin);
		$xhash{$x}++; # store value in hash
	}
}

$xmax ||= $data_xmax; 
$xmin ||= ($data_xmin < 0)? $data_xmin: 0; # use cl arg if defined, otherwise 0 for nonneg data, min in data if neg.
#print "xmin/max: $xmin $xma/$bw/x \n"; exit;
#print "xmin, bw: ", $xmin, "  ", $bw,  "  ", $xmin % $bw, "\n";

# $xmin -= $xmin % $bw;

my $xow = $xmin / $bw;
if($xow >= 0){
	$xmin = $bw*(int $xow);
}else{
	$xmin = $bw*(int $xow - 1);
}
print "# xmin/max: $xmin $xmax\n";

#print "xmin/xmax: $xmin $xmax \n";
my $n_bins = int (($xmax - $xmin)/$bw) + 1;
#print "$bw, $n_bins \n";
my ($underflow_count, $overflow_count, $total_count) = (0, 0, 0);
if ($bw == 1 and $data_all_ints) {
	foreach my $x (keys %xhash){
		my $xcount = (defined $xhash{$x})? $xhash{$x}: 0;
		$total_count += $xcount;
		if($x < $xmin){ $underflow_count += $xcount; }
		elsif($x > $xmax){ $overflow_count += $xcount; }	
	}
	print "# underflow $underflow_count \n";
	for (my $j=$xmin; $j<=$xmax; $j++) {
		my $count = (defined $xhash{$j})? $xhash{$j}: 0;
		print $j, "  ", $count, "\n";
	}
} else {
#	print "xmin, bw: $xmin   $bw \n";
	foreach my $x (keys %xhash) {
		my $bin_n = int (($x - $xmin)/$bw);
#	print " $x   $xmin   $bin_n \n";
		my $binx = $xmin + ($bin_n + 0.5)*$bw; # center of the bin with width bw, lower edge at xmin+nbin*bw
#	print "x, binx, bin_n, xhash{} $_: ", $x, "  ", $binx, "  ", $bin_n, "  ", $xhash{$_}, "  ", $_, "\n";
# print "$bin_n, $_, ", $xhash{$_}, "\n";
			my $xcount = (defined $xhash{$x})? $xhash{$x} : 0;
		$total_count += $xcount;
		if($x < $xmin){ $underflow_count += $xcount; }
		elsif($x > $xmax){ $overflow_count += $xcount; }	
		$xmidhash{$bin_n} += $xcount; 
	}
	print "# underflow $underflow_count \n";
	for (my $jj=0; $jj<=$n_bins; $jj++) {
		my $xl = $xmin+$jj*$bw;
		my $midbin_x = $xl + 0.5*$bw;
		my $xu = $xl + $bw;
		my $count = (defined $xmidhash{$jj})? $xmidhash{$jj}: 0;
#		print($xl, "  ", $midbin_x, "  ", $xu, "  ",  $count, "\n");
#	print "$jj\n";
		printf("%12.6g %12.6g %12.6g   %10i \n", $xl, $midbin_x, $xu, $count);
	}
}
print "# overflow $overflow_count \n";
print "# ($underflow_count  ", $total_count-$underflow_count-$overflow_count, "  $overflow_count)  $total_count \n";


sub is_number{
	my $x = shift;
	if($x =~ /^\s*[-]?\d*[.]?\d*(e[-+]\d{1,3})?\s*$/){ # can have -, decimal pt., sci notation: -1.345e-07
		return ($x =~ /^\s*[-]?\d+\s*$/)? 1 : 2; # 1 for integer, 2 for float
	}else{
		return 0;
	}
}