#!/usr/bin/env perl

use strict;
use warnings;

my $usage = "Usage: $0 <gene symbol> [HPO ID]\n";

if (@ARGV == 0){
   die $usage;
}

my $gene = shift(@ARGV);

my @hpo = ();
if (scalar(@ARGV) > 0){
   @hpo = @ARGV;
}
my @hpo_match = ();
my $hpo_match = 0;
my $hpo_total = scalar(@hpo);

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
      foreach my $h (@hpo){
         $h =~ s/,//g;
         if ($hpo_id eq $h){
            ++$hpo_match;
            my $tmp = $hpo_id . " $hpo_name";
            push(@hpo_match, $tmp);
         }
      }
   }
}
close(IN);

warn("There were $tally matches for $gene\n");
warn("There were $hpo_match match/es out of $hpo_total input HPO terms @hpo_match\n") if $hpo_total > 0;

exit(0);

