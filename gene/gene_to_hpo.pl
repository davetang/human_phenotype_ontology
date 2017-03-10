#!/usr/bin/env perl

use strict;
use warnings;

my $usage = "Usage: $0 <gene symbol>\n";
my $gene = shift or die $usage;

my $script_path = $0;
$script_path =~ s/\w+\.pl$/..\/data\//;
my $gene_to_hpo = $script_path . 'ALL_SOURCES_ALL_FREQUENCIES_genes_to_phenotype.txt.gz';

my $tally = 0;
open(IN, '-|', "gunzip -c $gene_to_hpo") || die "Could not open $gene_to_hpo: $!\n";
while(<IN>){
   chomp;
   next if (/^#/);
   my ($entrez_id, $entrez_gene_symbol, $hpo_name, $hpo_id) = split(/\t/);
   if ($entrez_gene_symbol eq $gene){
      ++$tally;
      print "$_\n";
   }
}
close(IN);

warn("There were $tally matches for $gene\n");

exit(0);

