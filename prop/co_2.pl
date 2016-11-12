#!/usr/bin/env perl

use strict;
use warnings;

my $usage = "Usage: $0 <first> <second>\n";
my $first = shift or die $usage;
my $second = shift or die $usage;

my $infile = 'cooccurrence.tsv.gz';
open(IN, '-|', "gunzip -c $infile") || die "Could not open $infile: $!\n";
while(<IN>){
   chomp;
   my ($hpo1, $hpo2, $omim)= split(/\t/);
   if (($first eq $hpo1 || $first eq $hpo2) && ($second eq $hpo1 || $second eq $hpo2)){
      print "$_\n";
   }
}
close(IN);

exit(0);


__END__
