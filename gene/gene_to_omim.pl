#!/usr/bin/env perl

use strict;
use warnings;

my $usage = "Usage: $0 <gene symbol>\n";
my $gene = shift or die $usage;

my $script_path = $0;
$script_path =~ s/\w+\.pl$/..\/data\//;
my $gene_to_omim = $script_path . 'hgnc_symbol_mim_morbid.tsv.gz';

my $tally = 0;
open(IN, '-|', "gunzip -c $gene_to_omim") || die "Could not open $gene_to_omim: $!\n";
while(<IN>){
   chomp;
   next if (/^#/);
   my ($hgnc, $omim) = split(/\t/);
   if ($hgnc eq $gene){
      ++$tally;
      print "$_\n";
   }
}
close(IN);

warn("There were $tally matches for $gene\n");

exit(0);

