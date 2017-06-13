#!/usr/bin/env perl

use strict;
use warnings;

my $usage = "Usage: $0 <HPO ID> [HPO ID]\n";

if (@ARGV == 0){
   die $usage;
}

my @hpo = @ARGV;

my $script_path = $0;
$script_path =~ s/\w+\.pl$/..\/data\//;
my $phenotype = $script_path . 'ALL_SOURCES_ALL_FREQUENCIES_phenotype_to_genes.txt.gz';

foreach my $hpo (@hpo){
   my $tally = 0;
   my $gene_list = '';
   my $desc = '';
   open(IN, '-|', "gunzip -c $phenotype") || die "Could not open $phenotype: $!\n";
   while(<IN>){
      chomp;
      next if (/^#/);
      # HP:0002683      Abnormality of the calvaria     84295   PHF6
      my ($hpo_id, $hpo_name, $entrez, $entrez_gene_symbol) = split(/\t/);
      if ($hpo_id eq $hpo){
         $gene_list .= "$entrez_gene_symbol, ";
         $desc = $hpo_name;
         ++$tally;
      }
   }
   close(IN);
   $gene_list =~ s/,\s$//;
   print join("\t", "$desc ($hpo)", $tally, $gene_list), "\n";
}

exit(0);

